module fifo (                       //simple design of fifo
    input clk, rst_n,
    input wr_en, rd_en,
    input [7:0] din,
    output reg [7:0] dout,
    output full, empty
);

reg [7:0] mem [0:15];       // 16-deep, 8-bit wide
reg [4:0] wr_ptr, rd_ptr;   // 4 bits for addr + 1 extra bit

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        wr_ptr <= 0;
    else if (wr_en && !full) begin
        mem[wr_ptr[3:0]] <= din;
        wr_ptr <= wr_ptr + 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rd_ptr <= 0;
        dout   <= 0;
    end else if (rd_en && !empty) begin
        dout   <= mem[rd_ptr[3:0]];
        rd_ptr <= rd_ptr + 1;
    end
end

assign empty = (wr_ptr == rd_ptr);
assign full  = (wr_ptr[4] != rd_ptr[4]) && (wr_ptr[3:0] == rd_ptr[3:0]);

endmodule










//complex one with all the required extension-directly copy paste understand it later on
module sync_fifo_async_rst #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  wire                   clk,
    input  wire                   rst_n,     // async, active-low
    input  wire                   wr_en,
    input  wire [DATA_WIDTH-1:0] din,
    input  wire                   rd_en,
    output reg  [DATA_WIDTH-1:0] dout,
    output wire                   full,
    output wire                   empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_WIDTH:0] wr_ptr, rd_ptr;   // extra MSB bit

    // Write pointer + memory write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            wr_ptr <= 0;
        else if (wr_en && !full) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= din;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // Read pointer + registered data out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            dout   <= 0;
        end else if (rd_en && !empty) begin
            dout   <= mem[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Full / empty — combinational, binary pointer compare
    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
                    (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

endmodule