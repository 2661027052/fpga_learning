// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用

// 边沿检测模块 - 经典打拍+异或法
module edge_detect #(
	parameter WIDTH = 1                  // 输入信号位宽
	)
	(
	input  wire                  clk,    // 系统时钟
	input  wire                  rst_n,  // 异步复位，低有效
	input  wire [WIDTH-1:0]      sig_i,  // 待检测信号
	output wire [WIDTH-1:0]      pos_edge, // 上升沿检测（1个clk周期脉冲）
	output wire [WIDTH-1:0]      neg_edge, // 下降沿检测（1个clk周期脉冲）
	output wire [WIDTH-1:0]      any_edge  // 双边沿检测（1个clk周期脉冲）
);

//============ 核心原理 ============
// 打拍寄存上一周期的值，与当前值做逻辑运算
// 上升沿：当前=1 且 上一拍=0 → sig_i & ~sig_d1
// 下降沿：当前=0 且 上一拍=1 → ~sig_i & sig_d1
// 双边沿：当前≠上一拍         → sig_i ^ sig_d1

reg [WIDTH-1:0] sig_d1;              // 上一拍寄存器（1级延迟）

always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		sig_d1 <= {WIDTH{1'b0}};
	else
		sig_d1 <= sig_i;             // 打一拍寄存
end

assign pos_edge =  sig_i & ~sig_d1;  // 上升沿：0→1
assign neg_edge = ~sig_i &  sig_d1;  // 下降沿：1→0
assign any_edge =  sig_i ^  sig_d1;  // 双边沿：任何变化

endmodule
