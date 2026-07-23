module Capture_numbes(
    clk,
    number,
    operant_A,
    operant_B,
    switch2,
    switch3
    );
    input clk,switch2,switch3;
    input [7:0]number;
    output reg [7:0] operant_A,operant_B;
    always @(posedge clk) begin
    if(switch2)begin
    operant_A <= number;
    end
    else   if(switch3)begin
    operant_B <= number;
    end
    end
    
endmodule
