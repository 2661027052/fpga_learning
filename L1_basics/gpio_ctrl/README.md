# GPIO 控制模块 (gpio_ctrl)

## 知识点
ZYNQ 硬件资源 - GPIO 控制、模块复用、层次化设计

## 功能描述
- 4 个按键独立控制 4 个 LED
- 实例化 4 个 `key_debounce` 消抖模块，演示模块复用
- 每次按键按下翻转对应 LED 状态（按一次亮，再按一次灭）
- 采用 `generate for` 循环实现数组化实例化，代码简洁

## 模块端口

| 端口 | 方向 | 位宽 | 说明 |
|------|------|------|------|
| clk | 输入 | 1 | 系统时钟 50MHz |
| rst_n | 输入 | 1 | 异步复位，低电平有效 |
| key_in | 输入 | 4 | 4 个按键输入，低电平表示按下 |
| led_out | 输出 | 4 | 4 个 LED 输出，高电平点亮 |

## 模块架构

```
                    ┌──────────────────┐
key_in[0] ─────────┤ key_debounce[0]  ├─── key_pressed[0] ───┐
                    ├──────────────────┤                        │
key_in[1] ─────────┤ key_debounce[1]  ├─── key_pressed[1] ───┤
                    ├──────────────────┤                        │  ┌──────────┐
key_in[2] ─────────┤ key_debounce[2]  ├─── key_pressed[2] ───┼─┤ LED 寄存器├──→ led_out[3:0]
                    ├──────────────────┤                        │  └──────────┘
key_in[3] ─────────┤ key_debounce[3]  ├─── key_pressed[3] ───┘
                    └──────────────────┘
```

## 仿真说明

```bash
# 编译时需要包含 key_debounce 源码
cd sim
iverilog -o tb_gpio_ctrl.vvp tb_gpio_ctrl.v ../rtl/gpio_ctrl.v ../rtl/../key_debounce/rtl/key_debounce.v
vvp tb_gpio_ctrl.vvp
gtkwave tb_gpio_ctrl.vcd
```

测试平台使用 `defparam` 覆写内部 `key_debounce` 的消抖参数为 10 个周期以加速仿真，测试 4 个场景：
1. 单个按键按下/释放
2. 同一按键再次按下（验证翻转）
3. 多按键同时按下（验证独立控制）
4. 所有按键逐个测试

## 设计要点
- 使用 `generate for` 循环简化多个相同模块的实例化
- `generate` 块中的 `begin` 必须带有命名标签（如 `gen_key_debounce`）
- 按键按下脉冲通过寄存器锁存，实现"松手保持"效果
- LED 采用翻转逻辑：每次按下切换亮/灭状态
- 模块间通过内部连线 `key_pressed[3:0]` 连接，体现层次化设计思想

## 与 key_debounce 的依赖关系
`gpio_ctrl` 依赖于 `key_debounce` 模块。仿真时需要将两个文件一起编译，或在测试平台中通过 `` `include `` 引入。
