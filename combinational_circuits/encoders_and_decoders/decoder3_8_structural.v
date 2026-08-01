module decoder_3to8_structural(
    input i0,i1,i2,
    input en,
    output y0,y1,y2,y3,y4,y5,y6,y7  // can be declared as: output [7:0] y and then use y[0], y[1], ... y[7] in the code
);

                                  // also with help of 2:8 decoder we can make 3:8 decoder, but here we will do it directly with gates, more efficient for small N
wire ni0, ni1, ni2;
not n0(ni0,i0);
not n1(ni1,i1);
not n2(ni2,i2);


and g0(y0,en,ni2,ni1,ni0);
and g1(y1,en,ni2,ni1,i0);
and g2(y2,en,ni2,i1,ni0);
and g3(y3,en,ni2,i1,i0);
and g4(y4,en,i2,ni1,ni0);
and g5(y5,en,i2,ni1,i0);
and g6(y6,en,i2,i1,ni0);
and g7(y7,en,i2,i1,i0);
endmodule