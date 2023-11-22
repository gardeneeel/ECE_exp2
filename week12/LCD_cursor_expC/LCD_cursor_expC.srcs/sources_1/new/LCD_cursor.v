`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/19 01:55:33
// Design Name: 
// Module Name: LCD_cursor
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


module LCD_cursor(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn, LINE);

input clk, rst;
input [9:0] number_btn;
input [1:0] control_btn;
input LINE; // 0 : LINE1, 1 : LINE2

wire [9:0] number_btn_t;
wire [1:0] control_btn_t;
wire LINE1_t, LINE2_t;
reg [6:0] address;

oneshot_universal #(.WIDTH(14)) O1(clk, rst, {number_btn[9:0], control_btn[1:0], LINE, ~LINE}, {number_btn_t[9:0], control_btn_t[1:0], LINE2_t, LINE1_t});

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output reg [7:0] LED_out;

wire LCD_E;
reg LCD_RS, LCD_RW;

reg [7:0] cnt;

reg [2:0] state;
parameter DELAY        = 4'b0000,
          FUNCTION_SET = 4'b0001,
          DISP_ONOFF   = 4'b0011,
          ENTRY_MODE   = 4'b0010,
          SET_ADDRESS  = 4'b0100,
          DELAY_T      = 4'b0101,
          WRITE        = 4'b0110,
          CURSOR       = 4'b0111,
          SET_LINE1    = 4'b1000, 
          SET_LINE2    = 4'b1001;
          
always @(posedge clk or negedge rst) begin
    if(!rst) begin 
        state <= DELAY;
        cnt <= 0;
        LED_out <= 8'b0000_0000;
    end
    else begin
        case(state)
            DELAY : begin
                LED_out <= 8'b1000_0000;
                if(cnt == 70) state <= FUNCTION_SET; // state 
                if(cnt >= 70) cnt <= 0;
                else cnt <= cnt + 1; // cnt
            end
            FUNCTION_SET : begin
                LED_out <= 8'b0100_0000;
                if(cnt == 30) state <= DISP_ONOFF;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
            end
            DISP_ONOFF : begin
                LED_out <= 8'b0010_0000;
                if(cnt == 30) state <= ENTRY_MODE;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
            end
            ENTRY_MODE : begin
                LED_out <= 8'b0001_0000;
                if(cnt == 30) state <= SET_ADDRESS;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
            end
            SET_ADDRESS : begin
                LED_out <= 8'b0000_1000;
                if(cnt == 100) state <= DELAY_T;
                if(cnt >= 100) cnt <= 0;
                else cnt <= cnt + 1;
            end
            DELAY_T : begin
                LED_out <= 8'b0000_0100;
                state <= number_btn_t ? WRITE : (control_btn_t ? CURSOR : (LINE1_t ? SET_LINE1 : (LINE2_t ? SET_LINE2 : DELAY_T)));
                cnt <= 0;
            end
            WRITE : begin
                LED_out <= 8'b0000_0010;
                if(cnt == 30) state <= DELAY_T;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
            end
            CURSOR : begin
                LED_out <= 8'b0000_0001;
                if(cnt == 30) state <= DELAY_T;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;
            end
            SET_LINE1 : begin
                if(cnt == 30) state <= DELAY_T;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;                
            end
            SET_LINE2 : begin
                if(cnt == 30) state <= DELAY_T;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;             
            end    
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
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111; // display ON, cursor ON, blink ON
            ENTRY_MODE :     
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110; // cursor increment, no display shift
            SET_ADDRESS : begin
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000; // DD-RAM address set 0(LINE1)    
                address <= 7'b000_0000;
            end    
            DELAY_T : begin
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111;
            end       
            WRITE : begin
                if(cnt == 20) begin
                   case(number_btn)
                        10'b1000_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001; // 1
                        10'b0100_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                        10'b0010_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011; // 3
                        10'b0001_0000_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                        10'b0000_1000_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101; // 5
                        10'b0000_0100_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110; // 6
                        10'b0000_0010_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111; // 7
                        10'b0000_0001_00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000; // 8
                        10'b0000_0000_10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001; // 9
                        10'b0000_0000_01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                   endcase
                   address <= address + 1;
                end
                else {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111;
            end
            CURSOR : begin
                if(cnt == 20) begin
                    case(control_btn)
                        2'b10 : begin
                            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0001_0000; // cursor shift left
                            address <= address - 1;
                        end
                        2'b01 : begin
                        if(address == 7'b0010101) begin
                            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000;
                            address <= 7'b1000000;
                        end
                        else if(address <= 7'b1010101) begin
                            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000;
                            address <= 7'b0000000;
                        end 
                            {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0001_0100; // cursor shift right
                            address <= address + 1;
                        end
                    endcase
                end
                else {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1111;
            end
            SET_LINE1 : begin
                if(~LINE) begin
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000; // DD-RAM address set 0(LINE1) 
                    address <= 7'b000_0000;
                end
            end
            SET_LINE2 : begin
                if(LINE) begin
                    {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000; // DD-RAM address set 40(LINE2)      
                    address <= 7'b100_0000;           
                end
            end
        endcase
    end
end

assign LCD_E = clk;

endmodule
