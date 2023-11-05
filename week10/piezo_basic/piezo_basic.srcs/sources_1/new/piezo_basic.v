`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/03 01:12:51
// Design Name: 
// Module Name: piezo_basic
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


module piezo_basic(clk, rst, btn, piezo);

input clk, rst;
input [7:0] btn;
output reg piezo;

parameter C2 = 12'd3830;
parameter D2 = 12'd3400;
parameter E2 = 12'd3038;
parameter F2 = 12'd2864;
parameter G2 = 12'd2550;
parameter A2 = 12'd2272;
parameter B2 = 12'd2028;
parameter C3 = 12'd1912;

reg [11:0] cnt;
reg [11:0] cnt_limit;

always @(btn) begin
    if(!rst) cnt_limit = 0;
    else begin
        case(btn)
            8'b00000001 : cnt_limit = C2;
            8'b00000010 : cnt_limit = D2;
            8'b00000100 : cnt_limit = E2;
            8'b00001000 : cnt_limit = F2;
            8'b00010000 : cnt_limit = G2;
            8'b00100000 : cnt_limit = A2;
            8'b01000000 : cnt_limit = B2;
            8'b10000000 : cnt_limit = C3;
            default : cnt_limit = 0;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt = 0;
        piezo = 0;
    end
    else if(cnt >= cnt_limit/2) begin
        piezo = ~piezo;
        cnt = 0;
    end
    else cnt = cnt + 1;
end

endmodule
