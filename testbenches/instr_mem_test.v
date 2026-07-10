module instr_mem_test();
reg [31:0]addr;
wire [31:0]instruction;
instr_mem uut(
 .addr(addr),
 .instruction(instruction)
    
);
initial begin 
    addr = 32'h00000000;
    #1;
    $display("instruction = %b", instruction);
    
    addr = 32'h00000004;
    #1;
    $display("instruction = %b", instruction);
    
    addr = 32'h00000008;
    #1;
    $display("instruction = %b", instruction);
    
    addr = 32'h0000001C;  
    #1;
    $display("instruction = %b", instruction);
    
    $finish;

end

endmodule