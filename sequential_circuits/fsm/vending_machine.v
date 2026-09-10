module vending_machine (             // 5rs and 10rs allowed and item of 15rs each
input wire clk,
input wire rst_n,
input wire coin5,
input wire coin10,
output reg dispense,
output reg return5
);

localparam [2:0] IDLE = 3'b000, FIVE = 3'b001, TEN = 3'b010, DISP_EXACT = 3'b011, DISP_CHANGE = 3'b100;
//Use it: locks the parameter's width so a future edit (e.g. IDLE = 5 without 3'b) can't silently mismatch your state register's width.
//Don't use it: redundant when every value already has an explicit 3'b width, so it just adds characters with zero functional difference.
reg [2:0] current_state, next_state;

//block 1: state register

always@(posedge clk or negedge rst_n) begin
    if (!rst_n)
    current_state <= IDLE;
    else
    current_state <= next_state;
end

//block 2: next state logic -purely combinational
always @(*) begin    //there are more styles also but this matches my state table style
    casez ({current_state, coin5, coin10})
        {IDLE, 2'b10}:  next_state = FIVE;
        {IDLE, 2'b01}:  next_state = TEN;
        {IDLE, 2'b00}:  next_state = IDLE;
        {IDLE, 2'b11}:  next_state = IDLE;   // illegal input, hold

        {FIVE, 2'b10}:  next_state = TEN;
        {FIVE, 2'b01}:  next_state = DISP_EXACT;
        {FIVE, 2'b00}:  next_state = FIVE;
        {FIVE, 2'b11}:  next_state = FIVE;

        {TEN,  2'b10}:  next_state = DISP_EXACT;
        {TEN,  2'b01}:  next_state = DISP_CHANGE;
        {TEN,  2'b00}:  next_state = TEN;
        {TEN,  2'b11}:  next_state = TEN;

        {DISP_EXACT,  2'b??}: next_state = IDLE;
        {DISP_CHANGE, 2'b??}: next_state = IDLE;

        default: next_state = IDLE;  // illegal state recovery
    endcase
end


// block 3: Output logic (Moore — state only, no inputs)
always @(*) begin
 dispense = (current_state == DISP_EXACT) || (current_state == DISP_CHANGE);
 return5  = (current_state == DISP_CHANGE);
end
endmodule


//alternative for block 3
//always @(*) begin
//    case (current_state)
//        DISP_EXACT:  {dispense, return5} = 2'b10;
//        DISP_CHANGE: {dispense, return5} = 2'b11;
//        default:     {dispense, return5} = 2'b00;
//    endcase
//end



//block 2 alternative
////always @(*) begin
//        next_state = current_state; // default: hold (also covers coin5&coin10 both=1 illegal input)
//        case (current_state)
//            IDLE: begin
 //               if (coin5 && !coin10)      next_state = FIVE;
//                else if (!coin5 && coin10) next_state = TEN;
 //           end
//            FIVE: begin
   //             if (coin5 && !coin10)      next_state = TEN;
 //               else if (!coin5 && coin10) next_state = DISP_EXACT;
  //          end
 //           TEN: begin
  //              if (coin5 && !coin10)      next_state = DISP_EXACT;
 //               else if (!coin5 && coin10) next_state = DISP_CHANGE;
  //          end
 //           DISP_EXACT:  next_state = IDLE;   // unconditional, one-cycle pulse
 //           DISP_CHANGE: next_state = IDLE;   // unconditional, one-cycle pulse
 //           default:     next_state = IDLE; // illegal state recovery
 //       endcase
 //   end