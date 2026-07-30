module or_dataflow(
    input a,b,
    output y
);
assign y = a | b;
endmodule

module or_behavioral(
    input a,b
    output reg y
);
always @(*)
begin
    y = a|b;
end
endmodule

module or_gate_level(
    input a,b,
    output y
);
or g1(y,a,b);
endmodule