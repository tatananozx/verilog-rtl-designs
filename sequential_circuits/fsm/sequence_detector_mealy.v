module mealy_sequence_detetor(   //for pattern 101 
    input wire clk,
    input wire rst_n,
    input wire input_bit,
    output reg output_bit
);

localparam s0=2'b00, s1=2'b01, s2=2'b10;
reg [1:0] current_state, next_state;


//block 1: state register - async assert and sync deassert
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    current_state <= s0;
    else 
    current_state <= next_state;
end

//block 2: next state logic - combinational
always @(*) begin
    case (current_state)
    s0: next_state = input_bit ? s1 : s0;
    s1: next_state = input_bit ? s1 : s2;
    s2: next_state = input_bit ? s1 : s0;
    default: next_state = s0;
    endcase
end

//block 3: output logic - combinational
always @(*) begin
    output_bit = (current_state == s2) ? 1'b1 : 1'b0;
end
endmodule

// other alternative for block 3 
//always @(*) begin
//    case (current_state)
//        S2:      output_bit = input_bit ? 1'b1 : 1'b0;
//        default: output_bit = 1'b0;
//    endcase
//end




//assign output_bit = (current_state == S2) & input_bit;

