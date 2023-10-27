`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 23:46:47
// Design Name: 
// Module Name: TB_vending_machine
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


module TB_vending_machine();

reg clk, rst;
reg A, B, C;
wire [2:0] state;
wire y;

parameter S0 = 3'b000;
parameter S50 = 3'b001;
parameter S100 = 3'b010;
parameter S150 = 3'b011;
parameter S200 = 3'b100;

vending_machine u0(clk, rst, A, B, C, state, y);

initial begin
    clk <= 0;
    {A, B, C} <= 3'b000;
    rst <= 1;
    #20 rst <= 0; // reset
    #20 rst <= 1; 
    #20 {A, B, C} <= 3'b100; // A
    #20 {A, B, C} <= 3'b010; // B
    #20 {A, B, C} <= 3'b100; // A
    #20 {A, B, C} <= 3'b010; // B
    #20 {A, B, C} <= 3'b001; // C
    #20 rst <= 0; // reset
    #20 rst <= 1;
    #20 {A, B, C} <= 3'b000;
    #20 {A, B, C} <= 3'b100; // A
    #20 {A, B, C} <= 3'b010; // B
    #20 {A, B, C} <= 3'b001; // C
end

always #5 clk <= ~clk;
endmodule
