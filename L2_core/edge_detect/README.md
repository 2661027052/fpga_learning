# Edge Detection Module

## Module Overview | 模块概述

Classic edge detection circuit using the "flop + XOR" method. Detects rising, falling, and both edges with single-cycle pulse output. Parameterized width supports multi-bit buses.

经典边沿检测电路，打拍+异或法。检测上升沿、下降沿、双边沿，输出单周期脉冲。参数化位宽支持多bit总线。

## Interface | 接口说明

| Port | Width | Dir | Description |
|------|-------|-----|-------------|
| clk | 1 | I | System clock |
| rst_n | 1 | I | Async reset (active low) |
| sig_i | WIDTH | I | Signal to detect edges on |
| pos_edge | WIDTH | O | Rising edge pulse (1 cycle) |
| neg_edge | WIDTH | O | Falling edge pulse (1 cycle) |
| any_edge | WIDTH | O | Both edge pulse (1 cycle) |

## Parameters | 参数

| Parameter | Default | Description |
|-----------|---------|-------------|
| WIDTH | 1 | Input signal bit width |

## Core Principle | 核心原理

```
pos_edge = sig_i & ~sig_d1;   // 0→1
neg_edge = ~sig_i & sig_d1;   // 1→0
any_edge = sig_i ^ sig_d1;    // any change
```

## Simulation | 仿真结果

Run: `cd sim && vsim -do batch.do`

Test items:
1. Rising edge detection (0→1)
2. pos_edge is single-cycle pulse
3. Falling edge detection (1→0)
4. neg_edge is single-cycle pulse
5. Both-edge detection
6. No false triggers in steady state
7. Reset clears all outputs

## Skills Demonstrated | 涉及技能

- Metastability-safe signal sampling (flop chain)
- Single-cycle pulse generation
- Combinational edge detection logic
- Parameterized design
