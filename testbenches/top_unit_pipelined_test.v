module top_unit_pipelined_test();
reg reset,clk;
reg [3:0]row;
reg switch1,switch2,switch3;
wire tx,byte_valid;
wire [7:0]received_byte;

top_unit_pipelined uut1(
    .reset(reset),
    .clk(clk),
    .tx(tx),
    .row(row),
    .switch1(switch1),
    .switch2(switch2),
    .switch3(switch3)
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
     reset = 1'b1;
    row = 4'b1111;
    switch1 = 0;
    switch2 = 0;
    switch3 = 0;
    reset<=1'b1;
    #40;
    reset<=1'b0;
    row <= 4'b1011; 
    #100
    switch1 <= 1;
    #100
    row <= 4'b1101;
    #100
    switch2 <= 1;
    #2 switch3 <=1;
    #600_000;
    $finish;
end
endmodule