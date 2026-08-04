module demux_conditional(
    input D,
    input [1:0] S,
    output reg [3:0] Y              // MUST ADD REG WHEN USING ALWAYS DESIGN
);
                                     // CONDITIONAL ASSIGN - CLEANER AND SMARTEST WAY
always @(*) begin
    Y=4'b0000;   //deafault all off
    Y[S]= D;     // only selected line gets D
end
endmodule



module demux_case(        //CASE USING ASSIGN DESIGN
    input D,
    input [1:0] S,
    output reg [3:0] Y    //REG MUST FOR ALWAYS DESIGN
);

always @(*) begin
    Y= 4'b0000;      // ALWAYS ADD DEFAULT IN CASE AND IF ELSE TO AVOID LATCH
   case (S)
   2'b00: Y[0] = D;
   2'b01: Y[1] = D;
   2'b10: Y[2] = D;
   2'b11: Y[3] = D;  
   endcase
end
endmodule



module demux_param #(parameter N = 2) (  // N select lines → 2^N outputs
  input  wire           D,
  input  wire [N-1:0]   sel,
  output wire [2**N-1:0] Y                    //PARAMETRIZE DESIGN
);                                           //GENERATE BLOCK MUST LEARN IT WE CAN DESIGN ANY DEMUX WITH IT SENIOR ENGINNER AND INTERVIEW LOVE
  genvar i;                                  
  generate
    for (i = 0; i < 2**N; i = i+1) begin : demux_gen
      assign Y[i] = D & (sel == i);
    end
  endgenerate
endmodule




module demux_enable(
    input D,
    input EN,         // WITH ENABLE REAL WORLD DEMUX CAN BE USED IN EVERY DESIGN STYLE
    input [1:0] S,    // ALWAYS INCLUDE ENABLE IN REAL DESIGN - CHIPS NEED POWER GATING AND TRI STATE CONTROL
    output reg [3:0] Y
);
always @(*) begin
    Y = 4'b0000;
    if (EN)
    Y[S] = D;
end