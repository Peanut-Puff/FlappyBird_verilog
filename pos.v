`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/05 21:20:52
// Design Name: 
// Module Name: pos
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


module pos(
    input up,
    input clk,
    input start,//1-ÓÎÏ·¿ªÊ¼
    input fail,
    output reg [9:0] birdy,
    output reg [9:0] upx1,
    output reg [9:0] upx2,
    output reg [9:0] upy1,
    output reg [9:0] upy2,
    output [9:0] dnx1,
    output [9:0] dnx2,
    output [9:0] dny1,
    output [9:0] dny2
    //output vneg
    );
    reg [3:0]counthigh=4'd5;
    reg [2:0]countstep=3'd0;
    reg [9:0]zzy[3:0]={10'd65,10'd15,10'd40,10'd85}; 
    reg [1:0]choose=2'b00;
    reg [9:0]oriy=10'd263;
    reg upreg1;
    reg upreg2;
    wire upsign;
    reg upflag;
    //wire clk_bird;
    //wire clk_zz;
    //Divider#(1562500) db(.I_CLK(clk),.rst(rst),.O_CLK(clk_bird));//1562500
    //Divider#(250000) dz(.I_CLK(clk),.rst(rst),.O_CLK(clk_zz));//250000
    always@(posedge clk)
    begin
    if(~start)
        begin
        upreg1<=1'b0;
        upreg2<=1'b0;
        end
    else
        begin
        upreg1<=up;
        upreg2<=upreg1;
        end
    end
    assign upsign=upreg1&~upreg2;
    always@(posedge clk)
    begin
        if(~start&&~fail)
            birdy<=oriy;
        else if(~start&&fail)
            birdy<=birdy;
        else if(upsign)
            begin
            counthigh<=4'd4;
            countstep<=3'd0;
            birdy<=birdy-counthigh;
            countstep<=countstep+3'd1;
            upflag<=1'b1;
            if(birdy<10'd85)
                birdy<=10'd85;
            end
        else
            begin
            if(counthigh>0&&counthigh<=4'd8&&upflag)
                begin
                if(countstep==3'd2)
                    begin
                    counthigh<=counthigh-4'd2;
                    countstep<=3'd0;
                    end
                countstep<=countstep+3'd1;
                birdy<=birdy-counthigh;
                end
            else if(counthigh==4'd0&&upflag)
                begin
                    countstep<=3'd1;
                    upflag<=1'b0;
                    counthigh<=4'd1;
                    birdy<=birdy+counthigh;
                end                
            else if(~upflag)
                begin
                if(countstep==3'd2)
                    begin
                    if(counthigh<4'd3)
                        counthigh<=counthigh+4'd2;
                    countstep<=3'd0;
                end
                countstep<=countstep+3'd1;
                birdy<=birdy+counthigh;
                end                
            if(birdy<10'd85)
                birdy<=10'd85;
            end
    end
    assign dny1=upy1+10'd250;
    assign dny2=upy2+10'd250;
    assign dnx1=upx1;
    assign dnx2=upx2;
    always@(posedge clk)
    begin
        if(~start&&~fail)
            begin
            upx1<=10'd617;
            upx2<=10'd799;
            choose=2'd0;
            upy1<=zzy[0];
            upy2<=zzy[1];
            end
        else if(~start&&fail)
            ;
        else
            begin
            upx1<=upx1-10'd1;
            upx2<=upx2-10'd1;
            if(upx1+10'd52==10'd320)
                begin
                upx1<=upx1+10'd364;
                upy1<=zzy[choose];
                choose<=choose+2'd1;
                end
            if(upx2==10'd268)
                begin
                upx2<=upx2+10'd364;
                upy2<=zzy[choose];
                choose<=choose+2'd1;
                end            
            end
    end
endmodule
