module reset_sync (
    input  wire clk_dst,
    input  wire async_rst_n,
    output reg  sync_rst_n
);
    reg ff1;

    always @(posedge clk_dst or negedge async_rst_n) begin
        if (!async_rst_n) begin
            ff1        <= 1'b0;
            sync_rst_n <= 1'b0;
        end else begin
            ff1        <= 1'b1;
            sync_rst_n <= ff1;
        end
    end
endmodule