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
  reg start_prev; // για να φορτωσει της τιμες πριν αρχισει
  always @(posedge clk) begin
    if (reset) begin
      a_in <= 0;
      b_in <= 0;
      Result_in <= 0;
      count <= 32;
      done_in <= 0;
        start_prev <= 0;
    end else begin
        start_prev <= start;
        if (start && !start_prev) begin
          a_in <= a;
          b_in <= b;
          Result_in <= 0;
          count <= 32;
          done_in <= 0;
        end
        else begin
       if (start)
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
    end
  end
  assign Result = Result_in;
  assign done   = done_in;
endmodule
