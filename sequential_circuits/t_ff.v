module d_ff(
    input wire d,clk,rst_n,
    output reg q
);

always@(posedge clk) begin
    if(!rst_n) 
    q <= 1'b0;
    else q <= d;
end
endmodule

module t_ff_strucural(
   input wire t,clk,rst_n,
   output wire q
);

wire d;
assign d = t ^ q;  //core equation D = T XOR Q

d_ff uut (.d(t), .clk(clk), .rst_n(rst_n), .q(q));
endmodule