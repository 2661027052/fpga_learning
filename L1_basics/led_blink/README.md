# LED 闪烁模块 (LED Blink)

## 模块概述 | Module Overview

Verilog 基础语法 — 计数器分频 + LED 输出。

Verilog fundamentals — counter-based clock division and LED output.

- 输入 50MHz 系统时钟，通过计数器分频产生 1Hz 信号
- 驱动 LED 实现 0.5s 亮、0.5s 灭的闪烁效果
- 采用参数化设计，通过修改 `DIV_FREQ` 参数可灵活调整闪烁频率
- 50 MHz system clock divided by counter to generate a 1 Hz signal
- LED toggles every 0.5 seconds (on/off blinking)
- Parametric design: adjust `DIV_FREQ` to change blink rate

## 接口说明 | Interface

| 端口 Port | 方向 Dir | 位宽 Width | 说明 Description |
|-----------|----------|------------|------------------|
| clk       | I        | 1          | 系统时钟 50MHz / System clock 50 MHz |
| rst_n     | I        | 1          | 异步复位，低电平有效 / Async reset, active low |
| led       | O        | 1          | LED 输出，1=亮 / 0=灭 / LED output, 1=on / 0=off |

## 参数说明 | Parameters

| 参数 Parameter  | 默认值 Default | 说明 Description |
|-----------------|----------------|------------------|
| DIV_FREQ        | 25_000_000     | 分频系数，LED 每 DIV_FREQ 个时钟周期翻转一次 / Division factor, LED toggles every DIV_FREQ clocks |

计算公式：`DIV_FREQ = 时钟频率 × 半周期时间 = 50_000_000 × 0.5 = 25_000_000`

Formula: `DIV_FREQ = clock_frequency x half_cycle_time = 50_000_000 x 0.5 = 25_000_000`

## 仿真说明 | Simulation

```bash
# ModelSim
cd sim
vlog ../rtl/led_blink.v tb_led_blink.v
vsim -c tb_led_blink -do "run -all; quit"
```

测试平台将 `DIV_FREQ` 覆写为 5（而非 25_000_000），大幅缩短仿真时间，然后验证 LED 每 5 个时钟周期翻转一次。

The testbench overrides `DIV_FREQ` to 5 (instead of 25_000_000) to drastically shorten simulation time, then verifies the LED toggles every 5 clock cycles.

## 设计要点 | Design Highlights

- 计数器从 0 计数到 `DIV_FREQ-1`，然后归零重新计数
- LED 在计数器到达 `DIV_FREQ-1` 时翻转状态
- 32 位计数器位宽可满足最大分频需求
- 异步复位保证系统上电后进入已知状态
- Counter runs from 0 to `DIV_FREQ-1`, then resets
- LED toggles when counter reaches `DIV_FREQ-1`
- 32-bit counter width supports maximum division needs
- Async reset ensures known state on power-up
