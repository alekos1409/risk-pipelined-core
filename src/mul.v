module mul (
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
  always @(posedge clk) begin
    if (reset) begin
      a_in <= 0;
      b_in <= 0;
      Result_in <= 0;
      count <= 32;
      done_in <= 0;
    end else begin
      case (start)
        1'b0: begin
          a_in <= a;
          b_in <= b;
          Result_in <= 0;
          count <= 32;
          done_in <= 0;
        end
        1'b1: begin
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
            done_in <= 0;
          end else begin
            done_in <= 1;
          end
        end
      endcase
    end
  end
  assign Result = Result_in;
  assign done   = done_in;
endmodule
