module d_latch(
    input wire d,en,
    output reg q
);
always@(*) begin
    if (en) 
    q = d; //transparent when enable = 1, latch inferred intentionally
end
endmodule

module d_ff(
    input wire d,clk,
    output wire q
);

wire qm,clk_n;
assign clk_n = ~clk;   //or one liner wire clk_n = ~clk;

d_latch master (.d(d), .en(clk_n), .q(qm)); //transparent when clk=0
d_latch slave (.d(qm), .en(clk), .q(q));  //transparent when clk=1
endmodule




module sr_ff_sync_reset(
    input wire d,clk,rst_n,
    output reg q
);

always @(posedge clk) begin
    if (!rst_n) 
    q <= 1'b0;
    else 
    q <= d;
end
endmodule

module sr_ff_async_reset(
    input wire d,clk,rst_n,
    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
    q <= 1'b0;
    else 
    q <= d;
end
endmodule