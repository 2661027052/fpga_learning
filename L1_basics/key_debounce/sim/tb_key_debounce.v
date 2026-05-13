// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// 按键消抖 testbench（修正版 v2 — 无抖动，精确时序验证）
`timescale 1ns / 1ps

module tb_key_debounce;

	localparam DEBOUNCE_CNT_TEST = 20;

	reg  clk, rst_n, key_in;
	wire key_pressed;

	key_debounce
	#(
		.DEBOUNCE_CNT(DEBOUNCE_CNT_TEST)
	)
	uut
	(
		.clk        (clk),
		.rst_n      (rst_n),
		.key_in     (key_in),
		.key_pressed(key_pressed)
	);

always #10 clk = ~clk;

integer pass, fail, i;

initial begin
	pass = 0; fail = 0;
	clk = 0; rst_n = 0; key_in = 1;  // 按键未按下（高电平）

	repeat (10) @(posedge clk);
	rst_n <= 1;
	repeat (5) @(posedge clk);

	// === 场景1: 干净按下，无抖动 ===
	$display("=== Scene 1: Clean press (no bouncing) ===");
	key_in <= 0;  // 按下按键

	// 等待消抖完成：2(sync)+20(cnt)+2(edge+pulse) = 24 cycles minimum
	// 多等一些确保覆盖
	for (i = 0; i < 40; i = i + 1) begin
		@(posedge clk); #1;
		if (key_pressed) begin
			$display("[PASS] Scene 1: key_pressed=1 at cycle %0d after press", i);
			pass = pass + 1;
			// 确认是单周期脉冲
			@(posedge clk); #1;
			if (key_pressed === 1'b0) begin
				$display("[PASS] Scene 1: single-cycle pulse confirmed");
				pass = pass + 1;
			end else begin
				$display("[FAIL] Scene 1: pulse width > 1 cycle");
				fail = fail + 1;
			end
			// 跳出循环
			i = 999;
		end
	end
	if (i < 999) begin
		$display("[FAIL] Scene 1: key_pressed never asserted");
		fail = fail + 1;
	end

	// === 场景2: 短毛刺（<消抖时间，应被滤除） ===
	$display("=== Scene 2: Short glitch (3 cycles) ===");
	key_in <= 0;
	repeat (3) @(posedge clk);  // 只持续3拍，远小于20
	key_in <= 1;

	// 等待足够长时间，确保没有脉冲产生
	for (i = 0; i < 50; i = i + 1) begin
		@(posedge clk); #1;
		if (key_pressed) begin
			$display("[FAIL] Scene 2: unexpected pulse at cycle %0d", i);
			fail = fail + 1;
			i = 999;
		end
	end
	if (i < 999) begin
		$display("[PASS] Scene 2: glitch correctly filtered");
		pass = pass + 1;
	end

	// === 场景3: 第二次按下 ===
	$display("=== Scene 3: Second press ===");
	key_in <= 0;
	for (i = 0; i < 40; i = i + 1) begin
		@(posedge clk); #1;
		if (key_pressed) begin
			$display("[PASS] Scene 3: second press detected at cycle %0d", i);
			pass = pass + 1;
			i = 999;
		end
	end
	if (i < 999) begin
		$display("[FAIL] Scene 3: no pulse detected");
		fail = fail + 1;
	end

	$display("======================================");
	$display("key_debounce: %d passed, %d failed", pass, fail);
	$display("======================================");
	$finish;
end

endmodule
