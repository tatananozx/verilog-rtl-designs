module bcd_7seg_behavioral (
    input  wire  [3:0] bcd,
    output reg [6:0] seg   // {a,b,c,d,e,f,g}
);
    always@(*) begin
        case (bcd)                                  //industy level used in rtl case statement automatically derives sop  
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;             //dont care only for k-map for easy minimization
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;       //alyways use deafult in case and dont leave dont'cares floating always assign blank or all zero
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            default: seg = 7'b0000000;  // invalid BCD → blank display, NOT don't-care in RTL
        endcase
    end
endmodule




module bcd_7seg_dataflow (
    input  wire [3:0] bcd,   // bcd[3]=b3 ... bcd[0]=b0
    output wire [6:0] seg     // seg[6]=a ... seg[0]=g
);                                                                              //dataflow model using direct equations of outputs
    wire b3 = bcd[3], b2 = bcd[2], b1 = bcd[1], b0 = bcd[0];

    assign seg[6] = b1 | b3 | (b0 & b2) | (~b0 & ~b2);              // a
    assign seg[5] = ~b2 | (b0 & b1) | (~b0 & ~b1);               // b
    assign seg[4] = b0 | b2 | ~b1;                              // c
    assign seg[3] = b3 | (b1&~b0) | (b1&~b2) | (~b0&~b2) | (b0&b2&~b1); // d
    assign seg[2] = (b1 & ~b0) | (~b0 & ~b2);                      // e
    assign seg[1] = b3 | (b2&~b0) | (b2&~b1) | (~b0&~b1);        // f
    assign seg[0] = b3 | (b1&~b0) | (b1&~b2) | (b2&~b1);        // g

endmodule




module bcd_7seg_structural (
    input  wire b3, b2, b1, b0,
    output wire a, b, c, d, e, f, g
);
    wire nb0, nb1, nb2;
    not (nb0, b0);
    not (nb1, b1);
    not (nb2, b2);

    // a = b1 + b3 + b0.b2 + b0'.b2'
    wire a_t1, a_t2;
    and (a_t1, b0, b2);
    and (a_t2, nb0, nb2);
    or  (a, b1, b3, a_t1, a_t2);

    // b = b2' + b0.b1 + b0'.b1'
    wire b_t1, b_t2;
    and (b_t1, b0, b1);
    and (b_t2, nb0, nb1);
    or  (b, nb2, b_t1, b_t2);

    // c = b0 + b2 + b1'
    or (c, b0, b2, nb1);

    // d = b3 + b1.b0' + b1.b2' + b0'.b2' + b0.b2.b1'
    wire d_t1, d_t2, d_t3, d_t4;
    and (d_t1, b1, nb0);
    and (d_t2, b1, nb2);
    and (d_t3, nb0, nb2);
    and (d_t4, b0, b2, nb1);
    or  (d, b3, d_t1, d_t2, d_t3, d_t4);

    // e = b1.b0' + b0'.b2'
    wire e_t1, e_t2;
    and (e_t1, b1, nb0);
    and (e_t2, nb0, nb2);
    or  (e, e_t1, e_t2);

    // f = b3 + b2.b0' + b2.b1' + b0'.b1'
    wire f_t1, f_t2, f_t3;
    and (f_t1, b2, nb0);
    and (f_t2, b2, nb1);
    and (f_t3, nb0, nb1);
    or  (f, b3, f_t1, f_t2, f_t3);

    // g = b3 + b1.b0' + b1.b2' + b2.b1'
    wire g_t1, g_t2, g_t3;
    and (g_t1, b1, nb0);
    and (g_t2, b1, nb2);
    and (g_t3, b2, nb1);
    or  (g, b3, g_t1, g_t2, g_t3);

endmodule


//testbench
module tb_bcd_7seg_behavioral;

reg [3:0] bcd;
wire [6:0] seg;
integer errors, i;

// expected reference model — independent of DUT implementation
reg [6:0] expected;

bcd_7seg_behavioral  uut (.bcd(bcd), .seg(seg));

initial begin
    errors = 0;
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_bcd_7seg_behavioral);

    for (i = 0; i < 16; i = i + 1) begin
        bcd = i; #10;
        case(i)
            0:  expected = 7'b1111110;
            1:  expected = 7'b0110000;
            2:  expected = 7'b1101101;
            3:  expected = 7'b1111001;
            4:  expected = 7'b0110011;
            5:  expected = 7'b1011011;
            6:  expected = 7'b1011111;
            7:  expected = 7'b1110000;
            8:  expected = 7'b1111111;
            9:  expected = 7'b1111011;
            default: expected = 7'b0000000; // 10-15 invalid
        endcase

        if (seg !== expected) begin
            $display("FAIL: bcd=%0d expected=%b got=%b", i, expected, seg);
            errors = errors + 1;
        end
    end

    if (errors == 0) $display("ALL TESTS PASSED");
    else              $display("FAILED: %0d errors", errors);
    $finish;
end

endmodule
