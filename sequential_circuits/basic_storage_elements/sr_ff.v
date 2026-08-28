module sr_latch(
    input wire s,r,en,
    output wire q,q_bar
);

wire s_g,r_g;

nand g1(s_g,s,en);                  //NAND GATE SR LATCH
nand g2(r_g,r,en);
nand g3(q,s_g,q_bar);
nand g4(q_bar,r_g,q);
endmodule

module sr_ff(
    input wire s,r,
    input wire clk,
    output wire q                    //SR FLIP FLoP MASTER SLAVE
);

wire clk_bar = ~clk;
wire qm,qm_bar,qbar;

sr_latch master (.s(s), .r(r), .en(clk_bar), .q(qm), .q_bar(qm_bar));
sr_latch slave (.s(qm), .r(qm_bar), .en(clk), .q(q), .q_bar(qbar));
endmodule



module sr_ff_sync_rst(
    input wire s,r,
    input wire clk,rst_n,    //rst_n = ACTIVE LOW
    output reg q 
    );

    always @(posedge clk ) begin
        if (!rst_n) q <= 1'b0;
        else case ({s,r})
        2'b00: q <= q;      //hold
        2'b01: q <= 1'b0;   //reset
        2'b10: q <= 1'b1;   //set
        2'b11: q <= 1'bx;   //invalid
    endcase
    end
endmodule


module sr_ff_async_rst(
    input wire s,r,
    input wire clk,rst_n,    //rst_n = ACTIVE LOW
    output reg q 
    );
                                                         //RESET OPERATION INDEPENDENT OF THE CLOCK-FORCES Q TO CHANGE IMMEDIATELY
    always @(posedge clk or negedge rst_n ) begin
        if (!rst_n) q <= 1'b0;
        else case ({s,r})
        2'b00: q <= q;      //hold
        2'b01: q <= 1'b0;   //reset
        2'b10: q <= 1'b1;   //set
        2'b11: q <= 1'bx;   //invalid
    endcase
    end
endmodule