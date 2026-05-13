// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用

`timescale 1ns / 1ps

module edge_detect_tb;

    localparam CLK_PER = 20;             // 50MHz

    reg         clk;
    reg         rst_n;
    reg         sig_in;
    wire        pos_edge;
    wire        neg_edge;
    wire        any_edge;

    edge_detect #(.WIDTH(1)) u_dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .sig_i    (sig_in),
        .pos_edge (pos_edge),
        .neg_edge (neg_edge),
        .any_edge (any_edge)
    );

    //============ 时钟 ============
    initial clk = 1'b0;
    always #(CLK_PER/2) clk = ~clk;

    //============ 测试 ============
    integer error_count;

    initial begin
        error_count = 0;
        sig_in = 1'b0;
        rst_n = 1'b0;
        repeat(3) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);

        //--- Test 1: 上升沿检测 ---
        $display("[TB] Test 1: Rising edge detection");
        @(posedge clk);
        sig_in = 1'b1;                   // 0→1
        @(posedge clk);
        if (pos_edge !== 1'b1) begin
            $error("[FAIL] T1: Expected pos_edge=1, got %b", pos_edge);
            error_count = error_count + 1;
        end else
            $display("[PASS] T1: Rising edge detected OK");

        //--- Test 2: pos_edge是单周期脉冲 ---
        $display("[TB] Test 2: pos_edge pulse width = 1 cycle");
        @(posedge clk);
        if (pos_edge !== 1'b0) begin
            $error("[FAIL] T2: pos_edge should be 1-cycle pulse");
            error_count = error_count + 1;
        end else
            $display("[PASS] T2: pos_edge is single-cycle pulse OK");

        //--- Test 3: 下降沿检测 ---
        $display("[TB] Test 3: Falling edge detection");
        repeat(3) @(posedge clk);
        sig_in = 1'b0;                   // 1→0
        @(posedge clk);
        if (neg_edge !== 1'b1) begin
            $error("[FAIL] T3: Expected neg_edge=1, got %b", neg_edge);
            error_count = error_count + 1;
        end else
            $display("[PASS] T3: Falling edge detected OK");

        //--- Test 4: neg_edge是单周期脉冲 ---
        $display("[TB] Test 4: neg_edge pulse width = 1 cycle");
        @(posedge clk);
        if (neg_edge !== 1'b0) begin
            $error("[FAIL] T4: neg_edge should be 1-cycle pulse");
            error_count = error_count + 1;
        end else
            $display("[PASS] T4: neg_edge is single-cycle pulse OK");

        //--- Test 5: 双边沿检测 ---
        $display("[TB] Test 5: Both-edge detection");
        repeat(3) @(posedge clk);
        sig_in = 1'b1;                   // 上升沿
        @(posedge clk);
        if (any_edge !== 1'b1) begin
            $error("[FAIL] T5a: any_edge should detect rising edge");
            error_count = error_count + 1;
        end
        repeat(3) @(posedge clk);
        sig_in = 1'b0;                   // 下降沿
        @(posedge clk);
        if (any_edge !== 1'b1) begin
            $error("[FAIL] T5b: any_edge should detect falling edge");
            error_count = error_count + 1;
        end else
            $display("[PASS] T5: Both edges detected OK");

        //--- Test 6: 稳态无毛刺 ---
        $display("[TB] Test 6: No false trigger in steady state");
        repeat(5) @(posedge clk);
        if (pos_edge || neg_edge || any_edge) begin
            $error("[FAIL] T6: False edge detected in steady state");
            error_count = error_count + 1;
        end else
            $display("[PASS] T6: No false edge OK");

        //--- Test 7: 复位后清零 ---
        $display("[TB] Test 7: Reset clears all outputs");
        rst_n = 1'b0;
        repeat(3) @(posedge clk);
        if (pos_edge || neg_edge || any_edge) begin
            $error("[FAIL] T7: Outputs not cleared after reset");
            error_count = error_count + 1;
        end else
            $display("[PASS] T7: Reset clear OK");

        //============ 结果 ============
        $display("========================================");
        if (error_count == 0)
            $display("[RESULT] ALL TESTS PASSED");
        else
            $display("[RESULT] FAILED: %0d errors", error_count);
        $display("========================================");

        $finish;
    end

    initial begin
        #50000;
        $error("[TB] TIMEOUT");
        $finish;
    end

endmodule
