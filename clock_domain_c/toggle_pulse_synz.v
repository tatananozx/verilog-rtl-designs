module toggle_ff (
    input  wire clk_src, rst_n, pulse_in,
    output reg  toggle_sig
);
    always @(posedge clk_src or negedge rst_n) begin
        if (!rst_n)       toggle_sig <= 1'b0;
        else if (pulse_in) toggle_sig <= ~toggle_sig;
    end
endmodule
//in this module tb there will be two clock domains, one for the source and one for the destination. The source clock will generate a pulse signal that will be used to toggle the toggle_sig output. The destination clock will synchronize the toggle_sig signal and generate a pulse_out signal whenever there is a change in the toggle_sig signal.
module toggle_sync (
    input  wire clk_dst, rst_n, toggle_sig,
    output wire pulse_out
);
    reg sync_ff1, sync_ff2, sync_ff3;

    always @(posedge clk_dst or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff1 <= 1'b0; sync_ff2 <= 1'b0; sync_ff3 <= 1'b0;
        end else begin
            sync_ff1 <= toggle_sig;
            sync_ff2 <= sync_ff1;
            sync_ff3 <= sync_ff2;
        end
    end

    assign pulse_out = sync_ff2 ^ sync_ff3;
endmodule