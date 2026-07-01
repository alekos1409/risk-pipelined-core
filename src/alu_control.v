module alu_control(instruction,ALUOp,ALUcontrol,func7);
input [31:0]instruction;
input [1:0]ALUOp;
wire [2:0]func3;
output  reg [2:0]ALUcontrol;
wire funct7_5;
assign funct7_5 = instruction[30];
assign func3 = instruction[14:12];
always @(*)begin
    ALUcontrol = 3'b000;
  case(ALUOp)
2'b00:begin ALUcontrol = 3'b000;end
2'b01:begin ALUcontrol = 3'b001;end
2'b10:begin if(func3 == 3'b000)
case(func7_5)
1'b0:ALUcontrol = 3'b000;
1'b1:ALUcontrol = 3'b001;
endcase
else
case(func3)
3'b110:ALUcontrol = 3'b011;
3'b111:ALUcontrol = 3'b010;
3'b010:ALUcontrol = 3'b101;
endcase
end
  endcase
    end

endmodule
