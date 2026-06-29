module register_file_test();
reg [4:0]rs1_addr,rs2_addr,rd_addr;
wire [31:0]rs1_data,rs2_data;
reg [31:0] rd_data,x5;
reg we,clk;
reg [31:0] regs [0:31];
register_file uut(
.we(we),
.rs1_addr(rs1_addr),
.rs2_addr(rs2_addr),
.clk(clk),
.rd_addr(rd_addr),
.rs1_data(rs1_data),
.rs2_data(rs2_data),
.rd_data(rd_data)
);
initial begin
    clk =1'b0;
    we =1'b1;
       x5 = 32'h12345678;
    rd_addr = 5'b00000;
    rd_data = x5;
    
    #5 clk = 1'b1;#5 clk = 1'b0;
 rs1_addr = 5'd1;
     #1;
    $display("rd = %h,rd_addr = %h",rd_data,rd_addr);
    $display("x0_addr = %h ", rs1_addr);
    $finish ;
end



endmodule