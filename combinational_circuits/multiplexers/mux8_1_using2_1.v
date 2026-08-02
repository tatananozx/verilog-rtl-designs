module mux2_1(
    input i0,i1,s,
    output y
);

assign y = s? i1 : i0; // If select signal 's' is 1, output 'i1'; otherwise, output 'i0'.
endmodule

module mux8_1_using2_1(
    input [7:0] i,
    input [2:0] s,
    output y
);
wire w0,w1,w2,w3,w4,w5;  // w0,w1,w2,w3 are for level 1 with s[0], w4,w5 are for level 2 with s[1] and final y is for level 3 with s[2]
mux2_1 m0(.i0(i[0]), .i1(i[1]), .s(s[0]), .y(w0)); // level 1 we used 4 2;:1 mux with s[0] to select between pairs of inputs
mux2_1 m1(.i0(i[2]), .i1(i[3]), .s(s[0]), .y(w1)); // only 1 output from each mux goes to the next level based on s[0]
mux2_1 m2(.i0(i[4]), .i1(i[5]), .s(s[0]), .y(w2)); // we got 4 o/p out of 8 inputs after level 1
mux2_1 m3(.i0(i[6]), .i1(i[7]), .s(s[0]), .y(w3));
mux2_1 m4(.i0(w0), .i1(w1), .s(s[1]), .y(w4)); // level 2  we used 2 mux to get 2 o/p from 4 inputs based on s[1] 
mux2_1 m5(.i0(w2), .i1(w3), .s(s[1]), .y(w5));
mux2_1 m6(.i0(w4), .i1(w5), .s(s[2]), .y(y)); // level 3 we used 1 mux to get final o/p based on s[2] from 2 inputs w4 and w5 which are the o/p of level 2 muxes
endmodule

//TESTBENCH FOR MUX8_1 USING 2:1 MUX
module tb_mux8_1_using2_1;

    // inputs as reg
    reg [7:0] i;
    reg [2:0] s;

    // output as wire
    wire y;

    // instantiate your module
    mux8_1_using2_1 uut (
        .i(i),
        .s(s),
        .y(y)
    );

    initial begin
        $dumpfile("mux8_1_using2_1.vcd");
        $dumpvars(0, tb_mux8_1_using2_1);

        // i = 10110100
        // index: 76543210
        // i[0]=0, i[1]=0, i[2]=1, i[3]=0
        // i[4]=1, i[5]=1, i[6]=0, i[7]=1
        i = 8'b10110100;
        $display("i=%b", i);
        // s=000 → pick i[0] → y=0
        s = 3'b000; #10;
        $display("s=%b | y=%b | expected=0 (i[0])", s, y);

        // s=001 → pick i[1] → y=0
        s = 3'b001; #10;
        $display("s=%b | y=%b | expected=0 (i[1])", s, y);

        // s=010 → pick i[2] → y=1
        s = 3'b010; #10;
        $display("s=%b | y=%b | expected=1 (i[2])", s, y);

        // s=011 → pick i[3] → y=0
        s = 3'b011; #10;
        $display("s=%b | y=%b | expected=0 (i[3])", s, y);

        // s=100 → pick i[4] → y=1
        s = 3'b100; #10;
        $display("s=%b | y=%b | expected=1 (i[4])", s, y);

        // s=101 → pick i[5] → y=1
        s = 3'b101; #10;
        $display("s=%b | y=%b | expected=1 (i[5])", s, y);

        // s=110 → pick i[6] → y=0
        s = 3'b110; #10;
        $display("s=%b | y=%b | expected=0 (i[6])", s, y);

        // s=111 → pick i[7] → y=1
        s = 3'b111; #10;
        $display("s=%b | y=%b | expected=1 (i[7])", s, y);

        $finish;
    end

endmodule