module not_dataflow(
    input a,
    output y
);
assign y = ~a;
endmodule


module not_behavioral(
    input a,
    output reg y);
always @(*)
begin
    y = ~a;
end
endmodule

module not_gate_level(
    input a,
    output y);
not g1(y,a);
endmodule)