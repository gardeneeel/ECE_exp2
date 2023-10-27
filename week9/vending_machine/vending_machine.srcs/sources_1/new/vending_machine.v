`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/26 23:28:37
// Design Name: 
// Module Name: vending_machine
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


module vending_machine(clk, rst, A, B, C, state, y);

input clk, rst;
input A, B, C;
reg A_reg, B_reg, C_reg;
reg A_trig, B_trig, C_trig;
output reg [2:0] state;
output reg y;

parameter S0 = 3'b000;
parameter S50 = 3'b001;
parameter S100 = 3'b010;
parameter S150 = 3'b011;
parameter S200 = 3'b100;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        {A_reg, B_reg, C_reg} <= 3'b000;
        {A_trig, B_trig, C_trig} <= 3'b000;
    end
    else begin
        {A_reg, B_reg, C_reg} <= {A, B, C};
        {A_trig, B_trig, C_trig} <= {A, B, C} & ~{A_reg, B_reg, C_reg};
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) state <= S0;
    else begin
        case(state)
            S0 : begin
                if(A_trig) state <= S50;
                else if(B_trig) state <= S100;
                else state <= S0;
            end
            S50 : begin
                if(A_trig) state <= S100;
                else if(B_trig) state <= S150;
                else state <= S50;
            end    
            S100 : begin
                if(A_trig) state <= S150;
                else state = S100;
            end
            S150 : begin
                if(A_trig) state <= S200;
                else if(B_trig) state <= S200;
                else state <= S150;
            end
            S200 : begin
                if(A_trig) state <= S200;
                else if(B_trig) state <= S200;
                else if(C_trig) state <= S0;
                else state <= S200;
            end
        endcase
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) y <= 0;
    else begin
        case(state)
            S200 : y <= C_trig ? 1 : 0;
        endcase
    end
end
endmodule
