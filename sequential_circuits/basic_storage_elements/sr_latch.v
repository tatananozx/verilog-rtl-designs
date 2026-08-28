module sr_latch(
    input wire s,r,  //s=set and r=reset
    output wire q,nq //q=Q and nq=~Q
);         //NOR BASED-ACTIVE HIGH S/R 
nor g1(q,r,nq);
nor g2(nq,s,q);         //idle state s=r=0 = hold
endmodule


module sr_latch_nand(
    input wire s_n,r_n,  //NAND BASED-ACTIVE LOW S/R
    output wire q,nq
);                              //idle state s_n=r_n = 1 = hold
nand g1(q,s_n,nq);
nand g2(nq,r_n,q);       //more prefered in standard cell libraries typically faster & smaller than nor
endmodule

module sr_latch_behavioral(
    input s,r,en,            //gated sr latch used so we dont have race condition s=r=1
    output reg q,
    output qn    //no reg for this one beacuse it doesnt drive input 
);
                                     //synthesizable
always @(*) begin
    if (en) begin
        if (s && !r) q=1'b1;
        else if (!s && r) q=1'b0;
        else if (s && r) q=1'bx;      //no if else intended latch we want but for diiferent ff must use if else at last
    end  // s=0,r=0 → q retains old value (this is what infers the latch)
end     // en=0 → q retains old value too — intentional level-sensitive latch
assign qn = ~q;
endmodule

//DATAFLOW ONLY GOOD FOR SIMULATION DIRECT BOOLEAN EXPRESSION