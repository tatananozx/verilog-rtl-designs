module sipo_4bit_async (
    input  wire clk, rst_n, serial_in,
    output reg [3:0] parallel_out
);
    reg [3:0] q;   //Internal 4-bit register — holds the current state of all 4 flip-flops (Q3 Q2 Q1 Q0).

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 4'b0000;
        else
            q <= {q[2:0], serial_in};   // shift left, new bit enters LSB
    end

    assign parallel_out = q;
endmodule


module sipo_4bit_sync (
    input  wire clk, rst, serial_in,   // active-high sync reset
    output reg [3:0] parallel_out
);
    reg [3:0] q;

    always @(posedge clk) begin   // only clk in sensitivity list
        if (rst)
            q <= 4'b0000;
        else
            q <= {q[2:0], serial_in};
    end

    assign parallel_out = q;
endmodule


//INDUSTRY SHORTHAND
module sipo_n #(parameter N = 8) (
    input  wire clk, rst_n, serial_in,
    output wire [N-1:0] parallel_out
);
    reg [N-1:0] shreg;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) shreg <= {N{1'b0}};
        else        shreg <= {shreg[N-2:0], serial_in};
    assign parallel_out = shreg;
endmodule