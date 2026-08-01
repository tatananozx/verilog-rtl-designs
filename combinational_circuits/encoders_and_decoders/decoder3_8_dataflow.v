module decoder_3to8_dataflow(
    input i0,i1,i2,
    input EN,
    output [7:0] y  // also declare as: output y0,y1,y2,y3,y4,y5,y6,y7
);

assign y[0] = EN & ~i2 & ~i1 & ~i0;                                              
assign y[1] = EN & ~i2 & ~i1 & i0;
assign y[2] = EN & ~i2 & i1 & ~i0;
assign y[3] = EN & ~i2 & i1 & i0;
assign y[4] = EN & i2 & ~i1 & ~i0;
assign y[5] = EN & i2 & ~i1 & i0;
assign y[6] = EN & i2 & i1 & ~i0;
assign y[7] = EN & i2 & i1 & i0;

endmodule


//module decoder_NtoM #(parameter N = 3)(     // parameterized module, can be used for any N and M=2^N
//  input  [N-1:0]       sel,
//  input               en,
//  output [(1<1:0] y
//);
//assign y = en ? (1 << sel) : 0;
//endmodule
// N=3 → 8 outputs automatically
// N=2 → 4 outputs automatically
// same module, any size