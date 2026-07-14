module mul_test();
reg [31:0]a,b;
reg clk,reset,start;
wire done;
wire [63:0]Result;
mul mul(
.a(a),
.b(b),
.clk(clk),
.reset(reset),
.done(done),
.Result(Result),
.start(start)
);
initial clk = 0;
always #5 clk = ~clk;
initial begin
    a=0;
    b=0;
      start = 0;
       reset = 0;
     @(posedge clk);
    reset = 0;
    a=22;
    b=3;
     start = 0;
       @(posedge clk);
    start = 1;
       wait(done);  
    $display("Result = %d",Result);
     
    $finish;
end
endmodule