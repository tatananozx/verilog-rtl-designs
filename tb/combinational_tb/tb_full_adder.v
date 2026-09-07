module tb_full_adder;
reg a,b,cin;
wire sum,carry;
integer errors,i,j,k; //reg [2:0] vec; shortcut for 3 bit vector, but we can use integer as well

full_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .carry(carry));

initial begin
    $dumpfile("sim/full_adder.vcd");
    $dumpvars(0,tb_full_adder);
    errors = 0;
 //for (vec = 0; vec < 8; vec = vec + 1) begin
 // {a, b, cin} = vec; #10; check; end
    for (i=0; i<2; i=i+1)  //1 bit signal maximum 2 values 0 and 1
    for (j=0; j<2; j=j+1) //1 bit signal maximum 2 values 0 and 1
    for (k=0; k<2; k=k+1) begin //1 bit signal maximum 2 values 0 and 1
        a=i; b=j; cin=k; #10; check;
    end

    if (errors==0) $display("ALL TEST PASSED YOU ARE AWESOME");
    else $display("FAILED: %0d errors", errors);
    $finish;
end

task check; begin
    if ((sum !== (a^b^cin)) || (carry !== ((a&b) | (b&cin) | (a&cin)))) begin  //if ({carry, sum} !== (a + b + cin)) shortcut for checking sum and carry
        $display("FAILED: a=%b b=%b cin=%b sum=%b carry=%b", a,b,cin,sum,carry);
        errors = errors + 1;
    end
end
endtask
endmodule


