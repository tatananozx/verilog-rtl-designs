module and_dataflow(
    input a,b,
    output y        \\ y is wire as we use assign
);
assign y = a & b;
endmodule



module and_behavioral(
    input a,b,
    output reg y     \\ whenever using always block, any signal
);                   \\assigned must bedeclared as reg
always @(*)
begin
    y = a & b;
end
endmodule



module and_gate_level(
    input a,b,
    output y
);
and g1(y,a,b);
endmodule



