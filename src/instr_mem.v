//παίρνει την διεύθυνση από το pc και βγάζει την οδηγίαß
module instr_mem (
    addr,
    instruction
);
  input [31:0] addr;
  output [31:0] instruction;
  reg [31:0] mem[1023:0];
  initial $readmemh("src/program.hex", mem);
  assign instruction = mem[addr[11:2]];
endmodule
