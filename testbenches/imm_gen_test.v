module imm_gen_test();
reg [31:0]instruction; 
wire [31:0]imm_out;
imm_gen uut(
.instruction(instruction),
.imm_out(imm_out)
);
initial begin
  instruction = 32'h02302000;  
  #1

 $display("imm = %b",imm_out);
 
 $finish;
end
endmodule