module seg7_display_test(clk,number,an,seg);
input clk;
input [7:0]number;
output reg [7:0]an;
output [6:0]seg;
reg digit_selects = 0;
reg [19:0] scan_timer = 0;
wire [3:0]current_nibble ;
assign current_nibble = (digit_selects == 1'b0) ? number[3:0]:
                         number[7:4];
              
              
                      
always @(posedge clk)begin
    if(scan_timer == 50_000) begin
        scan_timer <= 0;
        digit_selects <= digit_selects + 1;
    end else begin
        scan_timer <= scan_timer + 1;
    end
    case(digit_selects)
    1'b0: an <=8'b11111110;
    1'b1: an <= 8'b11111101;  
    endcase
end
seg7_control_test seg7_control_test(
    .seg(current_nibble),
    .seg(seg)
);
endmodule