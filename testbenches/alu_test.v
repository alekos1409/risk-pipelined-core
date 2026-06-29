`timescale 1ns/1ps
module alu_test;
reg [31:0]a,b;
reg[2:0]ALUcontrol;
wire [31:0]result;

 
 alu  uut(
    .ALUcontrol(ALUcontrol),
 .a(a),
.b(b),
.result(result),
.carry(carry),
.zero(zero),
.negative(negative),
.overflow(overflow),
.slt(slt)
 );
initial begin

    a=31'h00000011;
    b = 31'h00000054;
    ALUcontrol = 3'b000;
    #1;
    $display("result = %h",result);$stop;
end
endmodule
