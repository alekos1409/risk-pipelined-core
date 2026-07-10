module UART_rx(clk,reset,tx,received_byte,byte_valid);
input clk,reset,tx;
parameter  idle = 2'b00, start = 2'b01 , data_out = 2'b10 , stop = 2'b11;
parameter CLKS_PER_BIT = 4;
reg [7:0] cycle_counter;
reg [1:0] state;
output reg [7:0] received_byte;
reg[2:0]bit_counter;
output reg byte_valid;
always@(posedge clk)begin
if(reset)begin
    received_byte <= 0;
    byte_valid<= 0;
    state <= idle;
    cycle_counter <= 0;
    bit_counter <= 0;
end
else begin
      byte_valid <= 0;
    case(state)
idle: begin
if(tx == 0)
 state <= start;
else
state <= idle;
end
start:begin
if (cycle_counter == CLKS_PER_BIT/2 - 1) begin
     cycle_counter <= 0;
    state <= data_out;
end
else
        cycle_counter <= cycle_counter + 1;
end

data_out: begin
received_byte[bit_counter] <= tx;
    if (cycle_counter == CLKS_PER_BIT - 1) begin
        cycle_counter <= 0;
        if (bit_counter == 3'h7)
            state <= stop;
        else
            bit_counter <= bit_counter + 1;
    end
    else
        cycle_counter <= cycle_counter + 1;
end
stop: begin
    
     if (cycle_counter == CLKS_PER_BIT - 1) begin
        cycle_counter <= 0;
        state <= idle;
        bit_counter <= 0;
        byte_valid <= 1;
       
    end
    else
        cycle_counter <= cycle_counter + 1;
end
endcase
end
end
endmodule