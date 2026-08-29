module t_ff(
    input wire clk,rst_n,t,
    output reg q
);                                             // USING D FLIP FLOP IS ALSO THERE
                                              //T-FF BASED STRUCTURAL only for derivation/interviews not used in synthesis
always@(posedge clk) begin   // indusrty preffered synchronous not async
    if (!rst_n) q <= 1'b0;
    else q <= t ^ q;
end
endmodule

module counter_4bit_sync(
    input wire clk,rst_n,
    output wire [3:0] q
);

wire t1,t2,t3;      //intermediate wire between 4 flips flops
assign t1 = q[0];
assign t2 = q[0] & q[1];
assign t3 = q[0] & q[1] & q[2];

t_ff ff0 (.clk(clk), .rst_n(rst_n), .t(1'b1), .q(q[0]));
t_ff ff1 (.clk(clk), .rst_n(rst_n), .t(t1), .q(q[1]));
t_ff ff2 (.clk(clk), .rst_n(rst_n), .t(t2), .q(q[2]));
t_ff ff3 (.clk(clk), .rst_n(rst_n), .t(t3), .q(q[3]));
endmodule




//Behavioral Style — SYNC RESET (industry-preferred for counters)

module synchronous_counter(
    input wire clk,rst_n,
    output reg [3:0] q
);

always @(posedge clk) begin  //FOR ASYNC ADD THIS IN SENSTIVITY LIST - (or negedge rst_n).
    if (!rst_n) q <= 4'b0000;
    else q <= q + 1'b1;
end
endmodule //pick sync for counters unless you have a specific power-on/fault-recovery requirement.

//Sync reset is glitch-free, needs no reset synchronizer, and adds reset logic to the existing data path (no extra reset routing tree).
//Async reset reacts instantly but its de-assertion edge can violate recovery/removal timing if it lands near a clock edge — mandates a 2-FF reset synchronizer in real silicon.