# 边沿检测模块 | Edge Detection Module

## 模块概述 | Module Overview

经典边沿检测电路，采用"打拍+异或"法。检测上升沿、下降沿和双边沿，输出单周期脉冲。参数化位宽支持多 bit 总线。

Classic edge detection circuit using the "flop + XOR" method. Detects rising, falling, and both edges with single-cycle pulse output. Parameterized width supports multi-bit buses.

## 接口说明 | Interface

| 端口 Port | 位宽 Width | 方向 Dir | 说明 Description |
|:---|:---:|:---:|:---|
| clk | 1 | I | 系统时钟 / System clock |
| rst_n | 1 | I | 异步复位（低电平有效）/ Async reset (active low) |
| sig_i | WIDTH | I | 待检测边沿的信号 / Signal to detect edges on |
| pos_edge | WIDTH | O | 上升沿脉冲（1 周期）/ Rising edge pulse (1 cycle) |
| neg_edge | WIDTH | O | 下降沿脉冲（1 周期）/ Falling edge pulse (1 cycle) |
| any_edge | WIDTH | O | 双边沿脉冲（1 周期）/ Both edge pulse (1 cycle) |

## 参数 | Parameters

| 参数 Parameter | 默认值 Default | 说明 Description |
|:---|:---:|:---|
| WIDTH | 1 | 输入信号位宽 / Input signal bit width |

## 核心原理 | Core Principle

```
pos_edge = sig_i & ~sig_d1;   // 0→1 上升沿 / Rising edge
neg_edge = ~sig_i & sig_d1;   // 1→0 下降沿 / Falling edge
any_edge = sig_i ^ sig_d1;    // 任意变化 / Any change
```

## 仿真结果 | Simulation

运行命令 / Run: `cd sim && vsim -do batch.do`

| 测试项 Test Item | 说明 Description |
|:---|:---|
| 上升沿检测 Rising Edge | 0→1 跳变检测 / Detect 0→1 transition |
| 上升脉冲宽度 Pulse Width | pos_edge 为单周期脉冲 / pos_edge is single-cycle |
| 下降沿检测 Falling Edge | 1→0 跳变检测 / Detect 1→0 transition |
| 下降脉冲宽度 Pulse Width | neg_edge 为单周期脉冲 / neg_edge is single-cycle |
| 双边沿检测 Both Edges | 两种跳变均检测 / Detects both transitions |
| 稳态误触发 Steady State | 稳态无误触发 / No false triggers in steady state |
| 复位 Reset | 复位清除所有输出 / Reset clears all outputs |

## 涉及技能 | Skills Demonstrated

- 亚稳态安全信号采样（打拍链）/ Metastability-safe signal sampling (flop chain)
- 单周期脉冲生成 / Single-cycle pulse generation
- 组合逻辑边沿检测 / Combinational edge detection logic
- 参数化设计 / Parameterized design
