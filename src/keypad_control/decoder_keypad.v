module decoder_keypad(clk,reset,row,col,dec_out,decode_valid);
input clk,reset;
    input [3:0] row;
     output reg [3:0] col;
    output reg [3:0] dec_out;
    output reg decode_valid;
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
    if(reset)begin
        dec_out <=4'hF;
        decode_valid <=0;
    end
        else begin
    case(col_select)
    2'b00: begin    
                col <= 4'b0111;
                            if(scan_timer ==lag)begin
                                case(row)
                                    4'b0111:begin dec_out <= 4'b0001; decode_valid <=1; end//1
                                    4'b1011:begin dec_out <= 4'b0100;decode_valid <=1;end//4
                                    4'b1101:begin dec_out <= 4'b0111;decode_valid <=1;end//7
                                    4'b1110:begin dec_out <= 4'b0000;decode_valid <=1;end//0
                                endcase
                            end
            end
    2'b01: begin
                col <= 4'b1011;
                            if(scan_timer==lag)begin
                                case(row)
                                    4'b0111:begin dec_out <= 4'b0010;decode_valid <=1;end//2
                                    4'b1011:begin dec_out <= 4'b0101;decode_valid <=1;end//5
                                    4'b1101:begin dec_out <= 4'b1000;decode_valid <=1;end//8
                                    4'b1110:begin dec_out <= 4'b1111;decode_valid <=1;end//F
                                endcase
                            end
            end                 
    2'b10: begin
                col <= 4'b1101;
                            if(scan_timer == lag)begin
                                case(row)
                                    4'b0111:begin dec_out <= 4'b0011;decode_valid <=1;end//3
                                    4'b1011:begin dec_out <= 4'b0110;decode_valid <=1;end//6
                                    4'b1101:begin dec_out <= 4'b1001;decode_valid <=1;end//9
                                    4'b1110:begin dec_out <= 4'b1110;decode_valid <=1;end//E
                                endcase
                            end
            end
    2'b11: begin
                col <= 4'b1110;
                            if(scan_timer == lag)begin
                                case(row)
                                    4'b0111:begin dec_out <= 4'b1010;decode_valid <=1;end//A
                                    4'b1011:begin dec_out <= 4'b1011;decode_valid <=1;end//B
                                    4'b1101:begin dec_out <= 4'b1100;decode_valid <=1;end//C
                                    4'b1110: begin dec_out <= 4'b1101;decode_valid <=1;end//D
                                endcase
                            end
            end
                default :dec_out <= 0;
    endcase
        end
end
endmodule