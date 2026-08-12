module bcd_to_excess3 (                               //STRUCTURAL 
    input wire  b3,b2,b1,b0,
    output wire e3,e2,e1,e0
);
// 3 inverters b0',b1',b2'.

wire nb0,nb1,nb2;    //not b1 = b1'

not g0(nb0,b0);
not g1(nb1,b1);
not g2(nb2,b2);    

//e0 = b0'
assign e0 = nb0;

//e1 = b1'b0' + b1b0
wire e1a,e1b;

and g3(e1a,nb1,nb0);
and g4(e1b,b1,b0);
or g5(e1,e1a,e1b);

//e2 = b2'b1 + b2'b0 + b2b1'b0'

wire e2a,e2b,e2c;

and g6(e2a,nb2,b1);
and g7(e2b,nb2,b0);
and g8(e2c,b2,nb1,nb0);
or g9(e2,e2a,e2b,e2c);


//e3 = b3 + b2b1 + b2b0

wire e3a,e3b;

and g10(e3a,b2,b1);
and g11(e3b,b2,b0);
or g12(e3,b3,e3a,e3b);
endmodule



//case statement clean synthesizable code

module bcdexc3_case(
    input wire [3:0] bcd,
    output reg [3:0] exc3
);
always @(*) begin
    case(bcd)
    4'd0 : exc3 = 4'b0011; // 0 + 3 = 3
    4'd1 : exc3 = 4'b0100;
    4'd2 : exc3 = 4'b0101;
    4'd3 : exc3 = 4'b0110;
    4'd4 : exc3 = 4'b0111;
    4'd5 : exc3 = 4'b1000;
    4'd6 : exc3 = 4'b1001;
    4'd7 : exc3 = 4'b1010;
    4'd8 : exc3 = 4'b1011;
    4'd9 : exc3 = 4'b1100; // 9 + 3 = 12
    default : exc3 = 4'bxxxx; // invalid BCD input- very important to have this default case for synthesis otherwise latch will be inferred
    endcase
end
endmodule



//INDUSTRY LEVEL SHORTHAND USING ADDER
module bcd_excess3_add (
    input  wire [3:0] bcd,
    output wire [3:0] exs3
);
    assign exs3 = bcd + 4'd3; // self-explanatory, synthesizer optimizes the +3 adder
endmodule
