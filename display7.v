`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/05 23:36:24
// Design Name: 
// Module Name: display7
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


module display7(
    input clk,
    input rst,
    input [3:0] ge,
    input [3:0] shi,
    input [3:0] bai,
    output reg [7:0] an,
    output reg [6:0] seg
    );
    reg [2:0]select=3'b000;
    reg [3:0]din;
    wire dclk;
    Divider#(50000) d4(.I_CLK(clk),.rst(rst),.O_CLK(dclk));//1000000
    always@(posedge dclk)
    begin
        if(~rst)
            select<=3'b000;
        else
            select<=select+3'b1;
    end
    always@(select)
    begin
    case(select)
        3'b000:begin
        an <= 8'b11111110; //选中第1个数码管
        din <= ge; //数码管显示的数字由din控制
        end
        3'b001:begin
        an <= 8'b11111101; //选中第二个数码管
        din <= shi;
        end
        3'b010:begin
        an <= 8'b11111011;
        din <= bai;
        end
        3'b011:begin
        an<=8'b11110111;
        din<=4'ha;
        end
        3'b100:begin
        an<=8'b11101111;
        din<=4'ha;
        end
        3'b101:begin
        an<=8'b11011111;
        din<=4'ha;
        end
        3'b110:begin
        an<=8'b10111111;
        din<=4'ha;
        end
        3'b111:begin
        an<=8'b01111111;
        din<=4'ha;
        end
    endcase
    case(din)
        4'h0: seg<= 7'b0000001; //共阳极数码管
        4'h1: seg<= 7'b1001111;
        4'h2: seg<= 7'b0010010;
        4'h3: seg<= 7'b0000110;
        4'h4: seg<= 7'b1001100;
        4'h5: seg<= 7'b0100100;
        4'h6: seg<= 7'b0100000;
        4'h7: seg<= 7'b0001111;
        4'h8: seg<= 7'b0000000;
        4'h9: seg<= 7'b0000100;
        4'ha: seg<= 7'b1111111;
    endcase
    end
endmodule
