module up_down_counter(
    input wire clk,  //synchronous
    input wire rst_n, //active low-asynchronous
    input wire up_down, //1 = up and 0 = down
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin   //async reset independent of clock
    if (!rst_n) 
    count <= 4'b0000;
    else if (up_down)
    count <= count + 1;
    else
    count <= count - 1 ; 
end
endmodule



module up_down_counter_sync(
    input wire clk,  //synchronous
    input wire rst_n, //active low-synchronous
    input wire up_down, //1 = up and 0 = down
    output reg [3:0] count
);

always @(posedge clk) begin   //sync reset dependent of clock
    if (!rst_n) 
    count <= 4'b0000;
    else if (up_down)
    count <= count + 1;
    else
    count <= count - 1 ; 
end
endmodule



//industry shorthand 
module updown_counter_param #(parameter N = 4) (
    input  wire           clk, rst_n, en, up_down,
    output reg  [N-1:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= {N{1'b0}};
        else if (en)
            count <= up_down ? count + 1'b1 : count - 1'b1;
        // else: hold (no explicit else needed — normal register hold, not a latch)
    end
endmodule