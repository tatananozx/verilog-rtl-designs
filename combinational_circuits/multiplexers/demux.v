module demux_1to4(
    input D,
    input [1:0] S,
    output [3:0] Y
);
assign Y[0] = D & ~S[1] & ~S[0];
assign Y[1] = D & ~S[1] & S[0];
assign Y[2] = D & S[1] & ~S[0];
assign Y[3] = D & S[1] & S[0];
endmodule

//TESTBENCH
module tb_demux_1to4;
  reg        D;
  reg  [1:0] S;
  wire [3:0] Y;

  demux_1to4 uut (.D(D), .S(S), .Y(Y));

  initial begin
    $dumpfile("demux.vcd");
    $dumpvars(0, tb_demux_1to4);

    D = 1;
    S = 2'b00; #10; $display("S=%b Y=%b", S, Y);  // expect 0001
    S = 2'b01; #10; $display("S=%b Y=%b", S, Y);  // expect 0010
    S = 2'b10; #10; $display("S=%b Y=%b", S, Y);  // expect 0100
    S = 2'b11; #10; $display("S=%b Y=%b", S, Y);  // expect 1000

    D = 0;
    S = 2'b01; #10; $display("D=0 S=%b Y=%b", S, Y);  // expect 0000

    $finish;
  end
endmodule