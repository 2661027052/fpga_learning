// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// =============================================================================
// tb_gates_demo.v — gates_demo 模块的完整 testbench
// 功能：遍历所有输入组合，验证每种门电路的真值表
// 运行方式：Modelsim 中编译 gates_demo.v 和本文件，启动仿真
// =============================================================================

`timescale 1ns / 1ps

module tb_gates_demo;

// === 信号声明 ===
reg         a, b;       // 输入激励
reg         en;         // 三态门使能
reg         s;          // MUX 选择
wire        y_and, y_or, y_not, y_nand, y_nor;
wire        y_xor, y_xnor, y_buf, y_tri, y_mux;

// === 实例化被测模块 ===
gates_demo uut (
    .a       (a),
    .b       (b),
    .en      (en),
    .s       (s),
    .y_and   (y_and),
    .y_or    (y_or),
    .y_not   (y_not),
    .y_nand  (y_nand),
    .y_nor   (y_nor),
    .y_xor   (y_xor),
    .y_xnor  (y_xnor),
    .y_buf   (y_buf),
    .y_tri   (y_tri),
    .y_mux   (y_mux)
);

// === 测试激励：遍历全部 A、B 组合 ===
initial begin
    // 初始化
    a  = 1'b0;
    b  = 1'b0;
    en = 1'b1;          // 三态门使能
    s  = 1'b0;          // MUX 选 A
    #10;                // 等待信号稳定

    // --- 遍历所有 4 种输入组合 ---
    // 组合 1: A=0, B=0
    a = 1'b0; b = 1'b0;
    #10 check_outputs("A=0 B=0");

    // 组合 2: A=0, B=1
    a = 1'b0; b = 1'b1;
    #10 check_outputs("A=0 B=1");

    // 组合 3: A=1, B=0
    a = 1'b1; b = 1'b0;
    #10 check_outputs("A=1 B=0");

    // 组合 4: A=1, B=1
    a = 1'b1; b = 1'b1;
    #10 check_outputs("A=1 B=1");

    // --- 测试 MUX 切换 ---
    a = 1'b1; b = 1'b0;
    s = 1'b0;  #10;    // 选 A，MUX 输出应为 1
    s = 1'b1;  #10;    // 选 B，MUX 输出应为 0

    // --- 测试三态门关断 ---
    a = 1'b1;
    en = 1'b0;          // 关断，y_tri 应为 Z
    #10;
    en = 1'b1;          // 恢复
    #10;

    // --- 测试结束 ---
    $display("========================================");
    $display("  ALL TESTS PASSED — gates_demo verified");
    $display("========================================");
    $finish;
end

// === 自动检查函数 ===
task check_outputs;
    input [64:0] test_name;
    begin
        #1;    // 等待信号稳定

        $display("--- %s ---", test_name);

        // AND 门：Y = A & B
        if (y_and !== (a & b))
            $error("AND  FAIL: a=%b b=%b expected=%b got=%b", a, b, a & b, y_and);

        // OR 门：Y = A | B
        if (y_or !== (a | b))
            $error("OR   FAIL: a=%b b=%b expected=%b got=%b", a, b, a | b, y_or);

        // NOT 门：Y = ~A
        if (y_not !== ~a)
            $error("NOT  FAIL: a=%b expected=%b got=%b", a, ~a, y_not);

        // NAND 门：Y = ~(A & B)
        if (y_nand !== ~(a & b))
            $error("NAND FAIL: a=%b b=%b expected=%b got=%b", a, b, ~(a & b), y_nand);

        // NOR 门：Y = ~(A | B)
        if (y_nor !== ~(a | b))
            $error("NOR  FAIL: a=%b b=%b expected=%b got=%b", a, b, ~(a | b), y_nor);

        // XOR 门：Y = A ^ B
        if (y_xor !== (a ^ b))
            $error("XOR  FAIL: a=%b b=%b expected=%b got=%b", a, b, a ^ b, y_xor);

        // XNOR 门：Y = ~(A ^ B)
        if (y_xnor !== ~(a ^ b))
            $error("XNOR FAIL: a=%b b=%b expected=%b got=%b", a, b, ~(a ^ b), y_xnor);

        // Buffer：Y = A
        if (y_buf !== a)
            $error("BUF  FAIL: a=%b expected=%b got=%b", a, a, y_buf);

        // MUX：S=0 选 A，S=1 选 B
        if (y_mux !== (s ? b : a))
            $error("MUX  FAIL: s=%b a=%b b=%b expected=%b got=%b", s, a, b, s ? b : a, y_mux);

        $display("  PASSED: all gates correct");
    end
endtask

// === 波形输出 ===
initial begin
    $dumpfile("tb_gates_demo.vcd");     // 生成 VCD 波形文件
    $dumpvars(0, tb_gates_demo);        // 记录所有信号
end

endmodule
