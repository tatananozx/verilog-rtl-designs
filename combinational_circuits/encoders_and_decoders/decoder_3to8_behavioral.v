module decoder_3to8_behavioral(
    input i0,i1,i2,
    input EN,
    output reg [7:0] y
);
                                                 // shift trick preffered for larger N, more compact code, less error prone, more efficient hardware
always @(*) begin
    y = 8'b0;  // default no latch, all outputs 0
    if (EN)
    y = 8'b1 << {i2,i1,i0};  // shift 1 by the value of the input combination
end
endmodule  


//always @(*) begin
// y = 8'b0;                         // default always first
//  if (EN) begin
//    case ({i2, i1, i0})               //explicit case statement, can be used for any N and M=2^N
//      3'b000: y = 8'b00000001;
//      3'b001: y = 8'b00000010;
//      3'b010: y = 8'b00000100;
//      3'b011: y = 8'b00001000;
///     3'b100: y = 8'b00010000;
//     3'b101: y = 8'b00100000;
//    3'b110: y = 8'b01000000;
// 3'b111: y = 8'b10000000;
//    endcase
//  end
//end
//endmodule