`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 00:48:53
// Design Name: 
// Module Name: oneshot_TFF
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


module oneshot_TFF(clk, rst, T, Q);

input T, clk, rst;
reg T_reg, T_trig;
output reg Q;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        Q <= 1'b0;
        T_reg <= 1'b0;
        T_trig <= 1'b0;
    end
    else begin
        T_reg <= T;
        T_trig <= T & ~T_reg;
        if(T_trig) begin
            Q <= ~Q;
        end
    end
end

endmodule