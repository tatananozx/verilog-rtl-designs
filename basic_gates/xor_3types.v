module xor_dataflow(input a,b, output y);
 assign y = a ^ b;
endmodule

module xor_behavioral(input a,b, output reg y);
 always @(*)
 begin
    y = a ^ b;
 end
endmodule

module xor_gate_level(input a,b, output y);
 xor g1(y,a,b);
endmodule