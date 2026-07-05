`include "src/fetch.v"
`include "src/decode.v"
`include "src/execute.v"
`include "src/memory_access.v"
`include "src/write_back.v"
`include "src/hazard_unit.v"
module top_unit_pipelined(clk,reset);
input clk,reset; 
wire [1:0]ALUOpE,ForwardAE,ForwardBE;
wire [2:0]ALUcontrolE;
wire PCSrcE,RegWriteW,RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,
MemReadE,MemToRegE,carry,negative,overflow,RegWriteM,
MemWriteM,MemToRegM,MemToRegW,zero;
wire [4:0]RdW,RdE,RdM,Rs1E,Rs2E;
wire [31:0]PCTargetE,InstrD,PCD,PCplus4D,
ResultW,PCE,PCplus4E,RD1E,RD2E,Imm_outE,ALuResultM,WriteDataM,
PCplus4M,slt,PCplus4W,ALuResultW,ReadDataW,SrcAE,SrcBE;
fetch fetch(
.clk(clk),
.reset(reset),
.PCSrcE(PCSrcE),
.PCTargetE(PCTargetE),
.InstrD(InstrD),
.PCD(PCD),
 .PCplus4D(PCplus4D)
);
decode decode(
.clk(clk),
.reset(reset),
.ALUOpE(ALUOpE),
.ALUcontrolE(ALUcontrolE),
.PCE(PCE),
.RdW(RdW),
.RdE(RdE),
.RegWriteW(RegWriteW),
.RegWriteE(RegWriteE),
.MemWriteE(MemWriteE),
.JumpE(JumpE),
.BranchE(BranchE),
.ALUSrcE(ALUSrcE),
.MemReadE(MemReadE),
.MemToRegE(MemToRegE),
.PCplus4D(PCplus4D),
.PCD(PCD),
.ResultW(ResultW),
.PCplus4E(PCplus4E),
.RD1E(RD1E),
.RD2E(RD2E),
.Imm_outE(Imm_outE),
.InstrD(InstrD),
.Rs1E(Rs1E),
.Rs2E(Rs2E)
);
execute execute(
    .PCE(PCE),
    .PCplus4E(PCplus4E),
    .RD1E(SrcAE),
    .RD2E(SrcBE),
    .Imm_outE(Imm_outE),
    .RdE(RdE),
    .reset(reset),
    .clk(clk),
    .RegWriteE(RegWriteE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ALUSrcE(ALUSrcE),
    .MemReadE(MemReadE),
    .MemToRegE(MemToRegE),
    .ALUcontrolE(ALUcontrolE),
    .ALuResultM(ALuResultM),
    .WriteDataM(WriteDataM),
    .PCplus4M(PCplus4M),
    .RdM(RdM),
    .PCTargetE(PCTargetE),
    .zero(zero),
    .slt(slt),
    .PCSrcE(PCSrcE),
    .carry(carry),
    .negative(negative),
    .overflow(overflow),
    .RegWriteM(RegWriteM),
    .MemWriteM(MemWriteM),
    .MemToRegM(MemToRegM)
);
memory_access memory_access(
    .ALuResultM(ALuResultM),
    .WriteDataM(WriteDataM),
    .PCplus4M(PCplus4M),
    .RdM(RdM),
    .clk(clk),
    .reset(reset),
    .MemWriteM(MemWriteM),
    .MemToRegM(MemToRegM),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .MemToRegW(MemToRegW),
    .ReadDataW(ReadDataW),
    .PCplus4W(PCplus4W),
    .ALuResultW(ALuResultW),
    .RdW(RdW)
);
write_back write_back(
.MemToRegW(MemToRegW),
.ResultW(ResultW),
.ReadDataW(ReadDataW),
.ALuResultW(ALuResultW)
);
hazard_unit hazard_unit(
    .RdM(RdM),
    .RdW(RdW),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .ALuResultM(ALuResultM),
    .ResultW(ResultW),
    .RD1E(RD1E),
    .RD2E(RD2E),
    .SrcAE(SrcAE),
    .SrcBE(SrcBE)
    );
endmodule