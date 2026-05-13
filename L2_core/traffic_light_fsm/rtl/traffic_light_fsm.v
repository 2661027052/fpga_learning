// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用

// 交通灯控制器 - 三段式Moore状态机（独热码）
module traffic_light_fsm #(
	parameter TIME_GREEN  = 60,          // 绿灯持续时间（秒）
	parameter TIME_YELLOW = 5            // 黄灯持续时间（秒）
	)
	(
	input  wire        clk,              // 系统时钟
	input  wire        rst_n,            // 异步复位，低有效
	output wire        ns_green,         // 南北绿灯
	output wire        ns_yellow,        // 南北黄灯
	output wire        ns_red,           // 南北红灯
	output wire        ew_green,         // 东西绿灯
	output wire        ew_yellow,        // 东西黄灯
	output wire        ew_red,           // 东西红灯
	output reg  [5:0]  cnt_out           // 当前状态倒计时（便于仿真观察）
);

//============ 状态编码（独热码） ============
localparam S_GREEN  = 4'b0001;       // 南北绿灯，东西红灯
localparam S_YELLOW = 4'b0010;       // 南北黄灯，东西红灯
localparam E_GREEN  = 4'b0100;       // 东西绿灯，南北红灯
localparam E_YELLOW = 4'b1000;       // 东西黄灯，南北红灯

//============ 第一段：状态寄存器（时序逻辑） ============
reg [3:0] current_state;
reg [3:0] next_state;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		current_state <= S_GREEN;    // 复位到南北绿灯
	else
		current_state <= next_state;
end

//============ 第二段：次态跳转（组合逻辑） ============
reg [5:0] time_limit;               // 当前状态持续时间上限
reg       en_cnt;                    // 计数器使能
reg [5:0] cnt;                       // 倒计时计数器

always @(*) begin
	next_state = current_state;      // ★ 默认保持当前状态，防止Latch
	en_cnt     = 1'b1;               // 默认使能计数
	time_limit = TIME_GREEN;         // 默认绿灯时长

	case (current_state)
		S_GREEN: begin
			if (cnt == 6'd0) begin
			    next_state = S_YELLOW;
			    time_limit = TIME_YELLOW;   // ★ reload 用下一状态时长
			end else
			    time_limit = TIME_GREEN;
		end
		S_YELLOW: begin
			if (cnt == 6'd0) begin
			    next_state = E_GREEN;
			    time_limit = TIME_GREEN;    // ★ reload 用下一状态时长
			end else
			    time_limit = TIME_YELLOW;
		end
		E_GREEN: begin
			if (cnt == 6'd0) begin
			    next_state = E_YELLOW;
			    time_limit = TIME_YELLOW;   // ★ reload 用下一状态时长
			end else
			    time_limit = TIME_GREEN;
		end
		E_YELLOW: begin
			if (cnt == 6'd0) begin
			    next_state = S_GREEN;
			    time_limit = TIME_GREEN;    // ★ reload 用下一状态时长
			end else
			    time_limit = TIME_YELLOW;
		end
		default: next_state = S_GREEN; // 非法状态安全恢复
	endcase
end

//============ 倒计时计数器 ============
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		cnt <= time_limit - 1'b1;    // ★ 从N-1开始，共N个周期
	else if (en_cnt) begin
		if (cnt == 6'd0)
			cnt <= time_limit - 1'b1; // 计满重新装载
		else
			cnt <= cnt - 1'b1;        // 递减计数
	end
end

//============ 第三段：输出逻辑（时序输出，无毛刺） ============
reg ns_g, ns_y, ns_r;
reg ew_g, ew_y, ew_r;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		{ns_g, ns_y, ns_r} = 3'b001;  // 复位：南北红灯
		{ew_g, ew_y, ew_r} = 3'b001;  // 复位：东西红灯
	end else begin
		case (next_state)              // ★ 用 next_state，输出与状态同步
			S_GREEN:  begin {ns_g,ns_y,ns_r} = 3'b100; {ew_g,ew_y,ew_r} = 3'b001; end
			S_YELLOW: begin {ns_g,ns_y,ns_r} = 3'b010; {ew_g,ew_y,ew_r} = 3'b001; end
			E_GREEN:  begin {ns_g,ns_y,ns_r} = 3'b001; {ew_g,ew_y,ew_r} = 3'b100; end
			E_YELLOW: begin {ns_g,ns_y,ns_r} = 3'b001; {ew_g,ew_y,ew_r} = 3'b010; end
			default:  begin {ns_g,ns_y,ns_r} = 3'b001; {ew_g,ew_y,ew_r} = 3'b001; end
		endcase
	end
end

assign ns_green  = ns_g;
assign ns_yellow = ns_y;
assign ns_red    = ns_r;
assign ew_green  = ew_g;
assign ew_yellow = ew_y;
assign ew_red    = ew_r;

//============ 倒计时输出 ============
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		cnt_out <= 6'd0;
	else
		cnt_out <= cnt;
end

endmodule
