`include "src/data_memory.v"
`include "src/bus_interconnect.v"
`include "src/UART_tx.v"
module memory_access (
    ALuResultM,
    WriteDataM,
    PCplus4M,
    RdM,
    MemWriteM,
    MemToRegM,
    clk,
    ReadDataW,
    PCplus4W,
    ALuResultW,
    RdW,
    reset,
    RegWriteM,
    MemToRegW,
    RegWriteW,
    tx
);
  input [31:0] ALuResultM, WriteDataM, PCplus4M;
  input [4:0] RdM;
  input clk, reset;
  input MemWriteM, MemToRegM, RegWriteM;
  output tx;
  output reg RegWriteW, MemToRegW;
  output reg [31:0] ReadDataW, PCplus4W, ALuResultW;
  output reg [4:0] RdW;
  wire [31:0]ReadDataM_in,address_data_memory,data_data_memory,address_UART,
data_UART,data_out,ReadDataM_out;
  wire MemWriteM_data_memory, MemWriteM_UART, UART_busy;
  data_memory data_memory (
      .clk(clk),
      .we(MemWriteM_data_memory),
      .address(address_data_memory),
      .data_in(data_data_memory),
      .data_out(ReadDataM_in)
  );
  bus_interconnect bus_interconnect (
      .address(ALuResultM),
      .data_in(WriteDataM),
      .MemWriteM(MemWriteM),
      .data_data_memory(data_data_memory),
      .address_data_memory(address_data_memory),
      .MemWriteM_data_memory(MemWriteM_data_memory),
      .data_UART(data_UART),
      .address_UART(address_UART),
      .MemWriteM_UART(MemWriteM_UART),
      .UART_busy(UART_busy),
      .ReadDataM(ReadDataM_out),
      .data_out(ReadDataM_in)
  );
  UART_tx UART_tx (
      .clk(clk),
      .MemWriteM_UART(MemWriteM_UART),
      .reset(reset),
      .data_in(data_UART[7:0]),
      .tx(tx),
      .busy(UART_busy)
  );
  always @(posedge clk) begin
    if (reset) begin
      ReadDataW <= 0;
      RdW <= 0;
      PCplus4W <= 0;
      ALuResultW <= 0;
      RegWriteW <= 0;
      MemToRegW <= 0;
    end else begin
      ReadDataW <= ReadDataM_out;
      RdW <= RdM;
      PCplus4W <= PCplus4M;
      ALuResultW <= ALuResultM;
      RegWriteW <= RegWriteM;
      MemToRegW <= MemToRegM;
    end
  end
endmodule
