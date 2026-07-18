//χρησιμοποιήτε για να διαλέξει ποιά περιφεριακά θα ακούσει ή που θα γράψει. Είναι ανάμεσα στο memory access και στο data memory
module bus_interconnect (
    address,
    data_in,
    MemWriteM,
    MemReadM,
    data_data_memory,
    data_UART,
    address_data_memory,
    address_UART,
    MemWriteM_data_memory,
    MemWriteM_UART,
    ReadDataMem,//ReadDataMem = data_from_data_memory, ReadDataM = data_from_control_unit
    data_out,
    UART_busy,
    rx_data_read
);
  input [31:0] address;
  input [31:0] data_in, data_out;
  input MemWriteM, UART_busy,MemReadM;
  output reg [31:0] data_data_memory, data_UART;
  output reg [31:0] address_data_memory, address_UART, ReadDataMem;
  output reg MemWriteM_data_memory, MemWriteM_UART,rx_data_read;
  always @(*) begin
    address_data_memory = 0;
    data_data_memory = 0;
    MemWriteM_data_memory = 0;
    address_UART = 0;
    data_UART = 0;
    MemWriteM_UART = 0;
    ReadDataMem = 0;
    rx_data_read = 0;
    if (address == 32'h80000004) begin
      ReadDataMem = {31'b0, UART_busy};
    end else if (address[31] == 0) begin
      address_data_memory = address;
      data_data_memory = data_in;
      MemWriteM_data_memory = MemWriteM;
      ReadDataMem = data_out;
    end else begin
      address_UART = address;
      data_UART = data_in;
      MemWriteM_UART = MemWriteM;
    end
    if(address == 32'h80000008 && MemReadM == 1)begin
    rx_data_read = 1;
    end
  end
endmodule
