// TRUTH TABLE
// A  B  Bin  DIFFERENCE BORROW
// 0  0  0      0          0
// 0  0  1      1          1
// 0  1  0      1          1
// 0  1  1      0          1
// 1  0  0      1          0
// 1  0  1      0          0
// 1  1  0      0          0
// 1  1  1      1          1

 
 module full_subtractor_d(input a,b,bin, output diff,borrow);
 assign diff = a ^ b ^ bin ;                                                  // DATA FLOW STYLE
 assign borrow = (~a & b) | (~a & bin) | (b & bin) ;
 endmodule

 module full_subtractor_b( input a,b,bin output reg diff,borrow);
    always @(*)                                                                // BEHAVIORAL STYLE
    begin
        diff = a^b^bin;
        borrow = ~a&b | ~a&bin | b&bin ;
    end
 endmodule

 module full_subtractor_s(
    input a,b,bin,
    output diff,borrow);
                                                            //structural style
 wire w1,w2,w3,w4,w5;

 xor g1(w1,a,b);
 xor g2(diff,w1,bin);                                       // w5 is the complement of a
 not g3(w5,a);
 and g4(w2,w5,b);
 and g5(w3,w5,bin);
 and g6(w4,b,bin);
 or g7(borrow,w2,w3,w4);
 endmodule
 