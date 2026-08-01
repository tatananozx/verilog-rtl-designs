module decoder_2to4_dataflow(
    input i0,i1,
    input EN,
    output y0,y1,y2,y3
);
assign y0 =  EN & ~i0 & ~i1;
assign y1 =  EN & ~i0 & i1;
assign y2 =  EN & i0 & ~i1;
assign y3 =  EN & i0 & i1;
endmodule


//module decoder_NtoM #(
//  parameter N = 2
//)(
//  input  [N-1:0] sel,
//  input          en,
//  output [(1<1:0] y
//);
//assign y = en ? (1 << sel) : 0;
//endmodule

//TESTBENCH
module tb_decoder_2to4_dataflow;

    // inputs
    reg i0, i1, EN;

    // outputs
    wire y0, y1, y2, y3;

    // ============================================
    // CHANGE LINE 1: module name
    // CHANGE LINE 2: instance name (anything)
    // ============================================
    decoder_2to4_dataflow uut (   // ← CHANGE THIS
        .i0(i0), .i1(i1), .EN(EN),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3)
    );

    initial begin
        // CHANGE LINE 3: vcd file name
        $dumpfile("dataflow.vcd");   // ← CHANGE THIS
        $dumpvars(0, tb_decoder_2to4_dataflow);

        // EN = 0, all outputs must be 0
        EN=0; i1=0; i0=0; #10;
        EN=0; i1=1; i0=1; #10;

        // EN = 1, test all 4 combinations
        EN=1; i1=0; i0=0; #10;   // expect y0=1
        EN=1; i1=0; i0=1; #10;   // expect y1=1
        EN=1; i1=1; i0=0; #10;   // expect y2=1
        EN=1; i1=1; i0=1; #10;   // expect y3=1

        $finish;
    end

    // prints result in terminal
    initial begin
        $monitor("EN=%b i1=%b i0=%b | y0=%b y1=%b y2=%b y3=%b",
                  EN, i1, i0, y0, y1, y2, y3);
    end

endmodule