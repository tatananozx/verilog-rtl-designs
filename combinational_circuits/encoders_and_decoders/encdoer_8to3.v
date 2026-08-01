module encoder_3_8(
    input [7:0] i,
    output [2:0] y
);                                                        //DATAFLOW MODEL

assign y[0] = i[1] | i[3] | i[5] | i[7];
assign y[1] = i[2] | i[3] | i[6] | i[7];
assign y[2] = i[4] | i[5] | i[6] | i[7];
endmodule



module encoder_3_8_if(
    input [7:0] i,
    output reg [2:0] y
);
                                             //BEHAVIORAL MODEL- if statement in this priority order is given to the inputs.
                                             //MORE HARDWARE IS REQUIRED IN THIS MODEL AS COMPARED TO THE DATAFLOW MODEL
   always @(*) begin
    if    (i[7]) y = 3'b111;
  else if (i[6]) y = 3'b110;
  else if (i[5]) y = 3'b011;
  else if (i[4]) y = 3'b100;
  else if (i[3]) y = 3'b011;
  else if (i[2]) y = 3'b010;
  else if (i[1]) y = 3'b001;
  else    (i[0]) y = 3'b000;
   end
endmodule



module encoder_8to3_case (
  input  [7:0] I,
  output reg [2:0] Y
);                                          //BEHAVIORAL MODEL- case statement
  always @(*) begin
    case (I)
      8'b00000001: Y = 3'd0;
      8'b00000010: Y = 3'd1;
      8'b00000100: Y = 3'd2;
      8'b00001000: Y = 3'd3;
      8'b00010000: Y = 3'd4;
      8'b00100000: Y = 3'd5;
      8'b01000000: Y = 3'd6;
      8'b10000000: Y = 3'd7;
      default:     Y = 3'bxxx;  //NEVER FORGET TO GIVE DEFAULT CASE IN CASE STATEMENT TO AVOID LATCHES AND UNDEFINED OUTPUTS
    endcase
  end
endmodule



module encoder_8to3_casex (
  input  [7:0] I,
  output reg [2:0] Y
);                                            //BEHAVIORAL MODEL- casex statement not for synthesis but for simulation purpose and it will ignore x and z values in the input and it will consider them as don't care condition
  always @(*) begin
    casex (I)
      8'b1xxxxxxx: Y = 3'd7;
      8'b01xxxxxx: Y = 3'd6;
      8'b001xxxxx: Y = 3'd5;
      8'b0001xxxx: Y = 3'd4;
      8'b00001xxx: Y = 3'd3;
      8'b000001xx: Y = 3'd2;
      8'b0000001x: Y = 3'd1;
      8'b00000001: Y = 3'd0;
      default:    Y = 3'bxxx;  //NEVER FORGET TO GIVE DEFAULT CASE IN CASE STATEMENT TO AVOID LATCHES AND UNDEFINED OUTPUTS
    endcase
  end
endmodule



module encoder_8to3_structural (
  input  [7:0] i,
  output [2:0] y
);                                            //STRUCTURAL MODEL- using gate level modeling
 or g0(y[0], i[1] , i[3] ,i[5] , i[7]);
 or g1(y[1], i[2], i[3], i[6] , i[7]);
 or g2(y[2], i[4], i[5], i[6], i[7]);
endmodule
 