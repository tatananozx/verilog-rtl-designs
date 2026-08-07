module bit4_comparator(
    input wire [3:0] a,b,
    output wire gt,eq,lt
);
                                      // MSB always from the starting beacuse using blocking assignment
wire x3,x2,x1,x0;

assign x3 = ~(a[3] ^ b[3]);        // always xnor operation for equal signals
assign x2 = ~(a[2] ^ b[2]);
assign x1 = ~(a[1] ^ b[1]);
assign x0 = ~(a[0] ^ b[0]);

wire gt3,gt2,gt1,gt0;
wire lt3,lt2,lt1,lt0;

assign gt3 = a[3] & ~b[3];           //a>b then use AND(a_i,~b_i) 
assign gt2 = a[2] & ~b[2];
assign gt1 = a[1] & ~b[1];
assign gt0 = a[0] & ~b[0];

assign lt3 =~a[3] & b[3];          ////a<b then use AND(~a_i,b_i)
assign lt2 =~a[2] & b[2];
assign lt1 =~a[1] & b[1];
assign lt0 =~a[0] & b[0];

assign gt = gt3 | (x3 & gt2) |  (x3 & x2 & gt1) | (x3 & x2 & x1 & gt0);   //priority encoder logic for greater than, less than and equal to
assign lt = lt3 | (x3 & lt2) |  (x3 & x2 & lt1) | (x3 & x2 & x1 & lt0);
assign eq = x3 & x2 & x1 & x0;
endmodule


//TESTBENCH
module bit4_magnitude_comp_tb;

reg  [3:0] a, b;
wire gt, eq, lt;
integer errors, i, j;

bit4_comparator dut (.a(a), .b(b), .gt(gt), .eq(eq), .lt(lt));

initial begin
    errors = 0;
    $dumpfile("wave.vcd");
    $dumpvars(0, bit4_magnitude_comp_tb);

    // Corner cases — explicit
    a = 4'h0; b = 4'h0; #10; check(1'b0, 1'b1, 1'b0); // equal min
    a = 4'hF; b = 4'hF; #10; check(1'b0, 1'b1, 1'b0); // equal max
    a = 4'hF; b = 4'h0; #10; check(1'b1, 1'b0, 1'b0); // max > min
    a = 4'h0; b = 4'hF; #10; check(1'b0, 1'b0, 1'b1); // min < max
    a = 4'h8; b = 4'h7; #10; check(1'b1, 1'b0, 1'b0); // MSB decides tie-break case
    a = 4'h7; b = 4'h8; #10; check(1'b0, 1'b0, 1'b1);

    // Exhaustive sweep: all 256 combinations
    for (i = 0; i < 16; i = i + 1)
    for (j = 0; j < 16; j = j + 1) begin
        a = i; b = j; #10;
        if ({gt,eq,lt} !== {(i>j), (i==j), (i<j)}) begin
            $display("FAIL: a=%0d b=%0d got gt=%b eq=%b lt=%b", i, j, gt, eq, lt);
            errors = errors + 1;
        end
        // assertion: exactly one output must be high, never more, never zero
        if (gt + eq + lt !== 1) begin
            $display("FAIL: mutual exclusivity violated at a=%0d b=%0d", i, j);
            errors = errors + 1;
        end
    end

    if (errors == 0) $display("ALL TESTS PASSED");
    else              $display("FAILED: %0d errors", errors);
    $finish;
end

task automatic check;
    input exp_gt, exp_eq, exp_lt;
    if (gt !== exp_gt || eq !== exp_eq || lt !== exp_lt) begin
        $display("FAIL: a=%0d b=%0d exp(gt=%b eq=%b lt=%b) got(gt=%b eq=%b lt=%b)",
                  a, b, exp_gt, exp_eq, exp_lt, gt, eq, lt);
        errors = errors + 1;
    end
endtask

endmodule





module comparator_4bit_beh (                    /// behavioral model of 4 bit comparator synthesis friendly
    input  wire  [3:0] a, b,
    output logic gt, eq, lt
);
    always@ (*) begin
        gt = (a > b);
        eq = (a == b);
        lt = (a < b);
    end
endmodule


// 4-bit comparator using cascading of 1-bit comparators used in wider systems more than 8 bits
module comparator_4bit_cascade (
    input  wire [3:0] a, b,
    input  wire gt_in, eq_in, lt_in,  // cascade inputs from lower-order stage
    output wire gt_out, eq_out, lt_out
);
    assign eq_out = (a == b) & eq_in;
    assign gt_out = (a > b) | ((a == b) & gt_in);
    assign lt_out = (a < b) | ((a == b) & lt_in);
endmodule