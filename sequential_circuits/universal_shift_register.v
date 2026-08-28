module uni_shift_register (               //synchronus-used in industry
    input wire clk,rst_n,  //active low reset
    input wire [1:0] sel, // select-2 bit
    input wire serial_in_r, serial_in_l,
    input wire [3:0] p,
    output reg [3:0] q
);


always @(posedge clk) begin
    if (!rst_n)                     //reset top priority before any operation
     q <= 4'b0000;
     else case(sel)
       2'b00: q <= q;                                    //hold
       2'b01: q <= {serial_in_r , q[3:1]};               //shift right
       2'b10: q <= {q[2:0] , serial_in_l};               //shift left
       2'b11: q <= p;                                    //parallel load
     default: q <= q;         //for safety same as hold
endcase
end
endmodule
