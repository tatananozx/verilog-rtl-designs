module d_latch(
    input wire d,en,
    output wire q,q_bar    //by using gated nand sr latch 
);
wire s_n,r_n,d_n;

not g1(d_n,d);          //D - INVERTER
nand g2(s_n,d,en);     // S' = (D · EN)'
nand g3(r_n,d_n,en);  // R' = (D' · EN)'

// cross-coupled NAND SR core — true gate-level instantiation
nand g4(q,s_n,q_bar);
nand g5(q_bar,r_n,q);
endmodule



module d_latch_behavioral(
    input wire d,en,
    output reg q
);
                                   //synthesizable
always @(*) begin
    if(en)  
     q=d;
end        //no else so latch interfers and its intentional so synthesis tool generate a latch when en=0 then q=previous state;
endmodule

//assign q = en ? d : q;  // continuous-assignment latch (dataflow trick) //tool dependent dont use this


//sync reset
module d_latch_sync_rst (
    input  wire d, en, rst,
    output reg  q
);
    always @(*) begin
        if (en) begin
            if (rst) q = 1'b0;
            else      q = d;
        end
        // rst has NO effect while en=0 -- reset only "seen" when latch is open
    end
endmodule


//async reset 
module d_latch_async_rst (
    input  wire d, en, rst,
    output reg  q
);
    always @(*) begin
        if (rst)
            q = 1'b0;          // dominates immediately, ignores en
        else if (en)
            q = d;
    end
endmodule