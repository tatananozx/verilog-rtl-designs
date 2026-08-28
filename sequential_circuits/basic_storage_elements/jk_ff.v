module jk_ff_structural (
    input  wire j, k, clk,
    output wire q, qn
);                                    //not get synthesized in real asic flow
    wire clkn;
    wire sm, rm, qm, qmn;
    wire ss, rs;
    not (clkn, clk);
    // ---- MASTER STAGE (transparent when clk = 1) ----
    nand (sm, j, clk, qn);   // feedback from SLAVE output qn
    nand (rm, k, clk, q);    // feedback from SLAVE output q
    nand (qm,  sm, qmn);
    nand (qmn, rm, qm);
    // ---- SLAVE STAGE (transparent when clk = 0) ----
    nand (ss, qm,  clkn);
    nand (rs, qmn, clkn);
    nand (q,  ss, qn);
    nand (qn, rs, q);
endmodule


module jk_ff_sync_reset(
    input wire j,k,
    input wire clk,rst_n,   //active low, synchronous
    output reg  q
);

always@(posedge clk) begin
    if(!rst_n)
    q <= 1'b0;
    else case ({j,k})
    2'b00: q <= q;     //hold
    2'b01: q <= 1'b0;  //reset
    2'b10: q <= 1'b1;  //set
    2'b11: q <= ~q;    //toggle
endcase
end
endmodule

module jk_ff_async_reset(
    input wire j,k,
    input wire clk,rst_n,   //active low, asynchronous
    output reg  q
);

always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
    q <= 1'b0;                                   //override immediately, no clock edge needed
    else case ({j,k})
    2'b00: q <= q;     //hold
    2'b01: q <= 1'b0;  //reset
    2'b10: q <= 1'b1;  //set
    2'b11: q <= ~q;    //toggle
endcase
end
endmodule





module jk_via_d (
    input  wire clk, rst_n, j, k,
    output reg  q
);
    wire d = (j & ~q) | (~k & q);   // characteristic equation directly

    always @(posedge clk or negedge rst_n)
        if (!rst_n) q <= 1'b0;
        else        q <= d;   //This is what synthesis produces internally regardless of which style you write — it maps to a D-FF cell with this exact logic feeding D.
endmodule