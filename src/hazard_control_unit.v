module hazard_control_unit (
    PCSrcE,
    RdE,
    Rs1D,
    Rs2D,
    MemReadE,
    flushD,//delete the data at decode 
    flushE,
    stallD,//freeze the data at decode
    stallF,
    mul_busy//freeze the data to do the mul(32clocks)
);
  input PCSrcE, MemReadE, mul_busy;
  input [4:0] Rs1D, Rs2D, RdE;
  output flushD, flushE, stallD, stallF;
  reg LoadUseHazard;
  always @(*) begin
    if (MemReadE) begin
      if ((RdE == Rs1D | RdE == Rs2D) & RdE != 0) begin
        LoadUseHazard = 1'b1;
      end else LoadUseHazard = 1'b0;
    end else LoadUseHazard = 1'b0;
  end
  assign flushD = PCSrcE;
  assign flushE = PCSrcE | LoadUseHazard;
  assign stallD = LoadUseHazard | mul_busy;
  assign stallF = LoadUseHazard | mul_busy;
endmodule
