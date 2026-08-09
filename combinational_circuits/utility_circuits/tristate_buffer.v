module tristate_buffer(
    input wire D,
    input wire EN,
    output wire Y
);                              //synthesizable indusrty standard tristate buffer

assign Y = EN ? D : 1'bz;
endmodule


module tristate_buffer_bufif1(
    input d,en,
    output y
);
   bufif1 (y,d,en);  //bufif1 is a built-in gate level primitive in verilog for tristate buffer)
endmodule 


module tristate_buffer_bufif0(
    input d,en,
    output y
);
   bufif0(y,d,en);  //y=d when en=0, else Z
endmodule 