module encoder_4to2(
    input [3:0]  i,
    output [1:0] y
);                                  //DATAFLOW MODEL
assign y[0] = i[1] | i[3];
assign y[1] = i[2] | i[3];
endmodule       


module encoder_4to2_case(
    input [3:0]  i,
    output reg [1:0] y
);                                  //BEHAVIORAL MODEL- case statement
always @(*) begin
    case (i)
    4'b0001: y = 2'b00;  //I0 is high so output is 00 
    4'b0010: y = 2'b01;  //I1 is high so output is 01
    4'b0100: y = 2'b10;  //I2 is high so output is 10
    4'b1000: y = 2'b11;  //I3 is high so output is 11
    default: y = 2'bxx;  //undefined for invalid i/p and like all inputs are low and more than 1 input is high // avoid latches 
    endcase
end
endmodule


module encoder_4to2_if (
  input  [3:0] I,
  output reg [1:0] Y                        // BEHAVIORAL MODEL- if statement in this priority order is given to the inputs. If more than 1 input is high then the output will be of the highest priority input which is I3 in this case
);
  always @(*) begin                         //casex can also be used and its also follow priority order but it will ignore x and z values in the input and it will consider them as don't care condition
    if      (I[3]) Y = 2'b11;
    else if (I[2]) Y = 2'b10;
    else if (I[1]) Y = 2'b01;
    else           Y = 2'b00;
  end
endmodule


module encoder_2to4(
    input [3:0] I,
    output [1:0] Y
);                                       //STRUCTURAL MODEL
 or g1(Y[0],I[1], I[3]);
 or g2(Y[1], I[2], I[3]);
endmodule