//Ενώνει όλα τα κομμάτια για να φτιαχτεί το pipeline,UART
`include "src/pipeline/fetch.v"
`include "src/pipeline/decode.v"
`include "src/pipeline/execute.v"
`include "src/pipeline/memory_access.v"
`include "src/pipeline/write_back.v"
`include "src/hazard/hazard_forwarding_unit.v"
`include "src/hazard/hazard_control_unit.v"
`include "src/keypad_control/decoder_keypad.v"
`include "src/keypad_control/seg7_display.v"
`include "src/keypad_control/keypad_capture.v"
`include "src/keypad_control/digit_select.v"
module top_unit_pipelined (
    clk,
    reset,
    tx,
    rx,
    col,
    row,
    an,
    seg,
    switch1,
    switch2,
    switch3
);
  input clk, reset, rx, switch1, switch2,switch3;
  input [3:0]row;
  output tx;
  output [3:0] col;
  output [7:0] an;
  output [6:0]seg;
  wire [15:0]display_r;
  wire [7:0]operand_A,operand_B;
  wire [7:0] wire_number;
  wire [3:0] wire_dec;
  wire [1:0] ALUOpE, ForwardAE, ForwardBE;
  wire [2:0] ALUcontrolE; 
  wire [3:0]dec_out;
  wire  decode_valid;
  wire PCSrcE,RegWriteW,RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,
MemReadE,MemToRegE,carry,negative,overflow,RegWriteM,
MemWriteM,MemToRegM,MemToRegW,zero,flushE,stallF,flushD,stallD,mulD,mulE,
mul_busy,done,MemReadM,compute_trigger,trigger_clear;
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
      .rx(rx),
      .display_r(display_r),
      .operand_A(operand_A),
      .operand_B(operand_B),
      .compute_trigger(compute_trigger),
      .trigger_clear(trigger_clear)
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
  decoder_keypad decoder_keypad(
        .clk(clk),
        .row(row),
        .col(col),
        .dec_out(wire_dec),
        .decode_valid(decode_valid)
    );
  seg7_display seg7_display(
       .clk(clk),
      .number(wire_number),
      .seg(seg),
      .an(an)
  );
  keypad_capture keypad_capture(
    .clk(clk),
    .number(wire_number),
    .operant_A(operant_A),
    .operant_B(operant_B),
    .switch2(switch2),
    .switch3(switch3)
  );
 digit_select digit_select(
.clk(clk),
.switch1(switch1),
.switch2(switch2),
.number(wire_number),
.dec(wire_dec),
.decode_valid(decode_valid)
);
endmodule
