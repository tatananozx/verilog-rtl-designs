module piso_shiftregister(
    input wire clk,rst_n,load,  //// 1 = parallel load, 0 = shift
    input wire [3:0] parallel_in,
    output reg serial_out
);
    reg [3:0] q;

    always @(posedge clk or negedge rst_n) begin          //async reset
        if (!rst_n)
            q <= 4'b0000;
        else if (load)
            q <= parallel_in;             // parallel load, no shift    //"load has priority over shift"
        else
            q <= {1'b0, q[3:1]};    // shift right, MSB-in = 0 (or chain serial_in)
    end

    assign serial_out = q[0];   // LSB shifted out first
endmodule