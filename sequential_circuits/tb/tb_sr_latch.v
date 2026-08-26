module tb_sr_latch;

reg s, r, en;
wire q, qn;
reg exp_q;
integer errors;

sr_latch_behavioral uut (.s(s), .r(r), .en(en), .q(q), .qn(qn));

initial begin 
    errors = 0;
    $dumpfile("srlatch.vcd");
    $dumpvars(0, tb_sr_latch);

    en=1; s=0; r=1; #10; exp_q=0; check(exp_q);
          s=1; r=0; #10; exp_q=1; check(exp_q);
          s=0; r=0; #10; check(exp_q);

    en=0; #5;  
    s=1; r=0; #10; check(exp_q);
    en=1; #10; exp_q=1; check(exp_q); 
    s=0; r=1; #10; exp_q=0; check(exp_q);

    s = 1; r = 1; #10;
    if (q !== 1'bx) begin
        $display("FAIL: forbidden state S=R=1 did not produce X, got %b", q);
        errors = errors + 1;
    end

    if (errors == 0) $display("ALL TESTS PASSED");
    else              $display("FAILED: %0d errors", errors);
    $finish;
end   

task automatic check;
    input expected;
    if (q !== expected) begin
        $display("FAIL: s=%b r=%b en=%b expected q=%b got q=%b",
                  s, r, en, expected, q);
        errors = errors + 1;
    end
endtask

endmodule