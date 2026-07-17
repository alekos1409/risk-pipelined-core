`include "src/alu.v"
`include "src/mul_2.v"
module execute (
    RD1E,
    RD2E,
    RegWriteE,
    MemReadE,
    MemWriteE,
    MemToRegE,
    ALUSrcE,
    ALUcontrolE,
    PCE,
    PCplus4E,
    Imm_outE,
    RdE,
    JumpE,
    BranchE,
    ALuResultM,
    WriteDataM,
    PCTargetE,
    slt,
    carry,
    negative,
    overflow,
    RdM,
    RegWriteM,
    MemWriteM,
    MemToRegM,
    PCplus4M,
    clk,
    PCSrcE,
    reset,
    zero,
    SrcAE,
    SrcBE,
    done,
    Result_M,
    mulE,
    mul_busy,
    MemReadM
);
  input [31:0] PCE, PCplus4E, RD1E, RD2E, Imm_outE, SrcAE, SrcBE;
  input [4:0] RdE;
  input reset, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, MemReadE, MemToRegE,mulE;
  input clk;
  input [2:0] ALUcontrolE;
  output reg [31:0] ALuResultM, WriteDataM, PCplus4M;
  output [63:0] Result_M;
  output reg [4:0] RdM;
  output [31:0] PCTargetE, slt;
  output PCSrcE, carry, negative, overflow, zero,done,mul_busy,MemReadM;
  output reg RegWriteM, MemWriteM, MemToRegM;
  wire [31:0] WriteDataE, Src1E, Src2E, ALuResultE_A;
  wire [31:0] ALuResultE;
  assign PCTargetE = PCE + Imm_outE;
  assign Src2E = ALUSrcE ? Imm_outE : SrcBE;
  assign WriteDataE = SrcBE;
  assign PCSrcE = (zero & BranchE) | JumpE;
  assign ALuResultE = (mulE==1 & done!=0) ? Result_M[31:0]: ALuResultE_A;
  assign mul_busy = mulE & ~done;

  alu alu (
      .a(SrcAE),
      .b(Src2E),
      .ALUcontrol(ALUcontrolE),
      .result(ALuResultE_A),
      .zero(zero),
      .slt(slt),
      .negative(negative),
      .carry(carry),
      .overflow(overflow)
  );
  mul_2 mul_2(
    .clk(clk),
    .reset(reset),
    .a(SrcAE),
    .b(Src2E),
    .done(done),
    .start(mulE),
    .Result(Result_M)
  );
  always @(posedge clk) begin
    if (reset) begin
      ALuResultM <= 0;
      WriteDataM <= 0;
      RdM <= 0;
      PCplus4M <= 0;
      RegWriteM <= 0;
      MemWriteM <= 0;
      MemToRegM <= 0;
      MemReadM <= 0;
    end else begin
      if(!mul_busy)begin
      ALuResultM <= ALuResultE;
      WriteDataM <= WriteDataE;
      RdM <= RdE;
      PCplus4M <= PCplus4E;
      RegWriteM <= RegWriteE;
      MemWriteM <= MemWriteE;
      MemToRegM <= MemToRegE;
      MemReadM <= MemReadE;
      end
    end
  end
endmodule
