module data_memory(clk,we,address,data_in,data_out);
input clk,we;
input [31:0]address,data_in;
output [31:0]data_out;
reg [31:0] regs [1023:0];
always @(posedge clk) 
if (we==1 ) begin regs[address[11:2]]<=data_in;
end
assign data_out = regs[address[11:2]];
endmodule