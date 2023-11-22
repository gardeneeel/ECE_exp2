`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/18 22:56:39
// Design Name: 
// Module Name: LCD_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LCD_controller(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, bin);

input clk, rst;
input [7:0] bin;

wire [11:0] bcd;

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

wire LCD_E;
reg LCD_RS, LCD_RW;

reg [7:0] cnt;

reg [2:0] state;
parameter DELAY        = 3'b000,
          FUNCTION_SET = 3'b001,
          DISP_ONOFF   = 3'b011,
          ENTRY_MODE   = 3'b010,
          SET_ADDRESS  = 3'b100,
          WRITE        = 3'b101,
          DELAY_T      = 3'b110,
          CLEAR_DISP   = 3'b111;
          
bin_to_BCD b2(clk, rst, bin, bcd);

always @(posedge clk or negedge rst) begin
    if(!rst) begin 
        state = DELAY;
        cnt = 0;
    end
    else begin
        case(state)
            DELAY : begin
                if(cnt == 70) state <= FUNCTION_SET; // state 
                if(cnt >= 70) cnt = 0;
                else cnt = cnt + 1; // cnt
            end
            FUNCTION_SET : begin
                if(cnt == 30) state <= DISP_ONOFF;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            DISP_ONOFF : begin
                if(cnt == 30) state <= ENTRY_MODE;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            ENTRY_MODE : begin
                if(cnt == 30) state <= SET_ADDRESS;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            SET_ADDRESS : begin
                if(cnt == 100) state <= WRITE;
                if(cnt >= 100) cnt = 0;
                else cnt = cnt + 1;
            end
            WRITE : begin
                if(cnt == 30) state <= DELAY_T;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            DELAY_T : begin
                if(cnt == 5) state <= CLEAR_DISP;
                if(cnt >= 5) cnt = 0;
                else cnt = cnt + 1;
            end
            CLEAR_DISP : begin
                if (cnt == 5) state = WRITE;
                if(cnt >= 5) cnt = 0;
                else cnt = cnt + 1;
            end            
            default : state <= DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_00000000;
    else begin
        case(state)
            FUNCTION_SET : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000; // 8bit data, 2 line display
            DISP_ONOFF :     
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100; // display ON, cursor OFF, blink OFF
            ENTRY_MODE :     
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110; // cursor increment, no display shift
            SET_ADDRESS : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010; // cursor at home  
            WRITE : begin
                if(cnt == 5) begin // 100 digit
                   case(bcd[11:8])
                        1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001; // 1
                        2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                        3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011; // 3
                        4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                        5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101; // 5
                        6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110; // 6
                        7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111; // 7
                        8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000; // 8
                        9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001; // 9
                        0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                   endcase 
                end
                else if(cnt == 10) begin // 10 digit
                    case(bcd[7:4])
                        1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001; // 1
                        2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                        3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011; // 3
                        4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                        5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101; // 5
                        6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110; // 6
                        7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111; // 7
                        8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000; // 8
                        9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001; // 9
                        0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //                    
                    endcase
                end
                else if(cnt == 15) begin // 1 digit
                    case(bcd[3:0])
                        1 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001; // 1
                        2 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                        3 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011; // 3
                        4 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                        5 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101; // 5
                        6 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110; // 6
                        7 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111; // 7
                        8 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000; // 8
                        9 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001; // 9
                        0 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //                       
                    endcase
                end
            end
            DELAY_T :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010; // cursor at home              
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001; // clear display
            default : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000; // busy flag & address reading
        endcase
    end
end

assign LCD_E = clk;

endmodule

