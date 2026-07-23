module top(clk,row,col,an,seg,switch1,switch2,switch3,operant_A,operant_B);
input clk,switch1,switch2,switch3;
input [3:0]row;
output [3:0]col;
output [6:0]seg;
output [7:0]operant_A,operant_B;
output [7:0] an;
wire [7:0] wire_number;
wire [3:0] wire_dec;
wire  decode_valid;

decoder decoder(
.clk(clk),
.row(row),
.col(col),
.dec_out(wire_dec),
.decode_valid(decode_valid)
);
seg7_display seg7_display(
.clk(clk),
.number(wire_number),
.seg(seg),
.an(an)
);
digit_select digit_select(
.clk(clk),
.switch1(switch1),
.switch2(switch2),
.number(wire_number),
.dec(wire_dec),
.decode_valid(decode_valid)
);
Capture_numbes Capture_numbes(
.clk(clk),
.number(wire_number),
.operant_A(operant_A),
.operant_B(operant_B),
.switch2(switch2),
.switch3(switch3)
);
endmodule
