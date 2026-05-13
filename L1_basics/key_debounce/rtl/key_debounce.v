// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
`timescale 1ns / 1ps
// ============================================================================
// 模块名称: key_debounce
// 功能描述: 按键消抖 + 边沿检测
//           输入异步按键信号 → 两级同步消除亚稳态 → 20ms计数器消抖
//           → 边沿检测 → 输出单周期脉冲
// 知识点: Verilog基础语法 - 边沿检测 + 按键消抖
// 时钟: 50MHz
// 参数: DEBOUNCE_CNT 控制消抖时间，默认1_000_000 → 20ms
// ============================================================================

module key_debounce #(
	// 消抖计数器阈值：20ms @ 50MHz = 50_000_000 × 0.02 = 1_000_000
	parameter DEBOUNCE_CNT = 1_000_000
	)
	(
	input  wire       clk        ,  // 系统时钟，50MHz
	input  wire       rst_n      ,  // 全局复位，低电平有效
	input  wire       key_in     ,  // 异步按键输入（低电平表示按下）
	output reg        key_pressed   // 按键按下脉冲输出（单周期高电平脉冲）
	);

// -----------------------------------------------------------------------
// 信号定义
// -----------------------------------------------------------------------
// 两级同步寄存器：消除异步输入的亚稳态
reg  key_sync0;     // 第一级同步寄存器
reg  key_sync1;     // 第二级同步寄存器（同步后的稳定值）

// 消抖相关寄存器
reg [31:0] debounce_cnt;   // 消抖计数器
reg        key_stable;     // 消抖后的稳定按键值
reg        key_stable_d1;  // 稳定值的上一拍，用于边沿检测

// 内部连线
wire       key_change;     // 按键状态变化标志
wire       key_falling;    // 下降沿检测标志

// -----------------------------------------------------------------------
// 1. 两级同步器：处理异步输入的亚稳态问题
//    第一级有极小概率进入亚稳态，第二级在下一个时钟周期采样时，
//    第一级的输出已基本稳定，极大降低亚稳态传播概率
// -----------------------------------------------------------------------
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
	key_sync0 <= 1'b1;   // 复位时假设按键未按下（高电平）
	key_sync1 <= 1'b1;
end
else begin
	key_sync0 <= key_in;     // 第一级：采样异步输入
	key_sync1 <= key_sync0;  // 第二级：同步后的值
end
end

// -----------------------------------------------------------------------
// 2. 消抖计数器：检测key_sync1相对于key_stable是否有变化
//    如果有变化，开始计数；如果计数期间信号变回原值，清零重新等待
//    只有当信号稳定超过DEBOUNCE_CNT个周期时，才更新key_stable
// -----------------------------------------------------------------------
// 判断同步后的值是否与当前稳定值不同
assign key_change = (key_sync1 != key_stable);

always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
	debounce_cnt <= 32'd0;
	key_stable   <= 1'b1;   // 复位时默认高电平（未按下）
end
else if (key_change) begin
	// 检测到变化：开始计数，计数到DEBOUNCE_CNT后确认变化
	if (debounce_cnt == DEBOUNCE_CNT - 1) begin
		debounce_cnt <= 32'd0;           // 计数满，清零
		key_stable   <= key_sync1;       // 更新稳定值为当前同步值
	end
	else begin
		debounce_cnt <= debounce_cnt + 1'b1;  // 继续计数
	end
end
else begin
	// 信号恢复原值（抖动），清零计数器重新等待
	debounce_cnt <= 32'd0;
end
end

// -----------------------------------------------------------------------
// 3. 边沿检测与脉冲生成
//    检测key_stable的下降沿（按键按下：从高电平→低电平）
//    产生一个时钟周期宽的高电平脉冲
// -----------------------------------------------------------------------
// 寄存稳定值一拍，用于比较
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
	key_stable_d1 <= 1'b1;
end
else begin
	key_stable_d1 <= key_stable;
end
end

// 下降沿检测：当前为低且上一拍为高 → 按键被按下
assign key_falling = (~key_stable) & key_stable_d1;

// 输出按键按下脉冲
always @(posedge clk or negedge rst_n) begin
if (!rst_n) begin
	key_pressed <= 1'b0;
end
else begin
	key_pressed <= key_falling;  // 下降沿脉冲赋值给输出
end
end

endmodule
