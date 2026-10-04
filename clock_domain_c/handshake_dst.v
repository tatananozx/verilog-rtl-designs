module handshake_dst (
    input  wire clk_dst, rst_n,
    input  wire req_sync,
    input  wire [7:0] data_in,
    output reg  [7:0] data_out,
    output reg  ack
); //this is only dst side module it will then connect to 2ff synz and then back to the source side module
    localparam IDLE = 1'b0, WAIT_REQ_LOW = 1'b1;
    reg state;

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; ack <= 0; data_out <= 0;
        end else case (state)
            IDLE: if (req_sync) begin
                data_out <= data_in;   // capture — safe, req_sync already proves stability
                ack <= 1'b1;
                state <= WAIT_REQ_LOW;
            end
            WAIT_REQ_LOW: if (!req_sync) begin
                ack <= 1'b0;
                state <= IDLE;
            end
        endcase
    end
endmodule