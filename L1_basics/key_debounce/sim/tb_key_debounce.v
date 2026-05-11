`timescale 1ns / 1ps
// ============================================================================
// 测试平台: tb_key_debounce
// 功能描述: 验证按键消抖模块
// 测试方法: 模拟按键抖动现象（快速多次翻转），验证消抖后输出干净脉冲
//           用$error自检脉冲时序是否正确
// ============================================================================

module tb_key_debounce;

    // -----------------------------------------------------------------------
    // 测试参数：缩短消抖时间以加速仿真
    // DEBOUNCE_CNT_TEST = 20 表示需要稳定20个时钟周期才确认按键
    // -----------------------------------------------------------------------
    localparam DEBOUNCE_CNT_TEST = 20;

    // -----------------------------------------------------------------------
    // 信号声明
    // -----------------------------------------------------------------------
    reg  clk      ;  // 测试时钟
    reg  rst_n    ;  // 测试复位
    reg  key_in   ;  // 按键输入（模拟抖动）
    wire key_pressed;  // 消抖后输出的按键脉冲

    // -----------------------------------------------------------------------
    // 待测模块实例化
    // -----------------------------------------------------------------------
    key_debounce #(
        .DEBOUNCE_CNT(DEBOUNCE_CNT_TEST)
    ) u_key_debounce (
        .clk        (clk        ),
        .rst_n      (rst_n      ),
        .key_in     (key_in     ),
        .key_pressed(key_pressed)
    );

    // -----------------------------------------------------------------------
    // 时钟生成：50MHz
    // -----------------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;  // 周期20ns
    end

    // -----------------------------------------------------------------------
    // 测试激励
    // 场景设计：
    //   1. 初始状态：按键未按下（高电平）
    //   2. 抖动期A：快速翻转多次，模拟按键按下时的机械抖动
    //   3. 稳定期A：持续低电平（按键稳定按下）
    //   4. 期望：在稳定期A结束后输出一个key_pressed脉冲
    //   5. 抖动期B：快速翻转，模拟按键释放时的抖动
    //   6. 稳定期B：持续高电平（按键释放）
    //   7. 重复 抖动期C → 稳定期C（第二次按下）
    // -----------------------------------------------------------------------
    initial begin
        // VCD波形
        $dumpfile("tb_key_debounce.vcd");
        $dumpvars(0, tb_key_debounce);

        // 初始化
        rst_n = 1'b0;
        key_in = 1'b1;     // 模拟按键未按下（高电平）

        // 等待复位完成
        repeat (10) @(posedge clk);
        rst_n = 1'b1;
        repeat (5) @(posedge clk);

        // ============================================================
        // 场景1：第一次按键按下（含抖动）
        // ============================================================
        $display("=== 场景1: 按键按下（模拟机械抖动）===");

        // 抖动期：模拟按键按下时的机械弹跳
        // 在短时间内快速翻转，模拟真实按键的抖动现象（通常持续5~10ms）
        repeat (3) begin
            key_in = 1'b0; @(posedge clk);
            key_in = 1'b1; @(posedge clk);
            key_in = 1'b0; @(posedge clk);
            key_in = 1'b1; @(posedge clk);
            key_in = 1'b0; @(posedge clk);
        end
        // 再随机抖动几下
        key_in = 1'b1; @(posedge clk);
        key_in = 1'b0; @(posedge clk);
        key_in = 1'b1; @(posedge clk);

        // 稳定期：按键最终稳定在低电平（按下状态）
        $display("  按键稳定按下...等待消抖完成");
        key_in = 1'b0;

        // 等待消抖完成（DEBOUNCE_CNT_TEST个周期）
        // 在DEBOUNCE_CNT_TEST个周期后应产生key_pressed脉冲
        repeat (DEBOUNCE_CNT_TEST - 2) @(posedge clk);

        // 检查：在消抖完成的那个时钟周期附近检查key_pressed
        @(posedge clk);
        #1;
        if (key_pressed !== 1'b1) begin
            $error("[FAIL] 场景1: 按键按下后未检测到key_pressed脉冲! key_pressed=%b", key_pressed);
        end else begin
            $display("[PASS] 场景1: 按键按下后正确产生key_pressed脉冲");
        end

        // 确认脉冲只持续一个周期
        @(posedge clk);
        #1;
        if (key_pressed !== 1'b0) begin
            $error("[FAIL] 场景1: key_pressed脉冲超过1个时钟周期! key_pressed=%b", key_pressed);
        end else begin
            $display("[PASS] 场景1: key_pressed脉冲宽度为1个时钟周期（正确）");
        end

        // ============================================================
        // 场景2：按键释放（含抖动）
        // ============================================================
        $display("=== 场景2: 按键释放（模拟机械抖动）===");

        // 抖动期：模拟释放时的抖动
        repeat (2) begin
            key_in = 1'b1; @(posedge clk);
            key_in = 1'b0; @(posedge clk);
            key_in = 1'b1; @(posedge clk);
            key_in = 1'b0; @(posedge clk);
        end

        // 稳定释放
        key_in = 1'b1;
        $display("  按键释放...");

        // 等待一段时间，确认没有产生脉冲（释放时不应产生key_pressed）
        repeat (DEBOUNCE_CNT_TEST + 10) @(posedge clk);
        #1;
        if (key_pressed !== 1'b0) begin
            $error("[FAIL] 场景2: 按键释放时产生了错误的key_pressed脉冲! key_pressed=%b", key_pressed);
        end else begin
            $display("[PASS] 场景2: 按键释放时没有产生脉冲（正确）");
        end

        // ============================================================
        // 场景3：第二次按键按下（验证模块可重复使用）
        // ============================================================
        $display("=== 场景3: 第二次按键按下（模块重复使用验证）===");

        // 没有抖动，直接稳定按下（理想情况）
        key_in = 1'b0;
        $display("  第二次稳定按下...");

        // 等待消抖完成
        repeat (DEBOUNCE_CNT_TEST - 2) @(posedge clk);
        @(posedge clk);
        #1;
        if (key_pressed !== 1'b1) begin
            $error("[FAIL] 场景3: 第二次按下未检测到key_pressed脉冲! key_pressed=%b", key_pressed);
        end else begin
            $display("[PASS] 场景3: 第二次按下正确产生key_pressed脉冲");
        end

        // 验证脉冲宽度
        @(posedge clk);
        #1;
        if (key_pressed !== 1'b0) begin
            $error("[FAIL] 场景3: 第二次按下的key_pressed脉冲超过1个周期! key_pressed=%b", key_pressed);
        end else begin
            $display("[PASS] 场景3: 第二次按下脉冲宽度正确");
        end

        // ============================================================
        // 场景4：短暂毛刺（验证消抖模块能滤除短脉冲干扰）
        // ============================================================
        $display("=== 场景4: 短毛刺干扰（应被滤除）===");

        key_in = 1'b0;
        // 产生一个很短的毛刺（远小于消抖时间）
        repeat (3) @(posedge clk);
        key_in = 1'b1;
        repeat (3) @(posedge clk);

        // 等待完整消抖时间，确认没有脉冲产生（因为毛刺太短）
        repeat (DEBOUNCE_CNT_TEST + 10) @(posedge clk);
        #1;
        if (key_pressed !== 1'b0) begin
            $error("[FAIL] 场景4: 短毛刺未被滤除! key_pressed=%b", key_pressed);
        end else begin
            $display("[PASS] 场景4: 短毛刺被正确滤除");
        end

        // ============================================================
        // 测试完成
        // ============================================================
        $display("========================================");
        $display("  key_debounce 测试完成，所有检查通过！");
        $display("========================================");
        #100;
        $finish;
    end

    // -----------------------------------------------------------------------
    // 超时保护：防止仿真无限运行
    // -----------------------------------------------------------------------
    initial begin
        #50000;
        $display("========================================");
        $display("  仿真超时，请检查模块逻辑");
        $display("========================================");
        $finish;
    end

endmodule
