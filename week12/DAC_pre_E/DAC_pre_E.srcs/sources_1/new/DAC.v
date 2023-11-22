`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 21:28:53
// Design Name: 
// Module Name: DAC
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


module DAC(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out,
           seg_data, seg_sel,
           LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst;
input [8:0] btn;
input add_sel;

output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d;
output reg [7:0] led_out;
output [7:0] seg_data;
output [7:0] seg_sel;
output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;


reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [8:0] btn_t;

reg [1:0] state;

parameter DELAY   = 2'b00,
          SET_WRN = 2'b01,
          UP_DATA = 2'b10;
          
oneshot_universal #(.WIDTH(9)) O1(clk, rst, btn[8:0], btn_t[8:0]);
seg7_controller S1(clk, rst, dac_d_temp, seg_data, seg_sel);
LCD_controller(clk, rst, LCD_E, LCD_RS, LCD_RW, LCD_DATA, dac_d_temp);

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= DELAY;
        cnt <= 8'b0000_0000;
    end
    else begin
        case(state)
            DELAY : begin
                if(cnt == 200) state <= SET_WRN;
                if(cnt >= 200) cnt <= 0;
                else cnt <= cnt + 1;
            end
            SET_WRN : begin
                if(cnt == 50) state <= UP_DATA;
                if(cnt >= 50) cnt <= 0;
                else cnt <= cnt + 1;                
            end
            UP_DATA : begin
                if(cnt == 30) state <= DELAY;
                if(cnt >= 30) cnt <= 0;
                else cnt <= cnt + 1;                
            end
            default : state <= DELAY;
        endcase
    end
end    

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_wrn <= 1;
    end
    else begin
        case(state)
            DELAY : dac_wrn <= 1;
            SET_WRN : dac_wrn <= 0;
            UP_DATA : dac_d <= dac_d_temp;
            default : dac_wrn <= 1;
        endcase
    end
end      

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dac_d_temp <= 8'b0000_0000;
        led_out <= 8'b0101_0101;
    end
    else begin
        if(btn == 9'b100000000)        dac_d_temp <= dac_d_temp - 8'b0000_0001; // btn 1, -1
        else if(btn_t == 9'b010000000) dac_d_temp <= dac_d_temp;                // btn 2
        else if(btn_t == 9'b001000000) dac_d_temp <= dac_d_temp + 8'b0000_0001; // btn 3, +1
        else if(btn_t == 9'b000100000) dac_d_temp <= dac_d_temp - 8'b0000_0010; // btn 4, -2
        else if(btn_t == 9'b000010000) dac_d_temp <= dac_d_temp;                // btn 5
        else if(btn_t == 9'b000001000) dac_d_temp <= dac_d_temp + 8'b0000_0010; // btn 6, +2
        else if(btn_t == 9'b000000100) dac_d_temp <= dac_d_temp - 8'b0000_1000; // btn 7, -8
        else if(btn_t == 9'b000000010) dac_d_temp <= dac_d_temp;                // btn 8
        else if(btn_t == 9'b000000001) dac_d_temp <= dac_d_temp + 8'b0000_1000; // btn 9, +8
        led_out <= dac_d_temp;
    end
end

always @(posedge clk) begin
    dac_csn <= 0;
    dac_ldacn <= 0;
    dac_a_b <= add_sel; // 0 : select A, 1 : select B
end

endmodule
