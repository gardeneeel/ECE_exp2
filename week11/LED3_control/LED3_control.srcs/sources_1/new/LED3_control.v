`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/07 23:43:01
// Design Name: 
// Module Name: LED3_control
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


module LED3_control(clk, rst, btn, led_signal_R, led_signal_G, led_signal_B);

input clk, rst;
input [7:0] btn;

wire [7:0] cnt;
reg [23:0] state;

output reg [3:0] led_signal_R;
output reg [3:0] led_signal_G;
output reg [3:0] led_signal_B;

parameter red    = {8'd255, 8'd0, 8'd0};
parameter orange = {8'd255, 8'd102, 8'd0};
parameter yellow = {8'd255, 8'd255, 8'd0};
parameter green  = {8'd0, 8'd255, 8'd0};
parameter blue   = {8'd0, 8'd0, 8'd255};
parameter indigo = {8'd0, 8'd0, 8'd128};
parameter purple = {8'd128, 8'd0, 8'd128};
parameter white  = {8'd255, 8'd255, 8'd255};

counter_8bit C1(clk, rst, cnt);
always @(posedge clk or posedge rst) begin
    if(rst) state <= 24'd0;
    else begin
        case(btn)
            8'b00000001 : state <= red;
            8'b00000010 : state <= orange;
            8'b00000100 : state <= yellow;
            8'b00001000 : state <= green;
            8'b00010000 : state <= blue;
            8'b00100000 : state <= indigo;
            8'b01000000 : state <= purple;
            8'b10000000 : state <= white;
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        led_signal_R <= 4'b0000;
        led_signal_G <= 4'b0000;
        led_signal_B <= 4'b0000;
    end
    else begin
        if(cnt < state[23:16]) led_signal_R <= 4'b1111;
        else led_signal_R <= 4'b0000;
        
        if(cnt < state[15:8]) led_signal_G <= 4'b1111;
        else led_signal_G <= 4'b0000;
        
        if(cnt < state[7:0]) led_signal_B <= 4'b1111;
        else led_signal_B <= 4'b0000;                
    end
end

endmodule
