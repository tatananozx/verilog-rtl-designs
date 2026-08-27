module d_ff(
    input wire d,rst_n,clk,
    output reg q 
);

always @(posedge clk) begin
    if(!rst_n) 
    q <= 1'b0;
    else 
    q <= d;
end
endmodule
                                               // synchronus 4-bit register made from 4 D FLIP FLOPS
module register_4bit(
    input wire rst_n,clk,
    input wire [3:0] d,
    output wire [3:0] q
);

d_ff ff0 (.clk(clk), .rst_n(rst_n), .d(d[0]), .q(q[0]));   //named port connection
d_ff ff1 (.clk(clk), .rst_n(rst_n), .d(d[1]), .q(q[1]));
d_ff ff2 (.clk(clk), .rst_n(rst_n), .d(d[2]), .q(q[2]));
d_ff ff3 (.clk(clk), .rst_n(rst_n), .d(d[3]), .q(q[3]));
endmodule



module register_4bit_sync(
    input wire clk,rst_n,
    input wire [3:0] d,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (!rst_n)
    q <= 1'b0000;
    else
    q <= d;
end
endmodule



module register_4bit_async(
    input wire clk,rst_n,
    input wire [3:0] d,
    output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    q <= 1'b0000;
    else
    q <= d;
end
endmodule




module reg4_en (                                //industry shorthand
    input  wire       clk, rst_n, en,
    input  wire [3:0] d,
    output reg  [3:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)   q <= 4'b0000;
        else if (en) q <= d;   // hold when en=0 — no explicit else needed, register holds by default
    end
endmodule

//In an always @(posedge clk) block, a missing else does NOT infer a latch — it infers normal register hold behavior, because the block is already edge-triggered. Latch inference only happens in always @(*) combinational blocks with incomplete branches.