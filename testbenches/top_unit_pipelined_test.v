module top_unit_pipelined_test();
reg reset,clk;

top_unit_pipelined uut(
    .reset(reset),
    .clk(clk)
);
initial begin
    $dumpfile("top_unit_pipelined.vcd");
    $dumpvars(0,top_unit_pipelined_test);
    clk=0;
end
always
begin clk = ~clk;
#5;
end 
initial begin
    reset<=1'b1;
    #40;
    reset<=1'b0;
    #400;
    $finish;
end
endmodule