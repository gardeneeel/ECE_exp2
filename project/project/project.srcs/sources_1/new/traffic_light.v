`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/22 22:45:12
// Design Name: 
// Module Name: traffic_light
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


module traffic_light(clk, rst, led_w_green, led_w_red, led_green, led_yellow, led_red, led_left
                        );

input clk, rst;

output reg [3:0] led_w_green; // {S, W, N, E}
output reg [3:0] led_w_red;
output reg [3:0] led_green;
output reg [3:0] led_yellow;
output reg [3:0] led_red;
output reg [3:0] led_left;

reg [1:0] direction;
parameter SOUTH = 2'b00,
          WEST  = 2'b01,
          NORTH = 2'b10,
          EAST  = 2'b11;
      
reg [2:0] state;
parameter STATE_A = 3'b000,  
          STATE_B = 3'b001,
          STATE_C = 3'b010,
          STATE_D = 3'b011,
          STATE_E = 3'b100,
          STATE_F = 3'b101,
          STATE_G = 3'b110,
          STATE_H = 3'b111;

reg [4:0] cnt_h; // 0 ~ 23h
reg [5:0] cnt_m; // 0 ~ 59m
reg [5:0] cnt_s; // 0 ~ 59s

reg clk_s, clk_m, clk_h;

always @(posedge clk or negedge rst) begin // s counter
    if(!rst) cnt_s <= 6'b000000;
    else if(cnt_s == 6'b111011) begin
        cnt_s <= 6'b000000;
        clk_m <= 1'b1;
    end
    else begin
        cnt_s <= cnt_s + 1;
        clk_m <= 1'b0;
    end   
end          

always @(posedge clk_m or negedge rst) begin // m counter
    if(!rst) cnt_m <= 6'b000000;
    else if(cnt_m == 6'b111011) begin
        cnt_m <= 6'b000000;
        clk_h <= 1'b1;
    end
    else begin
        cnt_m <= cnt_m + 1;
        clk_h <= 1'b0;
    end
end

always @(posedge clk_h or negedge rst) begin // h counter
    if(!rst) cnt_h <= 5'b00000;
    else if(cnt_h == 5'b10111) begin
        cnt_h <= 5'b00000;
    end
    else begin
        cnt_h <= cnt_h + 1;
    end
end
endmodule
