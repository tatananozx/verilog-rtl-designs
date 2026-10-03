module sync_2ff (
    input  wire clk_dst,  //destination clock domain
    input  wire rst_n,    //active low reset
    input  wire async_in, //asynchronous input signal
    output reg  sync_out  //synchronized output signal
);
    reg ff1; //first flip-flop in the synchronizer chain

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n) begin
            ff1      <= 1'b0;
            sync_out <= 1'b0;
        end else begin
            ff1      <= async_in;
            sync_out <= ff1;
        end
    end
endmodule