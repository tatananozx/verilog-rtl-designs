module cla_4bit_dataflow(
    input  [3:0] a,b,
    input        cin,
    output [3:0] sum,
    output       cout
);

     wire [3:0] g,p;
     wire [4:0] c;

     assign g = a & b;    //GENERATE
     assign p = a ^ b;    //PROPAGATE

       assign c[0] = cin;        //CARRY equation
       assign c[1] = g[0] | (p[0] & c[0]);
       assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
       assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
       assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

      // SUM EQUATION
       assign sum = p ^ c[3:0];
       assign cout = c[4];

endmodule 


//TESTBENCH FOR CLA


module tb_cla_4bit_dataflow; 
    reg   [3:0] a,b;
    reg         cin;
    wire  [3:0] sum;
    wire        cout;
 

cla_4bit_dataflow uut( .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout) );

initial begin
    $dumpfile("cla.vcd");
    $dumpvars(0,tb_cla_4bit_dataflow);

    a = 4'b0000; b = 4'b0000; cin = 0; #10;
    a = 4'b0001; b = 4'b0001; cin = 0; #10;
    a = 4'b1111; b = 4'b0001; cin = 0; #10;
    a = 4'b1010; b = 4'b0101; cin = 1; #10;
    a = 4'b1111; b = 4'b1111; cin = 1; #10;

    $display("a=%b b=%b cin=%b => sum=%b cout=%b", a, b, cin, sum, cout);
    $finish;    
end 
endmodule
