// SPDX-License-Identifier: MIT  Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// GPIO 控制 testbench（修正版）
`timescale 1ns / 1ps

module tb_gpio_ctrl;

    reg clk, rst_n;
    reg [3:0] key_in;
    wire [3:0] led_out;

    gpio_ctrl #(.DEBOUNCE_CNT(10)) uut (.clk(clk), .rst_n(rst_n), .key_in(key_in), .led_out(led_out));

    always #10 clk = ~clk;

    integer pass, fail;

    initial begin
        pass = 0; fail = 0;
        clk = 0; rst_n = 0; key_in = 4'b1111;

        repeat (10) @(posedge clk);
        rst_n <= 1;
        repeat (5) @(posedge clk);

        // 场景1：按下 key[0] → LED[0] 亮
        $display("=== Scene 1: Press key[0] ===");
        key_in[0] <= 0;
        repeat (40) @(posedge clk);
        key_in[0] <= 1;
        repeat (10) @(posedge clk); #1;

        if (led_out[0] === 1'b1) $display("[PASS] LED0 on (led_out=%b)", led_out);
        else begin $display("[FAIL] led_out=%b", led_out); fail = fail + 1; end
        pass = pass + 1;

        // 场景2：再次按下 key[0] → LED[0] 灭（翻转）
        $display("=== Scene 2: Press key[0] again (toggle) ===");
        key_in[0] <= 0;
        repeat (40) @(posedge clk);
        key_in[0] <= 1;
        repeat (10) @(posedge clk); #1;

        if (led_out[0] === 1'b0) $display("[PASS] LED0 off (toggle works, led_out=%b)", led_out);
        else begin $display("[FAIL] led_out=%b", led_out); fail = fail + 1; end
        pass = pass + 1;

        // 场景3：同时按下 key[1]+key[2]
        $display("=== Scene 3: Press key[1]+key[2] ===");
        key_in[1] <= 0; key_in[2] <= 0;
        repeat (40) @(posedge clk);
        key_in[1] <= 1; key_in[2] <= 1;
        repeat (10) @(posedge clk); #1;

        if (led_out[1] && led_out[2]) $display("[PASS] LED1+LED2 on (led_out=%b)", led_out);
        else begin $display("[FAIL] led_out=%b", led_out); fail = fail + 1; end
        pass = pass + 1;

        $display("======================================");
        $display("gpio_ctrl: %d passed, %d failed", pass, fail);
        $display("======================================");
        $finish;
    end

endmodule
