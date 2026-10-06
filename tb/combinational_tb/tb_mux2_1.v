module tb_mux2_1;
reg  i0, i1, s;
    wire y;
    integer errors;
    integer vec;

    mux2_1df uut (.i0(i0), .i1(i1), .s(s), .y(y));

    initial begin
        errors = 0;
        $dumpfile("sim/mux2_1.vcd");
        $dumpvars(0, tb_mux2_1);

        for (vec = 0; vec < 8; vec = vec + 1) begin
            {s, i0, i1} = vec;
            #10;
            check;
        end

        if (errors == 0) $display("ALL TESTS PASSED");
        else              $display("FAILED: %0d errors", errors);
        $finish;
    end

    task check;
        reg expected;
        begin
            expected = s ? i1 : i0;
            if (y !== expected) begin
                $display("FAILED: s=%b i0=%b i1=%b y=%b expected=%b", s, i0, i1, y, expected);
                errors = errors + 1;
            end
        end
    endtask
endmodule