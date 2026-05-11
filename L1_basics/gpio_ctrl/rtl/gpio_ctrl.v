`timescale 1ns / 1ps
// ============================================================================
// 模块名称: gpio_ctrl
// 功能描述: GPIO控制模块——4个按键控制4个LED
//          实例化4个key_debounce消抖模块，去抖后驱动LED输出
// 知识点: ZYNQ硬件资源 - GPIO控制、模块复用、层次化设计
// 设计思路:
//   1. 每个按键输入先经过key_debounce消抖
//   2. 消抖后的按键脉冲信号通过寄存器锁存后驱动对应LED
//   3. 每次按下翻转对应LED状态（实现"按一次亮，再按一次灭"的开关效果）
//   4. 演示Verilog中模块实例化和generate for循环数组化连接的方法
// ============================================================================
//
// 使用方法（仿真时需编译的文件）:
//   1. gpio_ctrl.v
//   2. ../key_debounce/rtl/key_debounce.v
//
// ============================================================================

module gpio_ctrl #(
    parameter DEBOUNCE_CNT = 10   // 消抖时间，仿真时可覆写为小值
) (
    input  wire       clk      ,  // 系统时钟，50MHz
    input  wire       rst_n    ,  // 全局复位，低电平有效
    input  wire [3:0] key_in   ,  // 4个按键输入（低电平表示按下）
    output wire [3:0] led_out     // 4个LED输出（高电平点亮）
);

    // -----------------------------------------------------------------------
    // 内部信号：4个按键的消抖后脉冲信号
    // -----------------------------------------------------------------------
    wire [3:0] key_pressed;  // 按键按下脉冲，每个bit对应一个按键

    // -----------------------------------------------------------------------
    // 实例化4个key_debounce消抖模块（使用generate for循环实现数组化实例化）
    // 每个模块处理一个按键的消抖和边沿检测
    // -----------------------------------------------------------------------
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_key_debounce
            key_debounce #(
                .DEBOUNCE_CNT(DEBOUNCE_CNT)  // 20ms消抖 @ 50MHz
            ) u_key_debounce (
                .clk        (clk            ),
                .rst_n      (rst_n          ),
                .key_in     (key_in[i]      ),  // 第i个按键输入
                .key_pressed(key_pressed[i] )   // 第i个按键脉冲输出
            );
        end
    endgenerate

    // -----------------------------------------------------------------------
    // LED输出控制：按键按下时翻转对应LED状态
    // 使用寄存器锁存LED状态，实现"按一次亮，再按一次灭"的开关效果
    // 注意：key_pressed是单周期脉冲，用寄存器才能保持长时间可见
    // -----------------------------------------------------------------------
    reg [3:0] led_reg;  // LED状态寄存器

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            led_reg <= 4'b0000;  // 复位时所有LED熄灭
        end else begin
            // 遍历每个按键，有脉冲时翻转对应LED
            // 如果多个按键同时按下，对应的LED各自独立翻转
            if (key_pressed[0]) led_reg[0] <= ~led_reg[0];
            if (key_pressed[1]) led_reg[1] <= ~led_reg[1];
            if (key_pressed[2]) led_reg[2] <= ~led_reg[2];
            if (key_pressed[3]) led_reg[3] <= ~led_reg[3];
        end
    end

    // 将内部寄存器赋值给输出端口
    assign led_out = led_reg;

endmodule
