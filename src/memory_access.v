`include "src/data_memory.v"
module memory_access(ALuResultM,WriteDataM,PCplus4M,RdM,
MemWriteM,MemToRegM,clk,ReadDataW,PCplus4W,ALuResultW,
 RdW,reset,RegWriteM,MemToRegW,RegWriteW);
input [31:0]ALuResultM,WriteDataM,PCplus4M ;
input[4:0]RdM;
input clk,reset;
input MemWriteM,MemToRegM,RegWriteM;
output reg RegWriteW,MemToRegW;
output reg [31:0]ReadDataW,PCplus4W,ALuResultW;
output reg [4:0] RdW;
wire [31:0]ReadDataM;

data_memory data_memory(
.clk(clk),
.we(MemWriteM),
.address(ALuResultM),
.data_in(WriteDataM),
.data_out(ReadDataM)
);
always @ (posedge clk) begin
if(reset)
begin
ReadDataW <= 0;
RdW <= 0;
PCplus4W <= 0;
ALuResultW <= 0 ;
RegWriteW <=  0;
 MemToRegW <=  0;
end
else begin
    ReadDataW <= ReadDataM;
RdW <= RdM;
PCplus4W <= PCplus4M;
ALuResultW <= ALuResultM;
 RegWriteW <=  RegWriteM;
MemToRegW <=  MemToRegM;
end
end
endmodule