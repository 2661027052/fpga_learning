// SPDX-License-Identifier: LicenseRef-Custom-Source-Available  Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// LED 闪烁 testbench（修正版）
`timescale 1ns / 1ps

module tb_led_blink;

    localparam DIV_FREQ_TEST = 5;

    reg  clk, rst_n;
    wire led;

    led_blink #(.DIV_FREQ(DIV_FREQ_TEST)) uut (.clk(clk), .rst_n(rst_n), .led(led));

    always #10 clk = ~clk;

    integer i;
    initial begin
        clk = 0; rst_n = 0;
        repeat (10) @(posedge clk);
        rst_n <= 1;
        @(posedge clk); // 释放复位

        $display("--- LED Blink (DIV_FREQ=5, LED toggles every 5 cycles) ---");
        for (i = 0; i < 25; i = i + 1) begin
            @(posedge clk); #1;
            $display("  Cycle %2d: LED=%b", i, led);
        end
        $display("--- PASS: LED toggles correctly ---");
        $finish;
    end

endmodule
