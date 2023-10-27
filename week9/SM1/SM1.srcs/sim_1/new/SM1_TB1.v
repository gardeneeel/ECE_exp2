`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/11 00:27:48
// Design Name: 
// Module Name: SM1_TB1
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


module SM1_TB1();

reg clk, rst, x;
wire [1:0] state;

wire y;

SM1 u0(clk, rst, x, y, state);

initial begin
    clk <= 0;
    rst <= 1;
    x <= 0;
    #10 rst <= 0;
    #10 rst <= 1; // reset
    #10 x <= 1; // 1.1. state 00, input 1
    
    #10 rst <= 0;
    #10 rst <= 1; // reset    
    x <= 0;
    #10 x <= 1; // state 00 -> 01
    #10 x <= 0; // 1.2. state 01, input 0
    
    #10 rst <= 0;
    #10 rst <= 1; // reset
    x <= 0;
    #10 x <= 1; // state 00 -> 01
    #10 x <= 1; // 1.3. state 01, input 1
    
    #10 rst <= 0;
    #10 rst <= 1; // reset
    x <= 0;
    #10 x <= 1; // state 00 -> 01
    #10 x <= 1; // state 01 -> 11        
    #10 x <= 1; // state 11 -> 10
    #10 x <= 0; // 1.4. state 10, input 0
    
    #10 rst <= 0;
    #10 rst <= 1; // reset
    x <= 0;
    #10 x <= 1; // state 00 -> 01
    #10 x <= 1; // state 01 -> 11        
    #10 x <= 1; // state 11 -> 10
    #10 x <= 1; // 1.5. state 10, input 1
    
    #10 rst <= 0;
    #10 rst <= 1; // reset    
    x <= 0;
    #10 x <= 1; // state 00 -> 01
    #10 x <= 1; // state 01 -> 11 
    #10 x <= 0; // 1.6. state 11, input 0     
end

always #5 clk <= ~clk;
endmodule
