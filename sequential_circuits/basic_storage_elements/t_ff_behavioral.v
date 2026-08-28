module t_ff_sync(
    input wire t,clk,rst_n, //active low
    output reg q                       //dependent on clock
);
                                    //q(next) or d = t xor q
always @(posedge clk) begin
    if(!rst_n) q <= 1'b0;
    else if (t) 
    q <= ~q;   //T = 1 then toggling 
    else 
    q <= q;    //T = 0 hold value
end
endmodule



module t_ff_async(
    input wire t,clk,rst_n, //active low
    output reg  q
);                                  //independent of clock reset immediately
                                    //q(next) or d = t xor q
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) q <= 1'b0;
    else if (t) 
    q <= ~q;   //T = 1 then toggling 
    else 
    q <= q;    //T = 0 hold value
end
endmodule



module t_ff_from_jk (
    input  wire clk, rst_n, t,
    output reg  q            //Shorthand / Industry Trick Style — via JK-FF style (T = J = K)
);
    // JK characteristic: Q_next = J.Q' + K'.Q
    // set J = K = T -> Q_next = T.Q' + T'.Q = T XOR Q  (same as T-FF)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)      q <= 1'b0;
        else if (t) q <= ~q;
    end
endmodule