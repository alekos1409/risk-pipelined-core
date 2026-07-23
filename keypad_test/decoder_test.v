module decoder_test(clk,row,col,dec_out, decode_valid);
input clk;
    input [3:0] row;
     output reg [3:0] col;
     output reg  decode_valid;
    output reg [3:0] dec_out;
    parameter lag = 10;
    reg [19:0] scan_timer = 0;
    reg [1:0] col_select = 0;
always @(posedge clk) begin
    if(scan_timer == 99_999) begin
        scan_timer <= 0;
        col_select <= col_select + 1;
    end else begin
        scan_timer <= scan_timer + 1;
    end
end

always @(posedge clk) begin
 decode_valid <= 0; 
    case(col_select)
    2'b00: begin    
                col <= 4'b0111;
                             

                            if(scan_timer ==lag)begin
                             if(row != 4'b1111 ) begin
                     decode_valid <= 1;
                                case(row)
                                    4'b0111:dec_out <= 4'b0001;//1
                                    4'b1011: dec_out <= 4'b0100;//4
                                    4'b1101: dec_out <= 4'b0111;//7
                                    4'b1110: dec_out <= 4'b0000;//0
                              default: decode_valid <= 0;   
                                endcase
                            end
            end
            end
    2'b01: begin
                col <= 4'b1011;
                            if(scan_timer==lag)begin
                              if(row != 4'b1111 ) begin
                decode_valid <= 1;

                                case(row)
                                    4'b0111: dec_out <= 4'b0010;//2
                                    4'b1011: dec_out <= 4'b0101;//5
                                    4'b1101: dec_out <= 4'b1000;//8
                                    4'b1110: dec_out <= 4'b1111;//F
                                    default: decode_valid <= 0;   
                                endcase
                            end
            end               
            end  
    2'b10: begin
                col <= 4'b1101;
                            if(scan_timer == lag)begin
                             if(row != 4'b1111 ) begin
                decode_valid <= 1;
                                case(row)
                                    4'b0111: dec_out <= 4'b0011;//3
                                    4'b1011: dec_out <= 4'b0110;//6
                                    4'b1101: dec_out <= 4'b1001;//9
                                    4'b1110: dec_out <= 4'b1110;//E
                                  default: decode_valid <= 0;   
                                endcase
                            end
            end
            end
    2'b11: begin
                col <= 4'b1110;
                            if(scan_timer == lag)begin
                             if(row != 4'b1111 ) begin
                decode_valid <= 1;
                                case(row)
                                    4'b0111: dec_out <= 4'b1010;//A
                                    4'b1011: dec_out <= 4'b1011;//B
                                    4'b1101: dec_out <= 4'b1100;//C
                                    4'b1110: dec_out <= 4'b1101;//D
                                 default: decode_valid <= 0;   
                                endcase
                            end
            end
            end
            endcase
            end

endmodule