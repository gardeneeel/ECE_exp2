`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/28 16:37:53
// Design Name: 
// Module Name: oneshot_universal
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


module oneshot_universal(clk, rst, btn, btn_t);

parameter WIDTH = 1;
input clk, rst;
input [WIDTH-1:0] btn;

reg [WIDTH-1:0] btn_reg;

output reg [WIDTH-1:0] btn_t;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        btn_reg <= {WIDTH{1'b0}};
        btn_t <= {WIDTH{1'b0}};
    end
    else begin
        btn_reg <= btn;
        btn_t <= btn & ~btn_reg;
    end
end

endmodule
