module decoder_2to4_structural(
    input i0,i1,EN,
    output y0,y1,y2,y3
);
wire not_i0,not_i1;


not n0(not_i0,i0);
not n1(not_i1,i1);

and g0(y0,EN,not_i0,not_i1);
and g1(y1,EN,not_i0,i1);
and g2(y2,EN,i0,not_i1);
and g3(y3,EN,i0,i1);
endmodule

//TESTBENCH
`timescale 1ns/1ps

module tb_decoder_2to4_structural;

    // inputs
    reg i0, i1, EN;

    // outputs
    wire y0, y1, y2, y3;

    // ============================================
    // CHANGE LINE 1: module name
    // CHANGE LINE 2: instance name (anything)
    // ============================================
    decoder_2to4_structural uut (   // ← CHANGE THIS
        .i0(i0), .i1(i1), .EN(EN),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3)
    );

    initial begin
        // CHANGE LINE 3: vcd file name
        $dumpfile("structural.vcd");   // ← CHANGE THIS
        $dumpvars(0, tb_decoder_2to4_structural);

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