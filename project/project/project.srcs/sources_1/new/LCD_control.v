`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 00:03:14
// Design Name: 
// Module Name: LCD_control
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


module LCD_control(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, bin_h, bin_m, bin_s, state_in, day_night);

input clk, rst;
input [4:0] bin_h;
input [5:0] bin_m;
input [5:0] bin_s;

input wire [2:0] state_in;
parameter STATE_A = 3'b000,  
          STATE_B = 3'b001,
          STATE_C = 3'b010,
          STATE_D = 3'b011,
          STATE_E = 3'b100,
          STATE_F = 3'b101,
          STATE_G = 3'b110,
          STATE_H = 3'b111;

input day_night;
parameter DAY = 1'b0;
parameter NIGHT = 1'b1;

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

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

wire [7:0] bcd_h;
wire [7:0] bcd_m;
wire [7:0] bcd_s;

bin_to_BCD B1(clk, rst, bin_h, bcd_h);
bin_to_BCD B2(clk, rst, bin_m, bcd_m);
bin_to_BCD B3(clk, rst, bin_s, bcd_s);

always @(posedge clk or negedge rst) begin
    if(!rst) begin 
        state = DELAY;
        cnt = 0;
    end
    else begin
        case(state)
            DELAY : begin
                if (cnt == 70) state = FUNCTION_SET; // state 
                if(cnt >= 70) cnt = 0;
                else cnt = cnt + 1; // cnt
            end
            FUNCTION_SET : begin
                if (cnt == 30) state = DISP_ONOFF;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            DISP_ONOFF : begin
                if (cnt == 30) state = ENTRY_MODE;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            ENTRY_MODE : begin
                if (cnt == 30) state = LINE1;
                if(cnt >= 30) cnt = 0;
                else cnt = cnt + 1;
            end
            LINE1 : begin
                if (cnt == 20) state = LINE2;
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            end
            LINE2 : begin
                if (cnt == 20) state = DELAY_T;
                if(cnt >= 20) cnt = 0;
                else cnt = cnt + 1;
            end
            DELAY_T : begin
                if (cnt == 5) state = CLEAR_DISP;
                if(cnt >= 5) cnt = 0;
                else cnt = cnt + 1;
            end
            CLEAR_DISP : begin
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
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110; // cursor increment, no display shift
            LINE1 : begin
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000; // DD-RAM address set
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100; // T
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1001; // i
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1101; // m
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0101; // e
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    08 : case(bcd_h[7:4])
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
                    09 : case(bcd_h[3:0])
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
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :
                    11 : case(bcd_m[7:4])
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
                    12 : case(bcd_m[3:0])
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
                    13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :
                    14 : case(bcd_s[7:4])
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
                    15 : case(bcd_s[3:0])
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
                    16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
            end
            LINE2 : begin
                case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000; // DD-RAM address set
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0011; // S
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; // t
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0001; // a
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; // t
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0101; // e
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010; // :
                    08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    09 : case(state_in)
                        STATE_A : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0001; // A
                        STATE_B : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0010; // B
                        STATE_C : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0011; // C
                        STATE_D : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100; // D
                        STATE_E : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101; // E
                        STATE_F : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0110; // F
                        STATE_G : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0111; // G
                        STATE_H : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000; // H
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    endcase
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1000; // (
                    11 : case(day_night)
                        DAY : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0100; // d
                        NIGHT : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1110; // n
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    endcase
                    12 : case(day_night)
                        DAY : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0001; // a
                        NIGHT : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1001; // i
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
                    endcase
                    13 : case(day_night)
                        DAY : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_1001; // y
                        NIGHT : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_0111; // g
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
                    endcase
                    14 : case(day_night)
                        DAY : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1001; // )
                        NIGHT : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0110_1000; // h
                    endcase
                    15 : case(day_night)
                        NIGHT : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0111_0100; // t
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    endcase
                    16 : case(day_night)
                        NIGHT : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1001; // )
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    endcase
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //    
                endcase
            end
            DELAY_T : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010; // cursor at home
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
            default : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000; // busy flag & address reading
        endcase
    end
end

assign LCD_E = clk;

endmodule
