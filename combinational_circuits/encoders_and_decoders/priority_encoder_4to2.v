module priority_4to2(
    input [3:0] i,
    output y0,y1,E0
);
                                     //dataflow model for 4:2 priority encoder
assign y1 = i[3] | i[2];
assign y0 = i[3] | (~i[2] & i[1]);
assign E0 = i[3] | i[2] | i[1] | i[0];
endmodule 


module priority_encoder_if(
    input [3:0] I,
    output reg [1:0] Y,
    output reg E0
);                            // BEHAVIORAL- IF ELSE  MOST IMPORTANT STYLE FOR PRIORITY ENCODER ASKED IN INTERVIEW ALSO
  always @(*)begin
    E0 = 1b'1;  //ASSUME ANY INPUTS ARE HIGH 
    if (I[3]) Y = 2'b11;
    else if (I[2]) Y = 2'b10;
    else if (I[1]) Y = 2'b01;
    else if (I[0]) Y = 2'b00;
    else begin 
     Y = 2'bxx;
    E0 = 1'b0;
    end
  end
endmodule



module priority_4to2_casex(
    input [3:0] i,                     // BEHAVIORAL CASEX
    output reg [1:0] y,
    output reg e0
);
                             // for simulation okay but not suitable for synthesis casex 
always @(*) begin
    e0 = 1'b1;
    casex(i)
    4'b1xxx: y=2'b11; // i3=1 rest dont care whatever inputs are high we dont care output will be always y1=1 and y0=1 and i3 will be encoded
    4'b01xx: y=2'b10; // when i3=0 , i2=1, rest dont care
    4'b001x: y=2'b01; // when i3,i2=0 then only i1=1 and output will be y1=0 and y0=1 and rest dont care
    4'b0001: y=2'b00; // when i3,i2,i1=0 then only i0=1 and output will be y1=0 and y0=0
    default: begin y=2'bxx; e0=1'b0; end
endcase
end
endmodule



module penc_4to2_casez (
  input      [3:0] I,
  output reg [1:0] Y,
  output reg       EO                     // BEHAVIORAL CASEZ SAFER FOR SYNTHESIS AND RTL
);
  always @(*) begin                     
    EO = 1'b1;
    casez (I)
      4'b1???: Y = 2'b11;  // ? = don't care (Z-safe)
      4'b01??: Y = 2'b10;
      4'b001?: Y = 2'b01;
      4'b0001: Y = 2'b00;
      default: begin Y = 2'bxx; EO = 1'b0; end
    endcase
  end
endmodule