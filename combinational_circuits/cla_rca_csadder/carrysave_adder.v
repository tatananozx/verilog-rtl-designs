module full_adder(
    input a,b,cin,
    output sum,cout
);

assign sum = a^b^cin;
assign cout = (a&b) | (b&cin) | (a&cin);
endmodule

                                     //structural modeling using generate statement // 4bit carry save adder but without final final RCA OR CLA FOR FINAL O/P 
module carrysave_adder(
    input [3:0] a,b,c,
    output [3:0] sum,
    output [4:1] carry
);

genvar i;
generate 
    for (i=0; i<4; i=i+1) begin fa_array
    full_adder fa(.a(a[i]), .b(b[i]), .cin(c[i]), .sum(sum[i]), .cout(carry[i+1]));
    end
endgenerate
endmodule



module carrysave_adder_dataflow(
    input [3:0] a,b,c,
    output [3:0] sum,
    output [4:1] carry
);

assign sum = a^b^c;
assign carry = {(a[3]&b[3]) | (b[3]&c[3]) | (a[3]&c[3]),            //used concatentaion because we want the MSB first in carry output 
                (a[2]&b[2]) | (b[2]&c[2]) | (a[2]&c[2]),             // NOT FINAL WE NEED TO ADD CLA OR RCA FOR FINAL O/P
                (a[1]&b[1]) | (b[1]&c[1]) | (a[1]&c[1]),
                (a[0]&b[0]) | (b[0]&c[0]) | (a[0]&c[0]))};
endmodule



module carrysave_adder_behavioral(
    input [3:0] a,b,c,
    output reg  [4:0] result
);
   reg [3:0] sum_vec;
   reg [4:1] carry_vec;

always @(*) begin
    sum_vec = a^b^c;
    carry_vec[4:1] = (a&b) | (b&c) | (a&c);
    carry_vec[0] = 0;
    result = sum_vec + carry_vec; // No carry-in for the least significant bit
end
endmodule
