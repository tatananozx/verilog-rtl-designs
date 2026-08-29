module t_ff_async (
    input wire clk,rst_n,     //active low reset and asynchronous
    output reg q
);
             //negative edge triggered
always @(negedge clk or negedge rst_n) begin
    if (!rst_n)
    q <= 1'b0;
    else
    q <= ~q;    //T=1 always toggle
end
endmodule

module ripple_counter_async(                        //4 bit ripple counter asynchronous
    input wire clk,rst_n,
    output wire [3:0] q
);

t_ff_async ff0 (.clk(clk), .rst_n(rst_n), .q(q[0]));
t_ff_async ff1 (.clk(q[0]), .rst_n(rst_n), .q(q[1]));
t_ff_async ff2 (.clk(q[1]), .rst_n(rst_n), .q(q[2]));
t_ff_async ff3 (.clk(q[2]), .rst_n(rst_n), .q(q[3]));
endmodule



//BEHAVIORAL (SIMULATION-ONLY SHORTHAND — SEE WARNING)
module ripple_counter_4bit_beh (
    input  wire clk, rst_n,
    output reg [3:0] q
);
    always @(negedge clk or negedge rst_n)
        if (!rst_n) q <= 4'b0000;
        else        q <= q + 1'b1;
endmodule
//Interview trap: This behavioral code is functionally a counter, but it synthesizes to a synchronous counter (all 4 bits share one real clock + combinational +1 adder), NOT an asynchronous ripple counter. If asked to model the actual ripple topology (with its accumulated delay), you must write the structural chained version above. Don't offer this as "the ripple counter" — call this out if an interviewer pushes on it.