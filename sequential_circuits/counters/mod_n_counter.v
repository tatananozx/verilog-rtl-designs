module sync_mod_n_counter (
    input wire clk,
    input wire rst_n, //active low async reset
    output reg [2:0] count    //MOD-6 COUNTER, SO TOTAL 3 FLIP FLOPS AND 8 POSSIBLE STATES,ONLY 6 USED
);

                                                //synchronous design method
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    count <= 3'b000;
    else case(count)
      3'b000: count <= 3'b001;
      3'b001: count <= 3'b010;
      3'b010: count <= 3'b011;
      3'b011: count <= 3'b100;
      3'b100: count <= 3'b101;
      3'b101: count <= 3'b000;
      default: count <= 3'b000;  //must needed for illegal state like 6 and 7 in binary for recovery
endcase
end
endmodule


module dff_async_rst (
    input  wire clk, rst_n, d,
    output reg  q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 1'b0;
        else        q <= d;
    end
endmodule



//The gate-level structural version is there to prove you understand why it works underneath.
module mod6_counter_structural (
    input  wire clk, rst_n,
    output wire [2:0] q
);
    wire d0, d1, d2;

    // D0 = Q0'
    assign d0 = ~q[0];

    // D1 = (Q1'.Q0.Q2') + (Q1.Q0')
    assign d1 = (~q[1] & q[0] & ~q[2]) | (q[1] & ~q[0]);

    // D2 = (Q2'.Q1.Q0) + (Q2.Q1'.Q0')
    assign d2 = (~q[2] & q[1] & q[0]) | (q[2] & ~q[1] & ~q[0]);

    dff_async_rst ff0 (.clk(clk), .rst_n(rst_n), .d(d0), .q(q[0]));
    dff_async_rst ff1 (.clk(clk), .rst_n(rst_n), .d(d1), .q(q[1]));
    dff_async_rst ff2 (.clk(clk), .rst_n(rst_n), .d(d2), .q(q[2]));
endmodule




                                    //DETECT & RESET METHOD USED IN INDUSTRY RTL 
module mod_n_counter_async #(parameter N = 6, parameter W = 3) (
    input  wire            clk,
    input  wire            rst_n,   // active-low async
    output reg  [W-1:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else if (count == N-1)
            count <= 0;             // wrap at N, not at 2^W
        else
            count <= count + 1'b1;
    end
endmodule


//sync active low reset
module mod_n_counter_sync #(parameter N = 6, parameter W = 3) (
    input  wire            clk,
    input  wire            rst_n,   // active-low sync
    output reg  [W-1:0] count
);
    always @(posedge clk) begin   // no rst_n in sensitivity list = sync
        if (!rst_n)
            count <= 0;
        else if (count == N-1)
            count <= 0;
        else
            count <= count + 1'b1;
    end
endmodule