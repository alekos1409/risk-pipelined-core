module control_unit_test();
reg [31:0]instruction;
wire RegWrite, ALUSrc, MemWrite, MemRead,MemToReg, Branch, Jump;
wire [1:0] ALUOp;
control_unit uup(
.instruction(instruction),
.RegWrite(RegWrite),
.ALUSrc(ALUSrc),
.MemWrite(MemWrite),
.MemRead(MemRead),
.MemToReg(MemToReg),
.Branch(Branch),
.Jump(Jump),
.ALUOp(ALUOp)
);
initial begin
    instruction = 31'b0;
    #1
    $display("RegWrite = %b , ALUSrc = %b , MemWrite = %b, MemToReg = %b",RegWrite,ALUSrc,MemWrite,MemToReg);
    #1
    instruction = 32'b00111010101100110100010100000011;
    #1
    $display("RegWrite = %b , ALUSrc = %b , MemWrite = %b, MemToReg = %b",RegWrite,ALUSrc,MemWrite,MemToReg);
    $finish;

end

endmodule