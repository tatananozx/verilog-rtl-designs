module lifo #(parameter WIDTH = 8, parameter DEPTH = 8)(
    input  wire clk, rst,
    input  wire push, pop,
    input  wire [WIDTH-1:0] din,
    output reg  [WIDTH-1:0] dout
); // simple version remembering the last value popped, no empty/full flags, no overflow/underflow checking
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [3:0] sp;   // enough bits for DEPTH=8..16, hardcode for now

    always @(posedge clk) begin
        if (rst)
            sp <= 0;
        else if (push) begin
            mem[sp] <= din;
            sp <= sp + 1;
        end
        else if (pop) begin
            sp <= sp - 1;
            dout <= mem[sp - 1];
        end
    end
endmodule







//complex version with synchronous reset, full/empty flags, and overflow/underflow checking used to cover more corner cases in the testbench so that the LIFO can be verified more thoroughly
module lifo_sync_rst #(
    parameter WIDTH = 8,
    parameter DEPTH = 8
)(
    input  wire              clk,
    input  wire              rst,     // sync, active-high
    input  wire              push,
    input  wire              pop,
    input  wire [WIDTH-1:0] din,
    output reg  [WIDTH-1:0] dout,
    output wire             full,
    output wire             empty
);
    localparam PTR_W = $clog2(DEPTH);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [PTR_W-1:0] sp;      // next free slot
    reg [PTR_W:0]   count;   // 0..DEPTH

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    wire do_push = push && !full;
    wire do_pop  = pop  && !empty;

    always @(posedge clk) begin
        if (rst) begin
            sp    <= 0;
            count <= 0;
            dout  <= 0;
        end else begin
            case ({do_push, do_pop})
                2'b10: begin                 // push only
                    mem[sp] <= din;
                    sp      <= sp + 1'b1;
                    count   <= count + 1'b1;
                end
                2'b01: begin                 // pop only
                    dout  <= mem[sp - 1'b1];
                    sp    <= sp - 1'b1;
                    count <= count - 1'b1;
                end
                2'b11: begin                 // simultaneous: replace top, sp/count hold
                    dout         <= mem[sp - 1'b1];
                    mem[sp - 1'b1] <= din;
                end
                default: ;                    // idle or blocked (full push / empty pop)
            endcase
        end
    end
endmodule