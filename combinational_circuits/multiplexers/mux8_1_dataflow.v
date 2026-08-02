module mux8_1_datalflow(
    input [7:0] i,
    input [2:0] s,
    output y
);

assign y = i[s];  // The select signal 's' is used to index into the input vector 'i' to select the appropriate bit.
endmodule