module decoder_2to4_behavioral(
    input i0,i1,
    input EN,
    output reg y0,y1,y2,y3
);

always@(*) begin
    {y0,y1,y2,y3} = 4'b0000;  //Always set default values at the top of always block. Missing defaults = LATCHES in synthesis. That's a real silicon bug.
    if (EN) begin
        case ({i1,i0})
        2'b00: y0=1;
        2'b01: y1=1;
        2'b10: y2=1;
        2'b11: y3=1;
        endcase
    end
end
endmodule

//TESTBENCH
module tb_decoder_2to4_behavioral;

    // inputs
    reg i0, i1, EN;

    // outputs
    wire y0, y1, y2, y3;

    // ============================================
    // CHANGE LINE 1: module name
    // CHANGE LINE 2: instance name (anything)
    // ============================================
    decoder_2to4_behavioral uut (   // ← CHANGE THIS
        .i0(i0), .i1(i1), .EN(EN),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3)
    );

    initial begin
        // CHANGE LINE 3: vcd file name
        $dumpfile("behavioral.vcd");   // ← CHANGE THIS
        $dumpvars(0, tb_decoder_2to4_behavioral);

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