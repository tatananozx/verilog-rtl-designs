module gray2_binary(
    input wire [3:0] gray,
    output wire [3:0] bin
);


assign bin[3] = gray[3];  //MSB bit of binary is same as MSB bit of gray code

xor x1(bin[2],gray[2],bin[3]);
xor x2(bin[1],gray[1],bin[2]);     //b[i] = g[i] ^ b[i+1] 
xor x3(bin[0],gray[0],bin[1]);
endmodule

module gray2bin_gen #(parameter N = 4) (
    input  wire [N-1:0] g,                               //PARAMETERIZED: Gray to Binary SCALEABLE WITH GENERATE BLOCK
    output wire [N-1:0] b
);
    assign b[N-1] = g[N-1]; // MSB direct

    genvar i;
    generate
        for (i = N-2; i >= 0; i = i -1) begin : gray_stage
            xor (b[i], g[i], b[i+1]);
        end
    endgenerate
endmodule



module gray2bin_df #(parameter N = 4) (
    input  wire [N-1:0] g,                         //INDUSTRY SHORTHAND: Gray to Binary Converter using XOR reduction
    output wire [N-1:0] b
);
    genvar i;
    generate
        for (i = 0; i < N; i = i +1) begin : bit_reduce
            // B[i] = XOR of all G bits from MSB down to i
            assign b[i] = ^g[N-1:i];
        end
    endgenerate
endmodule



//TESTBENCH
module tb_gray2_binary;

reg  [3:0] gray;
wire [3:0] bin;
integer    errors, i;
reg  [3:0] expected;

gray2_binary dut (.gray(gray), .bin(bin));

// reference model: recursive XOR, computed in TB independent of DUT style
function [3:0] gray2_binary_ref;
    input [3:0] gin;
    integer k;
    reg [3:0] bout;
    begin
        bout[3] = gin[3];
        for (k = 2; k >= 0; k = k -1)
            bout[k] = gin[k] ^ bout[k+1];
        gray2_binary_ref = bout;
    end
endfunction

initial begin
    errors = 0;
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_gray2_binary);

    // explicit corner cases
    gray = 4'b0000; #10; check; // all zero
    gray = 4'b1000; #10; check; // MSB only = 15 in binary
    gray = 4'b1100; #10; check; // = binary 8
    gray = 4'b0001; #10; check; // LSB only
    gray = 4'b1010; #10; check; // alternating

    // exhaustive sweep: all 16 combinations
    for (i = 0; i < 16; i = i + 1) begin
        gray = i; #10; check;
    end

    if (errors == 0) $display("ALL TESTS PASSED");
    else              $display("FAILED: %0d errors", errors);
    $finish;
end

task check;
    begin
        expected = gray2_binary_ref(gray);
        if (bin !== expected) begin
            $display("FAIL: gray=%b expected bin=%b got bin=%b", gray, expected, bin);
            errors = errors + 1;
        end
    end
endtask

endmodule