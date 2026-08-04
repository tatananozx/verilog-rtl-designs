module full_adder(
    input a,b,cin,
    output sum,cout);
wire w1,w2,w3;

xor g1(w1,a,b);        // w1=a^b
xor g2(sum,w1,cin);                 
and g3(w2,a,b);       // w2=a&b
and g4(w3,w1,cin);    // w3=(a^b)&cin which means w3=(a&cin)^(b&cin)
or g5(cout,w2,w3);
endmodule


module ripple_carry_adder(
    input [3:0]  a,b,                 
    input        cin,
    output [3:0] sum,
    output       cout 
);

    wire c1,c2,c3;         //4 bit then 3 wire if 8 bit then 7 wire
    
    full_adder fa0(a[0],b[0],cin,sum[0],c1); //handles 0 bit                  // full_adder (a, b, cin, sum, cout)  #port order rules
    full_adder fa1(a[1],b[1],c1,sum[1],c2);  //handles 1 bit
    full_adder fa2(a[2],b[2],c2,sum[2],c3);  //handles 2 bit
    full_adder fa3(a[3],b[3],c3,sum[3],cout); //handles 3 bit and its carry goes directly to output of that adder
endmodule


// TESTBENCH FOR RCA

module tb_ripple_carry_adder;

reg  [3:0]  a,b;
reg         cin;
wire [3:0]  sum;
wire        cout;

ripple_carry_adder uut(       // named port mapping //uut= unit under test
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    $dumpfile("rca.vcd");
    $dumpvars(0,tb_ripple_carry_adder);

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