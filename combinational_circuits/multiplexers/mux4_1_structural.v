module mux2_1(                    //BASE 2:1 MUX
    input i0,i1,
    input s,
    output y
);   
   assign y = s? i1 : i0;
endmodule


module mux4_1_structural(         // 4:1 MUX USING 3 2:1 MUX
    input i0,i1,i2,i3,
    input [1:0] s,
    output      y
);
                                      // 3  2:1 needed for 4:1 MUX to eliminate 2 inputs at a time by using S0 and then eliminate the remaining 2 inputs by using S1
wire w0,w1;  

mux2_1 m0(.i0(i0),.i1(i1),.s(s[0]),.y(w0)); // FIRST 2:1 MUX FOR I0 AND I1 and SELECTED BY S0
mux2_1 m1(.i0(i2),.i1(i3),.s(s[0]),.y(w1)); // SECOND 2:1 MUX FOR I2 AND I3 and SELECTED BY S0
mux2_1 m2(.i0(w0),.i1(w1),.s(s[1]),.y(y)); // THIRD 2:1 MUX FOR W0 AND W1 and SELECTED BY S1
endmodule


// TESTBENCH
module tb_mux4_1_structural;
reg i0,i1,i2,i3;
reg [1:0] s;    
wire y;

mux4_1_structural uut(
    .i0(i0),
    .i1(i1),
    .i2(i2),
    .i3(i3),
    .s(s),
    .y(y)    
);
  initial begin
     $dumpfile("mux4_1_structural.vcd");
        $dumpvars(0, tb_mux4_1_structural);

        // set inputs - i3i2i1i0 = 1010
        // so i0=0, i1=1, i2=0, i3=1
        i0 = 0; i1 = 1; i2 = 0; i3 = 1;

        // s=00 → should pick i0 → y=0
        s = 2'b00; #10;
        $display("s=%b | y=%b | expected=0 (i0)", s, y);

        // s=01 → should pick i1 → y=1
        s = 2'b01; #10;
        $display("s=%b | y=%b | expected=1 (i1)", s, y);

        // s=10 → should pick i2 → y=0
        s = 2'b10; #10;
        $display("s=%b | y=%b | expected=0 (i2)", s, y);

        // s=11 → should pick i3 → y=1
        s = 2'b11; #10;
        $display("s=%b | y=%b | expected=1 (i3)", s, y);

        $finish;
    end

endmodule
