module register_file(we,rs1_addr,rs2_addr,clk,rd_addr,rs1_data,rs2_data,rd_data);
input [4:0]rs1_addr,rs2_addr,rd_addr;
output [31:0]rs1_data,rs2_data;
reg [31:0] regs [0:31];
input clk,we;
input [31:0] rd_data;
assign rs1_data = regs[rs1_addr];
assign rs2_data = regs[rs2_addr];
integer i;
initial begin
    for (i = 0; i < 32; i = i + 1)
        regs[i] = 32'b0;
end
always @(posedge clk) begin
    if(we && rd_addr != 5'b0)begin
        regs[rd_addr]<=rd_data;
end
end
endmodule