module full_subtractor(
    input a,b,bin,
    output diff,bout
);
                                     //assign {bout, diff} = a - b - bin; one line code for full subtractor using dataflow modeling
assign diff = a ^ b ^ bin;
assign bout = (~a&b) | (~a&bin)| (b&bin);
endmodule