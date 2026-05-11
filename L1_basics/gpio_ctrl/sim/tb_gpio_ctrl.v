`timescale 1ns / 1ps
// ============================================================================
// 测试平台: tb_gpio_ctrl
// 功能描述: 验证gpio_ctrl模块的按键→LED控制功能
// 测试方法: 分别模拟4个按键按下，验证对应LED翻转
// 注意: 仿真时需要同时编译 gpio_ctrl.v 和 key_debounce.v
//       若使用单文件编译，可用 `include 引入子模块：
//         `include "../../key_debounce/rtl/key_debounce.v"
//         `include "../rtl/gpio_ctrl.v"
// ============================================================================

module tb_gpio_ctrl;

    // -----------------------------------------------------------------------
    // 信号声明
    // -----------------------------------------------------------------------
    reg         clk      ;  // 测试时钟
    reg         rst_n    ;  // 测试复位
    reg  [3:0]  key_in   ;  // 4个按键输入
    wire [3:0]  led_out  ;  // 4个LED输出

    // -----------------------------------------------------------------------
    // 待测模块实例化（使用默认参数，消抖时间20ms）
    // -----------------------------------------------------------------------
    gpio_ctrl u_gpio_ctrl (
        .clk   (clk   ),
        .rst_n (rst_n ),
        .key_in(key_in),
        .led_out(led_out)
    );

    // -----------------------------------------------------------------------
    // 时钟生成：50MHz
    // -----------------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // -----------------------------------------------------------------------
    // 测试激励
    // 使用defparam覆写内部key_debounce的DEBOUNCE_CNT参数以加速仿真
    // 层次化路径: tb_gpio_ctrl.u_gpio_ctrl.gen_key_debounce[i].u_key_debounce.DEBOUNCE_CNT
    // -----------------------------------------------------------------------
    initial begin
        $dumpfile("tb_gpio_ctrl.vcd");
        $dumpvars(0, tb_gpio_ctrl);

        // 通过defparam覆写所有4个key_debounce实例的消抖参数
        defparam u_gpio_ctrl.gen_key_debounce[0].u_key_debounce.DEBOUNCE_CNT = 10;
        defparam u_gpio_ctrl.gen_key_debounce[1].u_key_debounce.DEBOUNCE_CNT = 10;
        defparam u_gpio_ctrl.gen_key_debounce[2].u_key_debounce.DEBOUNCE_CNT = 10;
        defparam u_gpio_ctrl.gen_key_debounce[3].u_key_debounce.DEBOUNCE_CNT = 10;

        // 初始化
        rst_n = 1'b0;
        key_in = 4'b1111;     // 所有按键未按下（高电平）
        #100;
        rst_n = 1'b1;
        #100;

        // ============================================================
        // 场景1: 按下 key_in[0] → 验证 led_out[0] 翻转
        // ============================================================
        $display("=== 场景1: 按下按键0 ===");

        // 按下按键0（低电平）
        key_in = 4'b1110;
        // 等待消抖完成（10个周期 + 额外余量）
        repeat (15) @(posedge clk);

        // 验证LED0从0→1翻转
        #1;
        if (led_out[0] !== 1'b1) begin
            $error("[FAIL] 场景1: 按下key[0]后led_out[0]应=1，实际=%b", led_out[0]);
        end else begin
            $display("[PASS] 场景1: 按键0按下，LED0点亮 (led_out=%b)", led_out);
        end

        // 释放按键0
        key_in = 4'b1111;
        repeat (15) @(posedge clk);

        // 验证LED0保持（寄存器锁存，松手不灭）
        #1;
        if (led_out[0] !== 1'b1) begin
            $error("[FAIL] 场景1: 释放key[0]后led_out[0]应保持1，实际=%b", led_out[0]);
        end else begin
            $display("[PASS] 场景1: 按键0释放后LED0保持点亮 (led_out=%b)", led_out);
        end

        // ============================================================
        // 场景2: 再次按下 key_in[0] → 验证 led_out[0] 再次翻转（熄灭）
        // ============================================================
        $display("=== 场景2: 再次按下按键0（测试翻转功能）===");
        key_in = 4'b1110;
        repeat (15) @(posedge clk);
        #1;
        if (led_out[0] !== 1'b0) begin
            $error("[FAIL] 场景2: 再次按下key[0]后led_out[0]应=0，实际=%b", led_out[0]);
        end else begin
            $display("[PASS] 场景2: 按键0再次按下，LED0熄灭 (led_out=%b)", led_out);
        end

        // 释放
        key_in = 4'b1111;
        repeat (15) @(posedge clk);

        // ============================================================
        // 场景3: 同时按下多个按键（验证独立控制）
        // ============================================================
        $display("=== 场景3: 同时按下按键1和按键2 ===");
        key_in = 4'b1001;  // key[1]和key[2]为低电平（按下）
        repeat (15) @(posedge clk);
        #1;
        if (led_out[1] !== 1'b1 || led_out[2] !== 1'b1) begin
            $error("[FAIL] 场景3: LED1和LED2应同时为1，实际led_out=%b", led_out);
        end else begin
            $display("[PASS] 场景3: 按键1和2同时按下，对应LED正确点亮 (led_out=%b)", led_out);
        end

        key_in = 4'b1111;
        repeat (15) @(posedge clk);

        // ============================================================
        // 场景4: 按键3按下测试
        // ============================================================
        $display("=== 场景4: 按下按键3 ===");
        key_in = 4'b0111;  // key[3]按下
        repeat (15) @(posedge clk);
        #1;
        if (led_out[3] !== 1'b1) begin
            $error("[FAIL] 场景4: 按下key[3]后led_out[3]应=1，实际=%b", led_out[3]);
        end else begin
            $display("[PASS] 场景4: 按键3按下，LED3点亮 (led_out=%b)", led_out);
        end

        key_in = 4'b1111;
        repeat (15) @(posedge clk);

        // ============================================================
        // 测试完成
        // ============================================================
        $display("========================================");
        $display("  gpio_ctrl 测试完成，所有检查通过！");
        $display("========================================");
        #100;
        $finish;
    end

    // -----------------------------------------------------------------------
    // 超时保护
    // -----------------------------------------------------------------------
    initial begin
        #50000;
        $display("========================================");
        $display("  仿真超时，请检查模块逻辑");
        $display("========================================");
        $finish;
    end

endmodule
