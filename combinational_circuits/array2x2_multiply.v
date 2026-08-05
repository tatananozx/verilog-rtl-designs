module array2x2_miltiply(
    input [1:0] a,b,
    output [3:0] p
);
always @(*) begin
    p = a * b;      //use this carefully in some tools, it may infer a multiplier which is not what we want in this case.
end
endmodule


module array2x2_miltiply_dataflow(
    input [1:0] a,b,
    output [3:0] p
);

wire pp00,pp10,pp01,pp11;                            
wire sum1,carry1;

assign pp00 = a[0] & b[0];
assign pp10 = a[1] & b[0];
assign pp01 = a[0] & b[1];
assign pp11 = a[1] & b[1];

// HALF ADDER FIRST WITH pp10 AND pp01 and ouput sum1 and carry1
assign sum1 = pp10 ^ pp01;
assign carry1 = pp10 & pp01;

//half adder 2 with sum1 and pp11 as input and output p[2] and p[3]
assign p[2] = pp11 ^ carry1;
assign p[3] = pp11 & carry1;
assign p[0] = pp00;
assign p[1] = sum1;
endmodule