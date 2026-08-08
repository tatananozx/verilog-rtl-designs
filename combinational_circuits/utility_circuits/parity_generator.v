module parity4_bit(
    input [3:0] data,
    output wire parity_even,        //Dataflow used in real RTL
    output wire parity_odd);

    assign parity_even = ^data;
    assign parity_odd = ~^data;
endmodule


module parity4_structural(
    input [3:0] data,
    output wire parity_even      //xor tree interview style
);

wire w0,w1;

xor g1(w0,data[0],data[1]);
xor g2(w1,data[2],data[3]);
xor g3(parity_even,w0,w1);
endmodule



// Parameterized dataflow — scales to any width, reusable IP style 
module parity4_gen_param #(parameter N = 4) (
    input  wire [N-1:0] data,
    output wire         parity_even,
    output wire         parity_odd
);
    assign parity_even = ^data;
    assign parity_odd  = ~^data;
endmodule




module parity8_generator(
    input wire [7:0] data,
    output wire parity_even);

wire w0,w1,w2,w3;

xor g1(w0,data[0],data[1]);
xor g2(w1,data[2],data[3]);
xor g3(w2,data[4],data[5]);
xor g4(w3,data[6],data[7]);

wire y1,y2;
xor g5(y1,w0,w1);
xor g6(y2,w2,w3);

xor g7(parity_even,y1,y2);
endmodule




//TESTBENCH
`timescale 1ns/1ps
module tb_parity8_generator;

reg  [7:0] data;
wire       parity_even;
integer    errors, i;

parity8_generator dut (.data(data), .parity_even(parity_even));

initial begin
    errors = 0;
    $dumpfile("wave8.vcd");
    $dumpvars(0, tb_parity8_generator);

    // Corner cases — explicit
    data = 8'h00; #10; check(1'b0); // 0 ones -> even -> P=0
    data = 8'hFF; #10; check(1'b0); // 8 ones -> even -> P=0
    data = 8'h01; #10; check(1'b1); // 1 one  -> odd  -> P=1
    data = 8'h80; #10; check(1'b1); // 1 one  -> odd  -> P=1
    data = 8'h0F; #10; check(1'b0); // 4 ones -> even -> P=0
    data = 8'hAA; #10; check(1'b0); // 4 ones -> even -> P=0
    data = 8'h07; #10; check(1'b1); // 3 ones -> odd  -> P=1

    // Exhaustive sweep: all 256 combinations, checked against Verilog's own reduction XOR
    for (i = 0; i < 256; i = i + 1) begin
        data = i; #10;
        if (parity_even !== (^data)) begin
            $display("FAIL: data=%b expected=%b got=%b", data, ^data, parity_even);
            errors = errors + 1;
        end
    end

    if (errors == 0) $display("ALL TESTS PASSED (256/256 combinations)");
    else              $display("FAILED: %0d errors", errors);
    $finish;
end

task automatic check;
    input expected;
    if (parity_even !== expected) begin
        $display("FAIL: data=%b expected=%b got=%b", data, expected, parity_even);
        errors = errors + 1;
    end
endtask

endmodule