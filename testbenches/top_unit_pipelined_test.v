module top_unit_pipelined_test();
reg reset,clk;
wire tx,byte_valid;
wire [7:0]received_byte;

top_unit_pipelined uut1(
    .reset(reset),
    .clk(clk),
    .tx(tx)
);
UART_rx uut2(
.clk(clk),
.reset(reset),
.tx(tx),
.received_byte(received_byte),
.byte_valid(byte_valid)
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
always @(posedge clk) begin
    if (byte_valid)
        $write("%c", received_byte);
end
initial begin
    reset<=1'b1;
    #40;
    reset<=1'b0;
    #8000;
    $finish;
end
endmodule