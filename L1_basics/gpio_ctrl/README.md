# GPIO 控制模块 (GPIO Control)

## 模块概述 (Module Overview)

ZYNQ 硬件资源 — GPIO 控制、模块复用、层次化设计。

ZYNQ hardware resources — GPIO control, module reuse, hierarchical design.

- 4 个按键独立控制 4 个 LED
- 实例化 4 个 `key_debounce` 消抖模块，演示模块复用
- 每次按键按下翻转对应 LED 状态（按一次亮，再按一次灭）
- 采用 `generate for` 循环实现数组化实例化，代码简洁
- 4 independent keys control 4 LEDs
- Instantiates 4 `key_debounce` modules, demonstrating module reuse
- Each key press toggles the corresponding LED (on/off)
- Uses `generate for` loop for arrayed instantiation, clean code

## 接口说明 (Interface)

| 端口 Port | 方向 Dir | 位宽 Width | 说明 Description |
|-----------|----------|------------|------------------|
| clk       | I        | 1          | 系统时钟 50MHz / System clock 50 MHz |
| rst_n     | I        | 1          | 异步复位，低电平有效 / Async reset, active low |
| key_in    | I        | 4          | 4 个按键输入，低电平表示按下 / 4 key inputs, low = pressed |
| led_out   | O        | 4          | 4 个 LED 输出，高电平点亮 / 4 LED outputs, high = on |

## 模块架构 (Architecture)

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

## 仿真说明 (Simulation)

```bash
# ModelSim (compile key_debounce source as well)
cd sim
vlog ../../key_debounce/rtl/key_debounce.v ../rtl/gpio_ctrl.v tb_gpio_ctrl.v
vsim -c tb_gpio_ctrl -do "run -all; quit"
```

测试平台使用 `defparam` 覆写内部 `key_debounce` 的消抖参数为 10 个周期以加速仿真，测试 4 个场景：

The testbench uses `defparam` to override the internal `key_debounce` debounce parameter to 10 cycles for faster simulation, testing 4 scenarios:

1. **单个按键按下/释放** — Single key press/release
2. **同一按键再次按下（验证翻转）** — Same key pressed again (toggle verified)
3. **多按键同时按下（验证独立控制）** — Multiple keys pressed simultaneously (independent control verified)
4. **所有按键逐个测试** — All keys tested one by one

## 设计要点 (Design Highlights)

- 使用 `generate for` 循环简化多个相同模块的实例化
- `generate` 块中的 `begin` 必须带有命名标签（如 `gen_key_debounce`）
- 按键按下脉冲通过寄存器锁存，实现"松手保持"效果
- LED 采用翻转逻辑：每次按下切换亮/灭状态
- 模块间通过内部连线 `key_pressed[3:0]` 连接，体现层次化设计思想
- Uses `generate for` loop to simplify instantiation of multiple identical modules
- `begin` inside `generate` block must have a named label (e.g., `gen_key_debounce`)
- Key press pulse latched by register for "hold on release" behavior
- LED toggles on each press: on/off state switching
- Inter-module connection via internal wire `key_pressed[3:0]`, demonstrating hierarchical design

## 与 key_debounce 的依赖关系 (Dependency on key_debounce)

`gpio_ctrl` 依赖于 `key_debounce` 模块。仿真时需要将两个文件一起编译。

`gpio_ctrl` depends on the `key_debounce` module. Both files must be compiled together for simulation.
