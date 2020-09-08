`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SCNU
// Engineer: WJX
// 
// Create Date: 2020/09/03 08:48:16
// Design Name: Signal_Generator
// Module Name: Encoder
// Project Name: Signal_Generator
// Target Devices: xc7z020clg484-1
// Tool Versions: Vivado 2019.2
// Description: 旋转编码器驱动
//              检测A相边沿 => 检测B相电平 => 判断旋转方向 => 输出脉冲
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Revision 1.00 - 逻辑设计完成
// Additional Comments:未仿真
// 
//////////////////////////////////////////////////////////////////////////////////

module Encoder(clk, rst, enc_a, enc_b, rot_ab, rot_ba);
    input  clk;    // 系统时钟 50Mhz
    input  rst;    // 复位信号 低电平有效
    input  enc_a;  // 编码器A相
    input  enc_b;  // 编码器B相
    output rot_ab; // AB旋转脉冲
    output rot_ba; // BA旋转脉冲

    reg [1:0] buf_a;          // A相状态  1:前一时刻  0：当前
    reg [1:0] buf_b;          // B相状态  1:前一时刻  0：当前
    wire rising,falling;      // A相边沿  上升，下降
    localparam C=20'd999_999; // 50Mhz/999999+1=50hz
    reg [19:0] cnt;           // 1/50hz=20ms

    always @(posedge clk or negedge rst) begin
        if(!rst||(cnt==C))  cnt <= 20'b0;
        else                cnt <= cnt+1;
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)        buf_a <= 2'b00;
        else if(cnt==C)  buf_a <= {buf_a[0],enc_a};
    end

    assign rising  = ~buf_a[1] &  buf_a[0];
    assign falling =  buf_a[1] & ~buf_a[0];

    assign rot_ab = (rising & ~enc_b) | (falling &  enc_b);
    assign rot_ba = (rising &  enc_b) | (falling & ~enc_b);

endmodule