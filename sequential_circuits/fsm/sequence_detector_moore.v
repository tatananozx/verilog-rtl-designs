// FOR PATTERN 1101 AND OVER-LAPPING SEQUENCE DETECTOR
module sequence_detector(
    input wire clk,  //posedge
    input wire rst_n, //active low async reset
    input wire din,
    output reg dout  // 1-bit detection flag-not the pattern
);
// 3 bit state each and total 5 states
localparam [2:0] s0=3'd0 , s1=3'd1, s2=3'd2, s3=3'd3, s4=3'd4;

reg [2:0] current_state, next_state;

//WE ARE USING 3 BLOCK STYLE
//BLOCK 1: STATE REGISTER
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    current_state <= s0; //reset to idle/known state most important
    else 
    current_state <= next_state;
end

//BLOCK 2: NEXT STATE LOGIC (combinational, decodes current_state + input)

always @(*) begin // remember risk of latches if o/p values not assigned properly
   case (current_state)
   s0: next_state = din ? s1 : s0;
   s1: next_state = din ? s2 : s0;
   s2: next_state = din ? s2 : s3;
   s3: next_state = din ? s4 : s0;
   s4: next_state = din ? s2 : s0;
   default: next_state = s0; //safety handling illegal state and latch rsk
   endcase
end


//BLOCK 3: OUTPUT LOGIC (combinational, decodes current_state) glitch free for moore FSM because output depends on state only 
// we can use case statement also but here we are using ternary operator
always @(*) begin
    dout = (current_state == s4) ? 1'b1 : 1'b0; //detection flag
end
endmodule