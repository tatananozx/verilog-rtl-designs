module bcd_encoder_struct (
    input  wire d0, d1, d2, d3, d4, d5, d6, d7, d8, d9,
    output wire y3, y2, y1, y0
);

    wire y0_s1, y0_s2, y0_s3;
    wire y1_s1, y1_s2;
    wire y2_s1, y2_s2;

    // Y0 = d1 + d3 + d5 + d7 + d9  (OR tree, 2-input primitives)
    or g1 (y0_s1, d1, d3);
    or g2 (y0_s2, d5, d7);
    or g3 (y0_s3, y0_s1, y0_s2);
    or g4 (y0, y0_s3, d9);

    // Y1 = d2 + d3 + d6 + d7
    or g5 (y1_s1, d2, d3);
    or g6 (y1_s2, d6, d7);
    or g7 (y1, y1_s1, y1_s2);

    // Y2 = d4 + d5 + d6 + d7
    or g8 (y2_s1, d4, d5);
    or g9 (y2_s2, d6, d7);
    or g10 (y2, y2_s1, y2_s2);

    // Y3 = d8 + d9
    or g11 (y3, d8, d9);

endmodule



module bcd_encoder_df (
    input  wire [9:0] d,   // d[9:0] = D9..D0
    output wire [3:0] y
);
    assign y[0] = d[1] | d[3] | d[5] | d[7] | d[9];
    assign y[1] = d[2] | d[3] | d[6] | d[7];
    assign y[2] = d[4] | d[5] | d[6] | d[7];
    assign y[3] = d[8] | d[9];
endmodule


module bcd_priority_encoder (
    input  wire [9:0] d,
    output reg [3:0] y,
    output reg valid
);
    always@(*) begin
        valid = 1'b1;
        casez (d)
            10'b1?????????: y = 4'd9;
            10'b01????????: y = 4'd8;
            10'b001???????: y = 4'd7;
            10'b0001??????: y = 4'd6;
            10'b00001?????: y = 4'd5;
            10'b000001????: y = 4'd4;
            10'b0000001???: y = 4'd3;
            10'b00000001??: y = 4'd2;
            10'b000000001?: y = 4'd1;
            10'b0000000001: y = 4'd0;
            default:          begin y = 4'd0; valid = 1'b0; end
        endcase
    end
endmodule




module bcd_encoder_casez (
    input  wire [9:0] d,
    output reg [3:0] y
);
    always@(*) begin
        case (1'b1)
            d[0]: y = 4'd0;
            d[1]: y = 4'd1;
            d[2]: y = 4'd2;
            d[3]: y = 4'd3;
            d[4]: y = 4'd4;
            d[5]: y = 4'd5;
            d[6]: y = 4'd6;
            d[7]: y = 4'd7;
            d[8]: y = 4'd8;
            d[9]: y = 4'd9;
            default: y = 4'd0;
        endcase
    end
endmodule