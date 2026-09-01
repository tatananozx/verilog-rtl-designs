module gray_counter_async(
    input wire clk, //posedge
    input wire rst_n, // active low async reset- independent of clock
    output wire [3:0] gray_code  //declared as wire must used assign statement to drive the output
);

reg [3:0] bin;  //reg used in always block to store the binary count value

always @(posedge clk or negedge rst_n) begin //reset immediately
     if (!rst_n) bin <= 4'b0000;
     else bin <= bin + 1'b1;
end

assign gray_code = bin ^ (bin >> 1); //binary to gray code conversion

endmodule



//see what is driving to the output, if it is reg then use always block, if it is wire then use assign statement




module gray_counter_sync #(parameter N = 4) (
    input  wire            clk,  //synchronous clock
    input  wire            rst_n, //active low sync reset- dependent on clock
    output reg [N-1:0] gray  //declared as reg must used always block to drive the output
);
    reg [N-1:0] bin;

    always @(posedge clk) begin
        if (!rst_n)
            bin <= {N{1'b0}};
        else
            bin <= bin + 1'b1;
    end


    always@(*) begin
        gray = bin ^ (bin >> 1);
    end
endmodule




//structural scalable gray code counter using generate statement, no hand-written per-bit equations
module gray_counter_generate #(parameter N = 4) (
    input  wire            clk,
    input  wire            rst_n,
    output wire [N-1:0]    gray
);
    reg [N-1:0] bin;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) bin <= {N{1'b0}};
        else        bin <= bin + 1'b1;
    end

    // Structural, scalable conversion — no hand-written per-bit equations
    assign gray[N-1] = bin[N-1];               // MSB passthrough

    genvar i;
    generate
        for (i = 0; i < N-1; i = i + 1) begin : gray_xor
            assign gray[i] = bin[i] ^ bin[i+1]; // explicit XOR2 per bit, structurally instantiated
        end
    endgenerate
endmodule