module mux2_1df(
    input s,
    input i0,
    input i1,
    output y
);                            // WE CAN USE BOOLEAN EQAUTION ALSO BUT TERNARY MORE EFFICIENT AND EASY TO UNDERSTAND
    assign y = s? i1 : i0;    //TERNARY OPERATOR USED WHEN CONDITION IS INVOLVED SO ITS LIKE IF S=1 THEN Y=I1 ELSE Y=I0
endmodule


// structural modeling of 2:1 MUX
module mux2_1s(
    input s,i0,i1,
    output y
);
wire not_s,w2,w3;

not g1(not_s,s);
and g2(w2,i0,not_s);
and g3(w3,i1,s);
or g4(y,w2,w3);
endmodule

//behaviroal modeling of 2:1 MUX
module mux2_1b(
    input s,i0,i1,
    output reg y
);
  always @(*)
  begin
    if(s==1) y=i1;
    else y=i0;
  end
endmodule
