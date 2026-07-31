module half_subtractor(
    input a,b,
    output diff,bout
);

assign diff = a^b;
assign bout = ~a&b;
endmodule


module full_subtractor(
    input a,b,bin,
    output diff,bout
);

wire d1,b1,b2;

half_subtractor hs1 (.a(a), .b(b), .diff(d1), .bout(b1));
half_subtractor hs2 (.a(d1), .b(bin), .diff(diff), .bout(b2));
assign bout = b1 | b2;  // Bout is the OR of the two borrow outputs from the half subtractors
endmodule



//testbenhch for full subtractor
module tb_full_sub;
  reg  A, B, Bin;
  wire D, Bout;

  full_sub dut (.A(A), .B(B), .Bin(Bin), .D(D), .Bout(Bout));

  initial begin
    $dumpfile("full_sub.vcd");
    $dumpvars(0, tb_full_sub);
    {A, B, Bin} = 3'b000; #10;
    {A, B, Bin} = 3'b001; #10;
    {A, B, Bin} = 3'b010; #10;
    {A, B, Bin} = 3'b011; #10;
    {A, B, Bin} = 3'b100; #10;
    {A, B, Bin} = 3'b101; #10;
    {A, B, Bin} = 3'b110; #10;
    {A, B, Bin} = 3'b111; #10;
    $finish;
  end
  
  initial
    $monitor("t=%0t A=%b B=%b Bin=%b | D=%b Bout=%b",
              $time, A, B, Bin, D, Bout);
endmodule
Run: iverilog -o fs tb_full_sub.v full_sub.v half_sub_df.v && vvp fs — then open the .vcd in GTK