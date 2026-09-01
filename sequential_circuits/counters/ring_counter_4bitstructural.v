module dff_async (                 //use the scalable structural block with genrate and genvar to make a ring counter of any size
    input  wire clk, rst_n, d,
    output reg  q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 1'b0;
        else        q <= d;
    end
endmodule

module ring_counter_4_struct (
    input  wire clk, rst_n,
    output wire [3:0] q
);
    wire d0, d1, d2, d3;

    assign d0 = q[3];   // feedback: Q3 -> D0
    assign d1 = q[0];
    assign d2 = q[1];
    assign d3 = q[2];

    // NOTE: FF0 needs a DIFFERENT reset value (1) than FF1-3 (0).
    // A plain dff_async instance resets to 0 for all -- FF0 must be
    // handled with its own always block below, OR use a parameterized
    // reset-value FF. Structural purity vs correctness trade-off shown
    // explicitly here (interviewers probe this exact point).
    reg q0_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q0_r <= 1'b1;   // FF0 resets to 1
        else        q0_r <= d0;
    end

    dff_async ff1 (.clk(clk), .rst_n(rst_n), .d(d1), .q(q[1]));
    dff_async ff2 (.clk(clk), .rst_n(rst_n), .d(d2), .q(q[2]));
    dff_async ff3 (.clk(clk), .rst_n(rst_n), .d(d3), .q(q[3]));

    assign q[0] = q0_r;
endmodule