module mux4_1_data(
    input i0,i1,i2,i3,
    input [1:0] s,
    output      y
);

assign y = s[1]? (s[0]? i3 : i2)
                :(s[0]? i1 : i0);    // IF S1=1 THEN CHECK S0 IF S0=1 THEN Y=I3 ELSE Y=I2 ELSE CHECK S0 IF S0=1 THEN Y=I1 ELSE Y=I0
endmodule




module mux4_1_behavioral(
    input i0,i1,i2,i3,
    input [1:0] s,
    output reg y
);
always @(*) begin
    case (s)
      2'b00: y=i0;
      2'b01: y=i1;
      2'b10: y=i2;
      2'b11: y=i3;
      default: y=1'bx;
    endcase
end
endmodule

// TESTBENCH
module tb_mux4_1_behavioral;
reg i0,i1,i2,i3;
reg [1:0] s;    
wire y;

mux4_1_behavioral uut(
    .i0(i0),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .s(s),
    .y(y)    
);
  initial begin
     $dumpfile("mux4_1_behavioral.vcd");
        $dumpvars(0, tb_mux4_1_behavioral);

        // set inputs - i3i2i1i0 = 0111
        // so i0=1, i1=1, i2=1, i3=0
        i0 = 1; i1 =1 ; i2 = 1; i3 = 0;

        // s=00 → should pick i0 → y=1
        s = 2'b00; #10;
        $display("s=%b | y=%b | expected=1 (i0)", s, y);

        // s=01 → should pick i1 → y=1
        s = 2'b01; #10;
        $display("s=%b | y=%b | expected=1 (i1)", s, y);

        // s=10 → should pick i2 → y=1
        s = 2'b10; #10;
        $display("s=%b | y=%b | expected=1 (i2)", s, y);

        // s=11 → should pick i3 → y=0
        s = 2'b11; #10;
        $display("s=%b | y=%b | expected=0 (i3)", s, y);

        $finish;
    end

endmodule






   