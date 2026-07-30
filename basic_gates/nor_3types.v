module nor_dataflow(
    input a,b,
    output y);
assign y = ~(a|b);
endmodule

module nor_behavioral(
    input a,b,
    output reg y);
always @(*)
begin
    y = ~(a|b);
end
endmodule

module nor_gate_level(
    input a,b,
    output y);
    nor g1(y,a,b);
endmodule
