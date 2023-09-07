`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/29 17:24:08
// Design Name: 
// Module Name: flappybird
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

module flappybird(
    input oriclk,//100M
    input rst,
    input btn,
    input dn,
    output hsync,
    output [3:0] blue,
    output [3:0] red,
    output [3:0] green,
    output vsync,
    output [7:0] seg_select,
    output [6:0] seg_LED
    );
    wire up;
    assign up=~dn;
    wire clk;//25M
    wire vneg;
    reg start=1'b1;
    reg fail=1'b1;
//    reg [7:0]point=8'd0;
    wire [9:0] birdy;
    wire [9:0] upx1;
    wire [9:0] upx2;
    wire [9:0] upy1;
    wire [9:0] upy2;
    wire [9:0] dnx1;
    wire [9:0] dnx2;
    wire [9:0] dny1;
    wire [9:0] dny2;
    reg [9:0]birdx=10'd445;//²»±ä
    reg [3:0]ge=4'd0;
    reg [3:0]shi=4'd0;
    reg [3:0]bai=4'd0;
    always@(posedge vneg or posedge btn or negedge rst )
        begin
        if(~rst)
            begin
            ge<=4'd0;
            shi<=4'd0;
            bai<=4'd0;
            end
        else if(btn)
            begin
            ge<=4'd0;
            shi<=4'd0;
            bai<=4'd0;
            end
        else if(vneg &&(birdx==upx1+10'd52||birdx==upx2+10'd52))
            begin
            if(ge==4'd9)
            begin
                if(shi==4'd9)
                    begin
                    bai<=bai+4'd1;
                    shi<=4'd0;
                    end
                else
                    shi<=shi+4'd1;
                ge<=4'd0;
            end
            else            
                ge<=ge+4'd1;
            end
        end
    always@(posedge clk or negedge rst)
    begin
    if(~rst)
    begin
        fail<=1'b0;
        start<=1'b0;
    end
    else
    begin
    if((birdx<=upx1+10'd51&&birdx>=upx1-10'd33&&(birdy<=upy1+10'd149||birdy>=dny1-10'd23))||(birdx<=upx2+10'd51&&birdx>=upx2-10'd33&&(birdy<=upy2+10'd149||birdy>=dny2-10'd23))||birdy>=10'd391)
        begin
        fail<=1'b1;
        start<=1'b0;
        end
    if(start&&fail)
        begin
        start<=1'b0;
        fail<=1'b0;
        end
    else if(fail&&~start&&btn)
        fail<=1'b0;
    else if(~start&&~fail&&up)
        start<=1'b1;
    end
    end
    Divider#(4) d1(.I_CLK(oriclk),.rst(rst),.O_CLK(clk));
    display7 d7(.clk(clk),.rst(rst),.ge(ge),.shi(shi),.bai(bai),.an(seg_select),.seg(seg_LED));
    pos p1(.up(up),.clk(vneg),.start(start),.fail(fail),.birdy(birdy),
           .upx1(upx1),.upx2(upx2),.upy1(upy1),.upy2(upy2),
           .dnx1(dnx1),.dnx2(dnx2),.dny1(dny1),.dny2(dny2));
    vga v1(.clk(clk),.rst(rst),.hsync(hsync),.vsync(vsync),.red(red),.blue(blue),.green(green),
           .birdy(birdy),.upx1(upx1),.upx2(upx2),.upy1(upy1),.upy2(upy2),
           .dnx1(dnx1),.dnx2(dnx2),.dny1(dny1),.dny2(dny2),.vneg(vneg));
endmodule
