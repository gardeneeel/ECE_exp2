`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 14:27:22
// Design Name: 
// Module Name: text_LCD_basic
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


module text_LCD_basic(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);

input clk, rst;

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output reg [7:0] LED_out;

wire LCD_E;
reg LCD_RS, LCD_RW;

reg [2:0] state;
parameter DELAY        = 3'b000,
          FUNCTION_SET = 3'b001,
          ENTRY_MODE   = 3'b010,
          DISP_ONOFF   = 3'b011,
          LINE1        = 3'b100,
          LINE2        = 3'b101,
          DELAY_T      = 3'b110,
          CLEAR_DISP   = 3'b111;

integer cnt;

always @(posedge clk or negedge rst) begin
    if(!rst) begin 
        state = DELAY;
        cnt = 0;
    end
    else begin
        case(state)
            DELAY : begin
                LED_out = 8'b1000_0000;
                if (cnt == 70) state = FUNCTION_SET; // state 
                if(cnt >= 70) cnt = 0;
                else cnt = cnt + 1; // cnt
            end
            FUNCTION_SET : begin
                LED_out = 8'b0100_0000;
                if (cnt == 30) state = DISP_ONOFF;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            DISP_ONOFF : begin
                LED_out = 8'b0010_0000;
                if (cnt == 30) state = ENTRY_MODE;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            ENTRY_MODE : begin
                LED_out = 8'b0001_0000;
                if (cnt == 30) state = LINE1;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            LINE1 : begin
                LED_out = 8'b0000_1000;
                if (cnt == 20) state = LINE2;
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            end
            LINE2 : begin
                LED_out = 8'b0000_0100;
                if (cnt == 20) state = DELAY_T;
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            end
            DELAY_T : begin
                LED_out = 8'b0000_0010;
                if (cnt == 5) state = CLEAR_DISP;
                if(cnt >= 5) cnt = 0;
                else cnt = cnt + 1;
            end
            CLEAR_DISP : begin
                LED_out = 8'b0000_0001;
                if (cnt == 5) state = LINE1;
                if(cnt >= 5) cnt = 0;
                else cnt = cnt + 1;
            end
            default : state = DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
    else begin
        case(state)
            FUNCTION_SET : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000; // 8bit data, 2 line display
            DISP_ONOFF :     
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100; // display ON, cursor OFF, blink OFF
            ENTRY_MODE :     
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0111; // display shift right
            LINE1 : begin
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1001_0101; // CG-RAM address set
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000; // H
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101; // E
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; // L
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; // L
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1111; // O
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0111; // W
                    09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1111; // O
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0010; // R
                    11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; // L
                    12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100; // D
                    13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0001; // !
                    14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
            end
            LINE2 : begin
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1101_0101; // CG-RAM address set
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                    08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                    09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011; // 3
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                    11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1011; // K
                    13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1010; // J
                    14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_1001; // Y
                    15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //    
                endcase
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