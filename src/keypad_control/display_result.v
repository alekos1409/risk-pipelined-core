module display_result (
    clk,
    reset,
    MemWriteM_display,
    data_display,
    display_r
);
  input clk, reset, MemWriteM_display;
  input [15:0] data_display;
  output reg [15:0] display_r;
  always @(posedge clk) begin
    if (reset) begin
      display_r <= 0;
    end else begin
      if (MemWriteM_display) begin
        display_r <= data_display;
      end
    end
  end
endmodule
