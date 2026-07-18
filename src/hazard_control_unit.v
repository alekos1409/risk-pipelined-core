//χρησιμοποιήται γαι τις εντολές branch και jump ώστε σε περίπτωση που πηδήξει κάπου αλλού να διαγράψει τις επόμενες πληροφορίες από το pipeline
// Για τις εντολές lw ώστε να φορτώσει τις εντόλες για άμεση χρήση παγώνοντας από πίσω το pipeline και για πολλαπλασιασμό
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
