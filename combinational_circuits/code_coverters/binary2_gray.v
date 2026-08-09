module binary2_gray(
    input wire [3:0] bin,                       //4 bit binary to gray converter structural style implementation
    output wire [3:0] gray
);

assign gray[3] = bin[3];     //MSB of gray is same as MSB of binary no gates only direct wire connection

xor x1(gray[2], bin[3], bin[2]);       //formula g[i] = b[i+1] xor b[i] for i=n-2 to 0
xor x2(gray[1], bin[2], bin[1]);
xor x3(gray[0], bin[1], bin[0]);
endmodule 

module binary2_gray(
    input wire [3:0] bin,
    output wire [3:0] gray
);                                           //dataflow style implementation of binary to gray converter

assign gray[3] = bin[3];
assign gray[2:0] = bin[2:0] ^ bin[3:1]; // vectorized XOR operation for the remaining bits,1 line for 3 bits
endmodule


//inudstry style implementation of binary to gray converter

module binary2_gray_rtl #(parameter N = 4)(
   input wire [N-1:0] bin, 
   output wire [N-1:0] gray
);
assign gray = bin ^ (bin >> 1);             //shift that binary by 1 bit to the right and then perform XOR operation with original binary number
endmodule