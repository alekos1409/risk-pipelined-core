`include "src/keypad_control/seg7_control.v"
module seg7_display(clk,result,an,seg);
input clk;
input [15:0]result;
output reg [3:0]an;
output [6:0]seg;
reg [1:0]digit_select = 0;
wire [3:0]current_nibble;
reg [19:0] scan_timer = 0;
assign current_nibble = (digit_select == 2'b00) ? result[3:0]:
                        (digit_select == 2'b01) ? result[7:4]:
                        (digit_select == 2'b10) ? result[11:8]:
                         result[15:12];
always @(posedge clk)begin
    if(scan_timer == 50_000) begin
        scan_timer <= 0;
        digit_select <= digit_select + 1;
    end else begin
        scan_timer <= scan_timer + 1;
    end
    case(digit_select)
    2'b00: an <= 4'b1110;
    2'b01: an <= 4'b1101;
    2'b10: an <= 4'b1011;
    2'b11: an <= 4'b0111;    
    endcase
end
seg7_contol seg7_contol(
    .dec(current_nibble),
    .seg(seg)
);
endmodule