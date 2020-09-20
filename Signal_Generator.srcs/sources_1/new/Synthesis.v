`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/20 17:50:22
// Design Name: 
// Module Name: Synthesis
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 根据输入的控制字输出任意波形数据
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Synthesis(clk, rst, w_word, a_word, p_word, f_word, dac_pre, data, valid);
    input clk;
    input rst;
    input [1 : 0] w_word; // 波形控制字：方波 三角波 锯齿波 正弦波
    input [1 : 0] a_word; // 幅值控制字：25% 50% 75% 100% 
    input [15: 0] p_word; // 相位控制字：相位偏移值
    input [15: 0] f_word; // 频率控制字：相位累加量
    input         dac_pre;   // DAC预传输标志
    output reg [11:0] data;  // DDS输出数据
    output reg        valid; // DDS输出有效标志

reg [15:0] acc; // 相位累加器值 phase accumulator
always @(posedge clk) acc <= acc + f_word; // 相位累加
wire [15:0] acc_offset = acc + p_word;     // 相位偏移

wire sin_valid;
wire [31:0] dds_cos_sin;
dds_compiler_0 sin_wave (clk, dac_pre, {p_word,f_word}, sin_valid, dds_cos_sin); 
wire [11:0] sin  = sin_valid ? dds_cos_sin[11:0] : 12'h7ff;
wire [11:0] tria = acc_offset[15:4];
wire [11:0] rect = acc_offset[15] ? 12'h000:12'hfff;
wire [11:0] swat = acc_offset[15] ? acc_offset[14:3]:~acc_offset[14:3];

always @(posedge dac_pre or negedge rst) begin
    if (!rst) begin
        data  = 12'h000;
        valid = 1'b0;
    end
    else begin 
        casez(w_word)
        2'b00:   data = tria;
        2'b01:   data = rect;
        2'b10:   data = swat;
        2'b11:   data = sin; 
        default: data = 12'hfff;
        endcase
        casez(a_word)
        2'b00:   data = data;
        2'b01:   data = data >> 1;
        2'b10:   data = data >> 2;
        2'b11:   data = data >> 3;
        default: data = data;
        endcase
        valid = 1'b1;
    end
end

endmodule
