module register_file_test();
reg i;
wire o;
register_file uut(
    .i(i),
    .o(o)
);
initial begin
$dumpfile("register_file.vcd");
    $dumpvars(0,register_file_test);
    i = 1'b0;
    #7 i = 1'b1;
end
initial #30 $finish;
endmodule