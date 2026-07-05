module top_unit_single_cycle_test();
reg reset,clk;

top_unit_single_cycle uut(
    .reset(reset),
    .clk(clk)
);
initial begin
    $dumpfile("top_unit_single_cycle.vcd");
    $dumpvars(0,top_unit_single_cycle_test);
    clk=0;
end
always
begin clk = ~clk;
#10;
end 
initial begin
    reset<=1'b1;
    #50;
    reset<=1'b0;
    #500;
    $finish;
end
endmodule