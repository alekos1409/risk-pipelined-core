module digit_select (
    clk,
    number,
    switch1,
    switch2,
    dec,
    decode_valid
);
  input clk, switch1, switch2, decode_valid;
  input [3:0] dec;
  reg [7:0] number_in = 0;
  output [7:0] number;
  always @(posedge clk) begin
    if (switch1 == 0 && decode_valid) begin
      number_in[3:0] <= dec;
    end else if (decode_valid) number_in[7:4] <= dec;
  end
  assign number = number_in;
endmodule
