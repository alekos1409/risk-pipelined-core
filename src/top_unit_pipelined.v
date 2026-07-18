//Ενώνει όλα τα κομμάτια για να φτιαχτεί το pipeline
`include "src/fetch.v"
`include "src/decode.v"
`include "src/execute.v"
`include "src/memory_access.v"
`include "src/write_back.v"
`include "src/hazard_forwarding_unit.v"
`include "src/hazard_control_unit.v"
module top_unit_pipelined (
    clk,
    reset,
    tx,
    rx
);
  input clk, reset, rx;
  output tx;
  wire [1:0] ALUOpE, ForwardAE, ForwardBE;
  wire [2:0] ALUcontrolE;
  wire PCSrcE,RegWriteW,RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,
MemReadE,MemToRegE,carry,negative,overflow,RegWriteM,
MemWriteM,MemToRegM,MemToRegW,zero,flushE,stallF,flushD,stallD,mulD,mulE,mul_busy,done,MemReadM;
  wire [4:0] RdW, RdE, RdM, Rs1E, Rs2E, Rs1D, Rs2D;
  wire [31:0]PCTargetE,InstrD,PCD,PCplus4D,
ResultW,PCE,PCplus4E,RD1E,RD2E,Imm_outE,ALuResultM,WriteDataM,
PCplus4M,slt,PCplus4W,ALuResultW,ReadDataW,SrcAE,SrcBE;
wire [63:0] Result_M;
  fetch fetch (
      .clk(clk),
      .reset(reset),
      .PCSrcE(PCSrcE),
      .PCTargetE(PCTargetE),
      .InstrD(InstrD),
      .PCD(PCD),
      .PCplus4D(PCplus4D),
      .stallF(stallF),
      .flushD(flushD)
  );
  decode decode (
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
      .Rs2E(Rs2E),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .flushE(flushE),
      .mulE(mulE),
      .mul_busy(mul_busy)
  );
  execute execute (
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
      .MemToRegM(MemToRegM),
      .SrcAE(SrcAE),
      .SrcBE(SrcBE),
      .mulE(mulE),
      .Result_M(Result_M),
      .mul_busy(mul_busy),
      .done(done),
      .MemReadM(MemReadM)
  );
  memory_access memory_access (
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
      .RdW(RdW),
      .tx(tx),
      .MemReadM(MemReadM),
      .rx(rx)
  );
  write_back write_back (
      .MemToRegW(MemToRegW),
      .ResultW(ResultW),
      .ReadDataW(ReadDataW),
      .ALuResultW(ALuResultW)
  );
  hazard_forwarding_unit hazard_unit (
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
  hazard_control_unit hazard_control_unit (
      .RdE(RdE),
      .flushD(flushD),
      .flushE(flushE),
      .stallD(stallD),
      .stallF(stallF),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .MemReadE(MemReadE),
      .PCSrcE(PCSrcE),
      .mul_busy(mul_busy)
  );
endmodule
