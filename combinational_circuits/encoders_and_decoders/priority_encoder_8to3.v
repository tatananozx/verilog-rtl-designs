module encoder_priority_if_else(   //DATA FLOW IS NOT SUITABLE AS BOOLEAN EXPRESSION ARE COMPLEX SO PREFER CASE AND IF ELSE 
     input [7:0] I,             // OF BEHAVIORAL MODELING
     output reg [2:0] Y,
     output reg E0
);
  always @(*) begin
  E0 = 1'b1;
  if      (I[7]) Y = 3'b111;
  else if (I[6]) Y = 3'b110;
  else if (I[5]) Y = 3'b101;
  else if (I[4]) Y = 3'b100;
  else if (I[3]) Y = 3'b011;
  else if (I[2]) Y = 3'b010;
  else if (I[1]) Y = 3'b001;
  else if (I[0]) Y = 3'b000;
  else begin     Y = 3'bxxx;
                E0 = 1'b0;
  end
  end
endmodule

//TESTBENCH
module tb_encoder_priority_if_else;

    reg  [7:0] I;
    wire [2:0] Y;
    wire       E0;

    encoder_priority_if_else uut (
        .I  (I),
        .Y  (Y),
        .E0 (E0)
    );

    initial begin
        $dumpfile("penc.vcd");
        $dumpvars(0, tb_encoder_priority_if_else);

        I = 8'b00000000; #10;
        $display("I=%b Y=%b E0=%b", I, Y, E0);

        I = 8'b00000001; #10;
        $display("I=%b Y=%b E0=%b", I, Y, E0);

        I = 8'b10000000; #10;
        $display("I=%b Y=%b E0=%b", I, Y, E0);

        I = 8'b10000001; #10;
        $display("I=%b Y=%b E0=%b", I, Y, E0);

        I = 8'b01000010; #10;
        $display("I=%b Y=%b E0=%b", I, Y, E0);

        I = 8'b11111111; #10;
        $display("I=%b Y=%b E0=%b", I, Y, E0);

        $finish;
    end

endmodule