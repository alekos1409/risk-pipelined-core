//χρησιμοποιήται για την πράξει του πολλαπλασιασμού για unsigned αριθμούς
module mul_2 (
    clk,
    reset,
    start,
    Result,
    a,
    b,
    done
);
  input clk, reset, start;
  input [31:0] a, b;
  output done;
  output [63:0] Result;
  reg [63:0] Result_in;
  reg [63:0] a_in, b_in;
  reg [5:0] count = 32;
  reg done_in;
  reg start_prev;
  parameter idle = 2'b00, start_p = 2'b01, done_p = 2'b10;
  reg [1:0] state = idle;
  always @(posedge clk) begin
    start_prev <= start;
    if (reset) begin
      a_in <= 0;
      b_in <= 0;
      Result_in <= 0;
      count <= 32;
      done_in <= 0;
      state <= idle;
      start_prev <= 0;
    end else begin
      case (state)
        idle: begin

          a_in <= a;
          b_in <= b;
          Result_in <= 0;
          count <= 32;
          done_in <= 0;
          if (start && !start_prev) begin
            state <= start_p;

          end
        end
        start_p: begin
          if (count != 6'b0) begin
            if (b_in[0] == 1'b1) begin
              Result_in <= Result_in + a_in;
              b_in <= b_in >> 1;
              a_in <= a_in << 1;
              count <= count - 1;
            end else begin
              b_in  <= b_in >> 1;
              a_in  <= a_in << 1;
              count <= count - 1;
            end
          end
          if (count == 6'b0) begin
            done_in <= 0;
            state   <= done_p;
          end
        end
        done_p: begin
          done_in <= 1;
          state   <= idle;
        end
      endcase
    end
  end
  assign Result = Result_in;
  assign done   = done_in;
endmodule
