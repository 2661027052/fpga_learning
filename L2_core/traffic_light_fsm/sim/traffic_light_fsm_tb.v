// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用

`timescale 1ns / 1ps

module traffic_light_fsm_tb;

    // 为仿真加速，缩短绿灯/黄灯时间
    localparam T_GREEN  = 5;             // 仿真用：绿灯5个周期
    localparam T_YELLOW = 2;             // 仿真用：黄灯2个周期
    localparam CLK_PER  = 20;            // 50MHz时钟周期

    reg         clk;
    reg         rst_n;
    wire        ns_green, ns_yellow, ns_red;
    wire        ew_green, ew_yellow, ew_red;
    wire [5:0]  cnt_out;

    traffic_light_fsm #(
        .TIME_GREEN (T_GREEN),
        .TIME_YELLOW(T_YELLOW)
    ) u_dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .ns_green (ns_green),
        .ns_yellow(ns_yellow),
        .ns_red   (ns_red),
        .ew_green (ew_green),
        .ew_yellow(ew_yellow),
        .ew_red   (ew_red),
        .cnt_out  (cnt_out)
    );

    //============ 时钟生成 ============
    initial clk = 1'b0;
    always #(CLK_PER/2) clk = ~clk;

    //============ 测试主流程 ============
    integer error_count;

    initial begin
        error_count = 0;

        // 复位
        rst_n = 1'b0;
        repeat(5) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);

        //--- Test 1: 复位后进入S_GREEN，南北绿灯亮 ---
        $display("[TB] Test 1: Reset → S_GREEN");
        if (ns_green !== 1'b1 || ew_red !== 1'b1) begin
            $error("[FAIL] T1: Expected ns_green=1, ew_red=1");
            error_count = error_count + 1;
        end else
            $display("[PASS] T1: S_GREEN state OK");

        //--- Test 2: S_GREEN持续T_GREEN周期后切换到S_YELLOW ---
        $display("[TB] Test 2: S_GREEN → S_YELLOW after %0d cycles", T_GREEN);
        repeat(T_GREEN) @(posedge clk);
        if (ns_yellow !== 1'b1) begin
            $error("[FAIL] T2: Expected ns_yellow=1 after S_GREEN timeout");
            error_count = error_count + 1;
        end else
            $display("[PASS] T2: S_GREEN → S_YELLOW transition OK");

        //--- Test 3: S_YELLOW后进入E_GREEN ---
        $display("[TB] Test 3: S_YELLOW → E_GREEN");
        repeat(T_YELLOW) @(posedge clk);
        if (ew_green !== 1'b1 || ns_red !== 1'b1) begin
            $error("[FAIL] T3: Expected ew_green=1, ns_red=1");
            error_count = error_count + 1;
        end else
            $display("[PASS] T3: E_GREEN state OK");

        //--- Test 4: E_GREEN后进入E_YELLOW ---
        $display("[TB] Test 4: E_GREEN → E_YELLOW");
        repeat(T_GREEN) @(posedge clk);
        if (ew_yellow !== 1'b1) begin
            $error("[FAIL] T4: Expected ew_yellow=1");
            error_count = error_count + 1;
        end else
            $display("[PASS] T4: E_YELLOW state OK");

        //--- Test 5: E_YELLOW后回到S_GREEN（完整循环） ---
        $display("[TB] Test 5: E_YELLOW → S_GREEN (full cycle)");
        repeat(T_YELLOW) @(posedge clk);
        if (ns_green !== 1'b1) begin
            $error("[FAIL] T5: Expected back to ns_green=1");
            error_count = error_count + 1;
        end else
            $display("[PASS] T5: Full cycle back to S_GREEN OK");

        //--- Test 6: 互锁检查——南北和东西不同时绿灯 ---
        $display("[TB] Test 6: Mutual exclusion check");
        repeat(2 * (T_GREEN + T_YELLOW) * 2) begin
            @(posedge clk);
            if (ns_green && ew_green) begin
                $error("[FAIL] T6: Both NS and EW green active simultaneously!");
                error_count = error_count + 1;
            end
        end
        $display("[PASS] T6: No simultaneous green detected");

        //--- Test 7: 复位恢复测试 ---
        $display("[TB] Test 7: Reset recovery");
        @(posedge clk);
        rst_n = 1'b0;
        repeat(3) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
        if (ns_green !== 1'b1) begin
            $error("[FAIL] T7: After reset, expected ns_green=1");
            error_count = error_count + 1;
        end else
            $display("[PASS] T7: Reset recovery OK");

        //============ 结果汇总 ============
        $display("========================================");
        if (error_count == 0)
            $display("[RESULT] ALL TESTS PASSED");
        else
            $display("[RESULT] FAILED: %0d errors", error_count);
        $display("========================================");

        $finish;
    end

    // 超时保护
    initial begin
        #100000;
        $error("[TB] TIMEOUT: Simulation exceeded 100us");
        $finish;
    end

endmodule
