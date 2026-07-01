module data_memory_test();
reg [31:0]address,data_in;
reg we,clk;
wire [31:0]data_out;
data_memory uur(
.address(address),
.data_in(data_in),
.data_out(data_out),
.clk(clk),
.we(we)
);
initial begin
    data_in = 32'h12345678;
    address = 32'h0;
    we =1 ;
    #1;
    clk = 1'b1;
    #1;
    clk = 1'b0;
    #1;
   we = 0; 
#1;     
$display("data_out = %h", data_out); 
$finish;
end
endmodule