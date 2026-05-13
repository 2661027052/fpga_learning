# 按键消抖模块 (Key Debounce)

## 模块概述 | Module Overview

Verilog 基础语法 — 边沿检测 + 按键消抖。

Verilog fundamentals — edge detection and key debouncing.

- 处理异步按键输入，消除机械抖动
- 采用两级同步器消除亚稳态
- 20ms 计数器消抖，确保按键信号稳定后才确认有效
- 边沿检测产生单周期高电平脉冲
- Processes asynchronous key input, eliminates mechanical bounce
- Two-stage synchronizer to mitigate metastability
- 20 ms counter debounce, confirms key press only after signal stabilizes
- Edge detection generates a single-cycle high pulse

## 接口说明 | Interface

| 端口 Port      | 方向 Dir | 位宽 Width | 说明 Description |
|----------------|----------|------------|------------------|
| clk            | I        | 1          | 系统时钟 50MHz / System clock 50 MHz |
| rst_n          | I        | 1          | 异步复位，低电平有效 / Async reset, active low |
| key_in         | I        | 1          | 异步按键输入（低电平表示按下）/ Async key input (low = pressed) |
| key_pressed    | O        | 1          | 按键按下脉冲（单周期高电平）/ Key press pulse (single-cycle high) |

## 参数说明 | Parameters

| 参数 Parameter   | 默认值 Default | 说明 Description |
|------------------|----------------|------------------|
| DEBOUNCE_CNT     | 1_000_000      | 消抖计数器阈值，对应 20ms @ 50MHz / Debounce counter threshold, ~20 ms @ 50 MHz |

## 模块架构 | Architecture

```
key_in → [两级同步器 | Two-stage Sync] → [消抖计数器 | Debounce Counter] → [边沿检测 | Edge Detect] → key_pressed
```

## 仿真说明 | Simulation

```bash
# ModelSim
cd sim
vlog ../rtl/key_debounce.v tb_key_debounce.v
vsim -c tb_key_debounce -do "run -all; quit"
```

测试平台将 `DEBOUNCE_CNT` 覆写为 20，模拟 4 种场景：

The testbench overrides `DEBOUNCE_CNT` to 20 and simulates 4 scenarios:

1. **按键按下含抖动** — 快速翻转后稳定低电平，验证产生脉冲
   **Key press with bounce** — rapid toggling then stable low, pulse verified
2. **按键释放含抖动** — 验证不产生错误脉冲
   **Key release with bounce** — no false pulse verified
3. **第二次按下** — 验证模块可重复使用
   **Second press** — reusability verified
4. **短毛刺干扰** — 验证短脉冲被正确滤除
   **Short glitch** — glitch correctly filtered out

## 设计要点 | Design Highlights

- 两级同步器：`key_sync0` → `key_sync1`，降低亚稳态概率
- 消抖计数器在信号与稳定值不同时开始计数，计数达到阈值才确认变化
- 若信号在计数过程中恢复原值，计数器立即清零（毛刺滤除）
- 下降沿检测：`key_falling = ~key_stable & key_stable_d1`
- Two-stage synchronizer: `key_sync0` → `key_sync1`, reduces metastability probability
- Debounce counter starts when signal diverges from stable value; confirms change only after threshold
- Counter clears immediately if signal returns to original value (glitch rejection)
- Falling edge detection: `key_falling = ~key_stable & key_stable_d1`
