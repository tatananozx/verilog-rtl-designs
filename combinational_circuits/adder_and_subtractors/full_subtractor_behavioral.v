module full_subtactor(
    input a,b,bin,
    output reg diff,bout
);
                          
always @(*)
begin
diff = a ^b^bin;
bout = (~a&b) | (~a&bin)| (b&bin);
end
endmodule


// another way also using case statement
always @(*) begin
  case ({a, b, bin})
    3'b000: {bout, diff} = 2'b00;
    3'b001: {bout, diff} = 2'b11;
    3'b010: {bout, diff} = 2'b11;
    3'b011: {bout, diff} = 2'b10;
    3'b100: {bout, diff} = 2'b01;
    3'b101: {bout, diff} = 2'b00;
    3'b110: {bout, diff} = 2'b00;
    3'b111: {bout, diff} = 2'b11;
    default: {bout, diff} = 2'bxx;
  endcase
end


//using if else statement
always @(*) begin
  if ({a,b,bin} == 3'b001 || {a,b,bin} == 3'b010 ||
      {a,b,bin} == 3'b100 || {a,b,bin} == 3'b111)
    diff = 1;
  else
    diff = 0;
  // same for bout
end