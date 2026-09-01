module async_ring_counter(  //4-BIT ASYNCHRONOUS RING COUNTER
    input wire clk, // sync clock
    input wire rst_n, //active low reset async
    output reg [3:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) q <= 4'b0001; //reset state where one ff must be high
    else q<= {[2:0]q, q[3]}; //shift left and wrap around
end 
endmodule

module ring_counter_4_sync (   //synchronous ring counter dependemt on clock
    input  wire clk, rst_n,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (!rst_n)
            q <= 4'b0001;         // one-hot init, sync
        else
            q <= {q[2:0], q[3]}; // rotate left, wraps Q3->Q0
    end
endmodule



//INDUSTRY SHORTHAND - Concatenation Rotate
//assign next_q = {q[N-2:0], q[N-1]}; // rotate-left in one line, scales to any N


//structural using genvar and generate block scles to any N- used in industry for larger ring counters
module ring_counter_gen #(parameter N = 4) (
    input  wire clk, rst_n,
    output wire [N-1:0] q
);
    wire [N-1:0] d;
    assign d[0] = q[N-1];              // feedback
    genvar i;
    generate
        for (i = 1; i < N; i = i + 1) begin : ff_chain
            assign d[i] = q[i-1];
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < N; j = j + 1) begin : ff_inst
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) q[j] <= (j == 0) ? 1'b1 : 1'b0;  // asymmetric reset per bit
                else        q[j] <= d[j];
            end
        end
    endgenerate
endmodule