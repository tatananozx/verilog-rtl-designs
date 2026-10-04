module tb_2ff_synz;
    reg  clk_dst, rst_n, async_in;
    wire sync_out;
    integer errors;

    sync_2ff dut (.clk_dst(clk_dst), .rst_n(rst_n), .async_in(async_in), .sync_out(sync_out));

    always #5 clk_dst = ~clk_dst;  // destination clock, period 10

    initial begin
        clk_dst = 0; rst_n = 0; async_in = 0; errors = 0;
        #12 rst_n = 1;

        // Drive async_in at a completely different, unrelated rate (async clock sim)
        #7  async_in = 1;
        #13 async_in = 0;
        #23 async_in = 1;

        #50;
        if (sync_out !== 1'b1) begin
            $display("FAIL: expected sync_out to settle to 1, got %b", sync_out);
            errors = errors + 1;
        end

        if (errors == 0) $display("ALL TESTS PASSED");
        else              $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule