module nand_dataflow(
    input a,b,
    output y
);
assign y = ~(a & b);
endmodule

module nand_behavioral(
    input a,b,
    output reg y);
always @(*)
begin
    y = ~(a&b);
end
endmodule

module nand_gate_level(
    input a,b,
    output y);
nand g1(y,a,b);
endmodule