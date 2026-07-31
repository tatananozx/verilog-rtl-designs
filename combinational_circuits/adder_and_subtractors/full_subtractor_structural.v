module full_subtractor(
    input A,B,Bin,
    output Diff,Bout
);
                                  // Diff = A XOR B XOR Bin      //Bout = A'B + A'Bin + BBin
wire w1,w2,w3,w4,w5;

xor g0(w1,A,B);
xor g1(Diff,w1,Bin);
not g2(w2,A);        // w2 is the complement of A
and g3(w3,w2,B);
and g4(w4,w2,Bin);
and g5(w5,B,Bin);
or g6(Bout,w3,w4,w5);                
endmodule                       // 7 gates and 38 transistors