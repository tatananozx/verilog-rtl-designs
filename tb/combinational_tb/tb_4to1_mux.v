`timescale 1ns/1ps

module tb_mux4to1;

    reg  [3:0] d;
    reg  [1:0] sel;
    wire       y;

    reg        expected;
    integer    errors;
    integer    i, j;

    // DUT instance
    mux4to1 dut (
        .d  (d),
        .sel(sel),
        .y  (y)
    );

    // Reference model
    always @(*) begin
        case (sel)
            2'b00: expected = d[0];
            2'b01: expected = d[1];
            2'b10: expected = d[2];
            2'b11: expected = d[3];
            default: expected = 1'bx;
        endcase
    end

    initial begin
        errors = 0;
        $dumpfile("mux4to1.vcd");
        $dumpvars(0, tb_mux4to1);
        $display("Time\tsel\td\ty\texpected");

        // Exhaustive: all 4 select values x all 16 data combinations
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                sel = i[1:0];
                d   = j[3:0];
                #10;
                $display("%0t\t%b\t%b\t%b\t%b", $time, sel, d, y, expected);
                if (y !== expected) begin
                    errors = errors + 1;
                    $display("  ERROR: sel=%b d=%b y=%b expected=%b", sel, d, y, expected);
                end
            end
        end

        if (errors == 0)
            $display("PASS: all 64 combinations matched.");
        else
            $display("FAIL: %0d mismatches.", errors);

        $finish;
    end

endmodule