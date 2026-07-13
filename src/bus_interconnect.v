module bus_interconnect (
    address,
    data_in,
    MemWriteM,
    data_data_memory,
    data_UART,
    address_data_memory,
    address_UART,
    MemWriteM_data_memory,
    MemWriteM_UART,
    ReadDataM,
    data_out,
    UART_busy
);
  input [31:0] address;
  input [31:0] data_in, data_out;
  input MemWriteM, UART_busy;
  output reg [31:0] data_data_memory, data_UART;
  output reg [31:0] address_data_memory, address_UART, ReadDataM;
  output reg MemWriteM_data_memory, MemWriteM_UART;
  always @(*) begin
    address_data_memory = 0;
    data_data_memory = 0;
    MemWriteM_data_memory = 0;
    address_UART = 0;
    data_UART = 0;
    MemWriteM_UART = 0;
    ReadDataM = 0;
    if (address == 32'h80000004) begin
      ReadDataM = {31'b0, UART_busy};
    end else if (address[31] == 0) begin
      address_data_memory = address;
      data_data_memory = data_in;
      MemWriteM_data_memory = MemWriteM;
      ReadDataM = data_out;
    end else begin
      address_UART = address;
      data_UART = data_in;
      MemWriteM_UART = MemWriteM;
    end
  end
endmodule
