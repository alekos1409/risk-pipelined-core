module keypad_capture(
    clk,
    reset,
    switch1,
    switch2,
    switch3,
    operand_A,
    operand_B,
    dec,
    compute_trigger,
    trigger_clear ,
    decode_valid
    );
input clk,reset,switch1,switch2,switch3,trigger_clear,decode_valid;
input [3:0]dec;
output reg [15:0]operand_A,operand_B;
output reg  compute_trigger ;
reg switch1_sync,switch2_sync,switch3_sync;
reg switch3_prev,switch2_prev,switch1_prev;
always @(posedge clk) begin
switch3_prev <= switch3_sync;
switch2_prev <= switch2_sync;
switch1_prev <= switch1_sync;
switch1_sync <= switch1;
switch2_sync <= switch2;
switch3_sync <= switch3;
end
always @(posedge clk)begin
    if(reset)begin
        operand_A <= 0;
        operand_B <= 0;
         compute_trigger  <= 0;
    end else begin
    if(switch1_sync & ~switch1_prev & decode_valid)begin
        operand_A <= {12'b0,dec};
    end
    if(switch2_sync & ~switch2_prev & decode_valid )begin
        operand_B <= {12'b0,dec};
    end
    if(switch3_sync & ~switch3_prev)begin
        compute_trigger <=1;
    end
        else if(trigger_clear)begin
        compute_trigger <=0;
    end
    end
    end
endmodule