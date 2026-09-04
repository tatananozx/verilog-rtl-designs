module tb_half_adder;
  reg a,b;
  wire sum,carry;
  integer errors,i,j;

  half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));

  initial begin
    errors = 0;
    $dumpfile("sim/half_adder.vcd");
    $dumpvars(0,tb_half_adder);

    for (i=0; i<2; i=i+1)
    for (j=0; j<2; j=j+1) begin
        a = i; b = j; #10; check;
    end

    if (errors == 0) $display("All tests passed");
    else $display("FAILED: %0d errors", errors);
    $finish;
  end

  task check; begin
   if ((sum !== (a^b)) || (carry !== (a&b))) begin
     $display("FAILED: a=%b b=%b sum=%b carry=%b", a,b,sum,carry);
     errors = errors + 1;
   end
   end
  endtask
endmodule
