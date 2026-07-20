`include "src/core/data_memory.v"
`include "src/bus_interconnect.v"
`include "src/UART/UART_tx.v"
`include "src/UART/UART_rx.v"
`include "src/UART/UART_rx_mmio.v"
`include "src/keypad_control/display_result.v"
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
    tx,
    MemReadM,
    rx ,//xρησιμοποιείται για να διαβάζει τα δεδομένα από το UART_rx_mmio
    display_r,
    operand_A,
    operand_B,
    compute_trigger,
    trigger_clear
);
  input [31:0] ALuResultM, WriteDataM, PCplus4M;
  input [4:0] RdM;
  input [15:0]operand_A,operand_B;
  input clk, reset;
  input MemWriteM, MemToRegM, RegWriteM, MemReadM,compute_trigger;
  input rx;//φυσική σύνδεση με fpga
  output tx,trigger_clear;
  output [15:0]display_r;
  output reg RegWriteW, MemToRegW;
  output reg [31:0] ReadDataW, PCplus4W, ALuResultW;
  output reg [4:0] RdW;
  wire [15:0] data_display;
  wire [31:0]ReadDataMem_in,address_data_memory,data_data_memory,address_UART,
data_UART,data_out,ReadDataMem_out,UART_rx_byte;
  wire MemWriteM_data_memory, MemWriteM_UART, UART_busy,byte_valid,rx_full,
  rx_data_read,MemWriteM_display;
  wire [7:0]received_byte;
  reg rx_sync1, rx_sync2;//για να συγχρονίσει το rx με το ρολόι του επεξεργαστή
  data_memory data_memory (
      .clk(clk),
      .we(MemWriteM_data_memory),
      .address(address_data_memory),
      .data_in(data_data_memory),
      .data_out(ReadDataMem_in)
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
      .ReadDataMem(ReadDataMem_out),
      .data_out(ReadDataMem_in),
      .MemReadM(MemReadM),
      .rx_full(rx_full),
      .UART_rx_byte(UART_rx_byte),
      .rx_data_read(rx_data_read),
      .MemWriteM_display(MemWriteM_display),
      .data_display(data_display),
      .operand_A(operand_A),
      .operand_B(operand_B),
      .compute_trigger(compute_trigger),
      .trigger_clear(trigger_clear)
  );
  UART_tx UART_tx (
      .clk(clk),
      .MemWriteM_UART(MemWriteM_UART),
      .reset(reset),
      .data_in(data_UART[7:0]),
      .tx(tx),
      .busy(UART_busy)
  );
  UART_rx UART_rx (
      .clk(clk),
      .reset(reset),
      .tx(rx_sync2),
      .received_byte(received_byte),
      .byte_valid(byte_valid)
  );
  UART_rx_mmio UART_rx_mmio (
      .reset(reset),
      .clk(clk),
      .byte_valid(byte_valid),
      .rx_full(rx_full),
      .UART_rx_byte(UART_rx_byte),//η πληροφορία που έφτασε από το UART
      .received_byte(received_byte),
      .rx_data_read(rx_data_read) 
  );
  display_result display_result(
      .clk(clk),
      .reset(reset),
      .MemWriteM_display(MemWriteM_display),
      .data_display(data_display),
      .display_r(display_r)

  );
  always @(posedge clk) begin
    rx_sync1 <= rx;
    rx_sync2 <= rx_sync1;
  end
  always @(posedge clk) begin
    if (reset) begin
      ReadDataW <= 0;
      RdW <= 0;
      PCplus4W <= 0;
      ALuResultW <= 0;
      RegWriteW <= 0;
      MemToRegW <= 0;
    end else begin
      ReadDataW <= ReadDataMem_out;
      RdW <= RdM;
      PCplus4W <= PCplus4M;
      ALuResultW <= ALuResultM;
      RegWriteW <= RegWriteM;
      MemToRegW <= MemToRegM;
    end
  end
endmodule
