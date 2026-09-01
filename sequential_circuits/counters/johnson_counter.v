module d_ff_async(
    input wire clk,d,  //sync clock
    input wire rst_n, //active low async reset
    output reg q
);

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) q <= 1'b0;
    else q <= d;
end
endmodule

module jc_4bit_structural(
    input wire clk,rst_n,
    output wire [3:0] q
);

wire fb; //feedback wire 
assign fb = ~q[3]; // will go from last stage ff o/p to 1st ff i/p

d_ff_async ff0 (.clk(clk), .rst_n(rst_n), .d(fb), .q(q[0]));
d_ff_async ff1 (.clk(clk), .rst_n(rst_n), .d(q[0]), .q(q[1]));
d_ff_async ff2 (.clk(clk), .rst_n(rst_n), .d(q[1]), .q(q[2]));
d_ff_async ff3 (.clk(clk), .rst_n(rst_n), .d(q[2]), .q(q[3]));
endmodule




//behavioral 
module jc_async(
    input wire clk,
    input wire rst_n,
    output reg [3:0] q
);

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) q <= 4'b0000;
    else q <= {q[2:0], ~q[3]};
end
endmodule




//Behavioral Style — Async Reset (industry-preferred)
module johnson_counter_async #(parameter N = 4) (
    input  wire            clk,
    input  wire            rst_n,
    output reg  [N-1:0]  q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= {N{1'b0}};
        else
            q <= {q[N-2:0], ~q[N-1]};  // shift left, feed inverted MSB into LSB
    end
endmodule



//Behavioral Style — Sync Reset

module johnson_counter_sync #(parameter N = 4) (
    input  wire            clk,
    input  wire            rst_n,
    output reg  [N-1:0]  q
);
    always @(posedge clk) begin       // rst_n NOT in sensitivity list
        if (!rst_n)
            q <= {N{1'b0}};
        else
            q <= {q[N-2:0], ~q[N-1]};
    end
endmodule