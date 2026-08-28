module d_ff_async(
    input wire clk,rst_n,    //active low reset
    input wire d,
    output reg q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) q <= 1'b0;
    else q <= d;
end
endmodule
                               //STRUCTURAL STYLE WITH D FLIP FLOP

module siso_4bit(
    input wire clk,rst_n,serial_in,
    output wire serial_out
);

wire q0,q1,q2;

d_ff_async ff0 (.clk(clk), .rst_n(rst_n), .d(serial_in), .q(q0));
d_ff_async ff1 (.clk(clk), .rst_n(rst_n), .d(q0), .q(q1));
d_ff_async ff2 (.clk(clk), .rst_n(rst_n), .d(q1), .q(q2));
d_ff_async ff3 (.clk(clk), .rst_n(rst_n), .d(q2), .q(serial_out));
endmodule