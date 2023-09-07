`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/31 18:54:07
// Design Name: 
// Module Name: test
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


module test();
    reg oriclk;
    reg rst;
    reg up;
    reg btn;
    wire hsync;
    wire [3:0] blue;
    wire [3:0] red;
    wire [3:0] green;
    wire vsync;
    wire [3:0] seg_select;
    wire [6:0] seg_LED;
    initial
    begin
        oriclk=0;
        rst=1;
        btn=0;
    forever
    begin
        #5 oriclk=~oriclk;
    end
    end
    initial
    begin
            up=0;
            #20000000 up=1;
            //#5 up=0;
end
    flappybird uut(.oriclk(oriclk),.rst(rst),.up(up),.btn(btn),.hsync(hsync),.blue(blue),.red(red),.green(green),.vsync(vsync),.seg_select(seg_select),.seg_LED(seg_LED));
endmodule
