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
    rx_data_read,
    rx_full,
    UART_rx_byte,
    data_display,//χρησιμοποιήται για τα data απο το keypad προς την οθονη της FPGA
    MemWriteM_display,//γραφει τα δεδομενα από το keypad
    operand_A,
    operand_B,
    compute_trigger
);
  input [31:0] address;
  input [31:0] data_in, data_out,UART_rx_byte ;
  input [15:0]operand_A,operand_B;
  input MemWriteM, UART_busy,MemReadM,rx_full,compute_trigger;
  output reg[15:0]data_display;
  output reg [31:0] data_data_memory, data_UART;
  output reg [31:0] address_data_memory, address_UART, ReadDataMem;
  output reg MemWriteM_data_memory, MemWriteM_UART,rx_data_read, MemWriteM_display;
  always @(*) begin
    address_data_memory = 0;
    data_data_memory = 0;
    MemWriteM_data_memory = 0;
    address_UART = 0;
    data_UART = 0;
    MemWriteM_UART = 0;
    ReadDataMem = 0;
    rx_data_read = 0;
    data_display = 0;
    MemWriteM_display = 0;
    if (address == 32'h80000004) // UART busy status register
    begin
      ReadDataMem = {31'b0, UART_busy};
    end
      else if(address == 32'h80000008)begin //ενημερώνει το status register του UART_rx_mmio για να δείξει αν υπάρχει byte προς ανάγνωση
      ReadDataMem = {31'b0, rx_full};
    end
    else if(address == 32'h8000000c && MemReadM == 1)begin // λαμβάνει το byte από το UART_rx_mmio και το φορτώνει στο ReadDataMem
        ReadDataMem = UART_rx_byte;
        rx_data_read = 1;
    end else if (address[31] == 0) begin
      address_data_memory = address;
      data_data_memory = data_in;
      MemWriteM_data_memory = MemWriteM;
      ReadDataMem = data_out;
    end 
    else if(address == 32'h80000010)begin//βγάζει στην οθόνη τις πραξεις του keypad
      data_display = data_in;
      MemWriteM_display = MemWriteM;
    end
    else if(address == 32'h80000014)begin
     ReadDataMem  = {16'b0, operand_A};
    end
    else if(address == 32'h80000018)begin
     ReadDataMem = {16'b0,operand_B};
    end
    else if(address == 32'h8000001c)begin
     ReadDataMem = {31'b0, compute_trigger};
    end
      else begin
      address_UART = address;
      data_UART = data_in;
      MemWriteM_UART = MemWriteM;
    end
  
  end
  
endmodule
