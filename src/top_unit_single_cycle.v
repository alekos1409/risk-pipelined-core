`include "src/instr_mem.v"
`include "src/imm_gen.v"
`include "src/register_file.v"
`include "src/data_memory.v"
`include "src/alu.v"
`include "src/control_unit.v"
`include "src/alu_control.v"
module top_unit_cycle(clk,reset);
input clk;
input reset;
reg [31:0] pc;
wire [31:0]rd_data,rs2_data,rs1_data,imm_out,result,data_out,pc_next,alu_b,instruction,slt;
wire zero,ALUSrc,MemToReg,MemWrite,MemRead,Branch,Jump,RegWrite;
wire [1:0]ALUOp;
wire [2:0]ALUcontrol;
assign alu_b = ALUSrc ? imm_out :rs2_data;
assign rd_data = MemToReg ? data_out : result;
assign pc_next = Jump ? pc+imm_out : 
(Branch & zero) ? pc + imm_out:
pc + 4;
always @(posedge clk) begin
    if(reset)
    pc<= 32'b0;
    else
    pc<= pc_next;
end
instr_mem instr_mem(
    .addr(pc),
    .instruction(instruction)
);
imm_gen imm_gen(
    .instruction(instruction),
    .imm_out(imm_out)
);
register_file register_file(
    .we(RegWrite),
    .clk(clk),
    .rd_addr(instruction[11:7]),
    .rs1_addr(instruction[19:15]),
    .rs2_addr(instruction[24:20]),
    .rd_data(rd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);
data_memory data_memory(
.clk(clk),
.we(MemWrite),
.data_in(result),
.data_out(data_out),
.address(result)
);
alu alu(
.a(rs1_data),
.b(alu_b),
.result(result),
.slt(slt),
.ALUcontrol(ALUcontrol),
.zero(zero)
);
control_unit control_unit(
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
alu_control alu_control(
    .instruction(instruction),
    .ALUOp(ALUOp),
    .ALUcontrol(ALUcontrol)
);
endmodule