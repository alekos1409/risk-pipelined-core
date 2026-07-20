module keypad_capture(
    clk,
    reset,
    switch1,
    switch2,
    switch3,
    operand_A,
    operand_B,
    dec,
    compute_trigger 
    );
input clk,reset,switch1,switch2,switch3;
input [3:0]dec;
output reg [15:0]operand_A,operand_B;
output reg  compute_trigger ;
reg switch1_sync,switch2_sync,switch3_sync;
reg switch3_prev;
always @(posedge clk) begin
switch3_prev <= switch3_sync;
switch1_sync <= switch1;
switch2_sync <= switch2;
switch3_sync <= switch3;
end
always @(posedge clk)begin
    compute_trigger <= 0;
    if(reset)begin
        operand_A <= 0;
        operand_B <= 0;
         compute_trigger  <= 0;
    end else begin
    if(switch1_sync)begin
        operand_A <= {11'b0,dec};
    end
    if(switch2_sync)begin
        operand_B <= {11'b0,dec};
    end
    if(switch3_sync & ~switch3_prev)begin
        compute_trigger <=1;
    end
    end
end
endmodule