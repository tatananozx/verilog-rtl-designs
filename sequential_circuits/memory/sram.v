module sram_sync_read #(parameter DATA_W = 8, parameter ADDR_W = 4)(
    input  wire                  clk,  //synchronous clock
    input  wire                  we,  // write enable- 1 for write and 0 for read
    input  wire [ADDR_W-1:0]     addr,// address for read/write
    input  wire [DATA_W-1:0]     din,// data input for write
    output reg  [DATA_W-1:0]     dout // data output for read
);
// 1-cycle latency synchronous read/write SRAM
    reg [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];  // no reset — matches real SRAM

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;      // write
        else
            dout <= mem[addr];    // read — registered, 1-cycle latency
    end

endmodule



module sram_async_read #(parameter DATA_W = 8,parameter ADDR_W = 4)(
    input  wire                  clk,
    input  wire                  we,
    input  wire [ADDR_W-1:0]     addr,
    input  wire [DATA_W-1:0]     din,
    output wire [DATA_W-1:0]     dout
);
// 0-cycle latency asynchronous read/write SRAM
    reg [DATA_W-1:0] mem [0:(1<<ADDR_W)-1];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
    end

    assign dout = mem[addr];  // combinational — no clock latency, but longer combo path downstream

endmodule