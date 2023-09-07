`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/31 15:55:45
// Design Name: 
// Module Name: vga
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


module vga(
    input clk,
    input rst,
    output hsync,
    output vsync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    input [9:0]upx1,
    input [9:0]upy1,
    input [9:0]upx2,
    input [9:0]upy2,
    input [9:0]dnx1,
    input [9:0]dny1,
    input [9:0]dnx2,
    input [9:0]dny2,
    input [9:0]birdy,
    output vneg
    );
    reg[9:0] h_count=10'h0;
    reg[9:0] v_count=10'h0;
    //h_count
    always@(posedge clk or negedge rst)
    begin
        if(~rst)
            h_count<=10'h0;
        else if(h_count==10'd799)
            h_count<=10'h0;
        else
            h_count<=h_count+10'h1;
    end
    //v_vount
    always@(posedge clk or negedge rst)
    begin
        if(~rst)
            v_count<=10'h0;
        else if(h_count==10'd799)
            begin
            if(v_count==10'd524)
                v_count<=10'h0;
            else
                v_count<=v_count+10'h1;   
            end         
    end
    assign hsync=(h_count>10'd95);
    assign vsync=(v_count>10'd1);
    reg[13:0]addrbt=14'h0;
    wire [11:0]doutbt;
    reg[9:0]addrbd=10'h0;
    wire [11:0]doutbd;
    reg[12:0]addrup=13'h0;
    wire [11:0]doutup;
    reg[12:0]addrdn=13'h0;
    wire [11:0]doutdn;  
    reg[12:0]addrup2=13'h0;
    wire [11:0]doutup2;
    reg[12:0]addrdn2=13'h0;
    wire [11:0]doutdn2;      
    BOTTOM bt(.addra(addrbt),.clka(clk),.douta(doutbt));
    BIRD bd(.addra(addrbd),.clka(clk),.douta(doutbd));
    ZZUP zup(.addra(addrup),.clka(clk),.douta(doutup));
    ZZDOWN zdn(.addra(addrdn),.clka(clk),.douta(doutdn));
    ZZUP2 zup2(.addra(addrup2),.clka(clk),.douta(doutup2));
    ZZDOWN2 zdn2(.addra(addrdn2),.clka(clk),.douta(doutdn2));    
    //display
    reg [3:0]datar;
    reg [3:0]datag;
    reg [3:0]datab;
    reg [9:0]birdx=10'd445;//不变
    wire rdn;
    assign rdn=~(h_count>=10'd140&&h_count<10'd780&&v_count>=10'd35&&v_count<10'd515);//640*480
    assign red=~rdn?datar:4'h0;
    assign blue=~rdn?datab:4'h0;
    assign green=~rdn?datag:4'h0;
    always@(posedge clk or negedge rst)
    begin
    if(~rst)
    begin
        addrbt<=14'b0;
        addrbd<=10'b0;
        addrup<=13'b0;
        addrdn<=13'b0;
        addrup2<=13'b0;
        addrdn2<=13'b0; 
    end
    else
    begin        
        if(addrbt==14'd14250||~vsync)
            addrbt<=14'b0;
        if(addrbd==10'd816||~vsync)
            addrbd<=10'b0;
        if(addrup==13'd7800||~vsync)
            addrup<=13'b0;
        if(addrdn==13'd7800||~vsync)
            addrdn<=13'b0;
        if(addrup2==13'd7800||~vsync)
            addrup2<=13'b0;
        if(addrdn2==13'd7800||~vsync)
            addrdn2<=13'b0;   
        datar<=4'h0;
        datag<=4'h0;
        datab<=4'h0;                     
        if(h_count>=upx1&&h_count<=upx1+10'd51&&v_count>=upy1&&v_count<=upy1+10'd149)//柱子（上）
            begin
            datar<=doutup[11:8];
            datag<=doutup[7:4];
            datab<=doutup[3:0];
            addrup<=addrup+13'b1;
            end      
        if(h_count>=upx2&&h_count<=upx2+10'd51&&v_count>=upy2&&v_count<=upy2+10'd149)//柱子（上2）
            begin
            datar<=doutup2[11:8];
            datag<=doutup2[7:4];
            datab<=doutup2[3:0];
            addrup2<=addrup2+13'b1;
            end         
        if(h_count>=dnx1&&h_count<=dnx1+10'd51&&v_count>=dny1&&v_count<=dny1+10'd149)//柱子（下）
            begin
            datar<=doutdn[11:8];
            datag<=doutdn[7:4];
            datab<=doutdn[3:0];
            addrdn<=addrdn+13'b1;
            end      
        if(h_count>=dnx2&&h_count<=dnx2+10'd51&&v_count>=dny2&&v_count<=dny2+10'd149)//柱子（下2）
            begin
            datar<=doutdn2[11:8];
            datag<=doutdn2[7:4];
            datab<=doutdn2[3:0];
            addrdn2<=addrdn2+13'b1;
            end        
        if(h_count>=10'd320&&h_count<=10'd320+10'd284&&v_count>=10'd85+10'd330&&v_count<=10'd85+10'd379)//地面
            begin
            datar<=doutbt[11:8];
            datag<=doutbt[7:4];
            datab<=doutbt[3:0];
            addrbt<=addrbt+14'b1;
            end       
        if(h_count>=birdx&&h_count<=birdx+10'd33&&v_count>=birdy&&v_count<=birdy+10'd23)//鸟
            begin
            datar<=doutbd[11:8];
            datag<=doutbd[7:4];
            datab<=doutbd[3:0];
            addrbd<=addrbd+10'b1;
            end                                                              
        if(h_count>=10'd320&&h_count<=10'd320+10'd284&&v_count>=10'd85&&v_count<=10'd85+10'd379)//游戏区域
            ;
        else
            begin
            datar<=4'h0;
            datag<=4'h0;
            datab<=4'h0;
            end        
    end
    end
    reg vreg1;
    reg vreg2;
    always@(posedge clk or negedge rst)
    begin
    if(~rst)
        begin
        vreg1<=1'b0;
        vreg2<=1'b0;
        end
    else
        begin
        vreg1<=vsync;
        vreg2<=vreg1;
        end
    end
    assign vneg=~vreg1&vreg2;
endmodule
