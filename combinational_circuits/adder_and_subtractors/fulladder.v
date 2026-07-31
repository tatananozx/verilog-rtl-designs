module full_adder(
    input a,b,cin,
    output sum,carry                               // 2 xor gate 2 and gate 1 or gate
);                                                // 1 wire for a^b o\p                                              
  wire w1,w2,w3;                                 // 2 wire for a&b o\p              // 3 wire for w1&cin o\p
  xor g1(w1,a,b);
  xor g2(sum,w1,cin);
  and g3(w2,a,b);
  and g4(w3,w1,cin);                              // also see full adder using 2 half adder****************
   or g5(carry,w2,w3);
endmodule  

//full adder in dataflow style
// module full_adder(input a,b,cin, output sum,carry);
//assign sum = (a ^ b ^ cin);
//assign carry = (a&b) | (b&cin) | (cin&a);
// endmdoule


//fulladder in behavioral style
//module full_adder(input a,b,cin, output reg sum,carry);
//always @(*)
//begin
//sum = (a^b^cin);
//carry = (a&b) | (b&cin) | (cin&a);
//endmodule 