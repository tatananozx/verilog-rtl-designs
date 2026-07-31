// A   B    DIFFERENCE  BORROW          DIFF = A XOR B
// 0   0       0           0            BORROW = A' AND B
// 0   1       1           1
// 1   0       1           0
// 1   1       0           0

module half_subtractor_d(
    input a,b,
    output diff,borrow);               //DATA FLOW STYLE
 assign diff = a ^ b;
 assign borrow = ~a & b;
endmodule


                                                    // STRUCTURAL STYLE
module half_subtractor_s(
    input a,b,
    output diff,borrow);                         // a wire for ~a because its before and operation

    wire a';

    xor g1(diff,a,b);
    not g2(a',a);
    and g3(borrow,a',b);
endmodule


// BEHAVIORAL SYLE

module half_subtractor_b(input a,b, output reg diff,borrow);
 always @(*)
 begin
    diff = a ^ b;
    borrow = ~a & b;   // dont use ' for not in behavioral style, use ~ instead
 end
endmodule