`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/04 20:10:12
// Design Name: 
// Module Name: Divider
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


module Divider(
    input I_CLK,
    input rst,
    output reg O_CLK
    );
    parameter t=4;
    reg[32:0] count;
    initial
    begin
    count<=0;
    O_CLK<=0;
    end
    always@(posedge I_CLK)
    begin
    if(~rst)
        begin
        count<=0;
        O_CLK<=0;
        end
    else
    if(count==t/2-1)
        begin
        count<=0;
        O_CLK<=~O_CLK;
        end
    else
        count<=count+1;
    end
endmodule
