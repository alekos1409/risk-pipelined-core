`include "src/instr_mem.v"
module fetch(clk,PCSrcE,PCplus4D,PCTargetE,InstrD,PCD,reset,stallF,flushD);
input clk,PCSrcE,reset,stallF,flushD;
input [31:0]PCTargetE;
output reg [31:0]InstrD,PCD,PCplus4D;
wire [31:0]PCF_next,PCPlus4F,instruction;
reg [31:0]PCF;
assign PCF_next = PCSrcE ? PCTargetE : PCPlus4F;
assign PCPlus4F = PCF +4;
instr_mem instr_mem(
.addr(PCF),
.instruction(instruction)
);
always @(posedge clk)begin
    if(reset)begin
        PCF <= 0;
         InstrD<= 0;
    PCD<=0;
    PCplus4D<= 0;
    end
    else if (flushD)begin
            PCF <= PCF_next;
         InstrD<= 0;
    PCD<=0;
    PCplus4D<= 0;
    end
    else if(stallF) begin
    PCF<= PCF;
    InstrD<= InstrD;
    PCD<=PCD;
    PCplus4D<=PCplus4D;
    end
    else begin
    PCF<= PCF_next;
    InstrD<= instruction;
    PCD<=PCF;
    PCplus4D<=PCPlus4F;
    end
end

endmodule