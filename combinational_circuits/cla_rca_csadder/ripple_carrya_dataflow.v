module ripple_carrya_dataflow(
    input [3:0] a,b,
    input       cin,
    output[3:0] sum,
    output     cout
);   
                                                                  // one more way directly one line
                                                                  //  assign {cout,sum} = a+b+cin;
wire [4:0] result;                                  

assign result = a + b + cin;      // add bit one by one and carry will automatically be generated and added to next bit and so on and at the end we will get 5 bit result where 4 bit is sum and 1 bit is carry out
assign sum = result[3:0];
assign cout = result[4];
endmodule



// TESTBENCH OF RCA

module tb_ripple_carrya_dataflow;

reg  [3:0]  a,b;
reg         cin;
wire [3:0]  sum;
wire        cout;

ripple_carrya_dataflow uut(       // named port mapping //uut= unit under test
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    $dumpfile("dataflow.vcd");
    $dumpvars(0,tb_ripple_carrya_dataflow);

    a = 4'b0000; b=4'b0000; cin = 0; #10;
    $display("a=%b b=%b cin=%b | sum=%b cout=%b",a,b,cin,sum,cout);
    a = 4'b1111; b=4'b1111; cin = 0; #10;
    $display("a=%b b=%b cin=%b | sum=%b cout=%b",a,b,cin,sum,cout);
    a = 4'b0101; b=4'b0011; cin = 0; #10;
    $display("a=%b b=%b cin=%b | sum=%b cout=%b",a,b,cin,sum,cout);
    a = 4'b0111; b=4'b0001; cin = 1; #10;
    $display("a=%b b=%b cin=%b | sum=%b cout=%b",a,b,cin,sum,cout);

    $finish;
end
endmodule