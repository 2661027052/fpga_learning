# 串并转换模块 | Serial-Parallel Converter

## 模块概述 | Module Overview

双向串并转换模块，集成 SIPO（串入并出）和 PISO（并入串出）。MSB 优先，参数化位宽。

Bidirectional serial-parallel converter combining SIPO (Serial-In Parallel-Out) and PISO (Parallel-In Serial-Out) in one module. MSB-first data ordering. Parameterized width.

## 接口说明 | Interface

### SIPO（串转并 | Serial to Parallel）

| 端口 Port | 位宽 Width | 方向 Dir | 说明 Description |
|:---|:---:|:---:|:---|
| si_data | 1 | I | 串行数据输入（MSB 优先）/ Serial data input (MSB first) |
| si_valid | 1 | I | 串行输入有效（每 bit 一个脉冲）/ Serial input valid (pulse per bit) |
| po_data | WIDTH | O | 并行数据输出 / Parallel data output |
| po_valid | 1 | O | 并行输出有效（满时单周期脉冲）/ Parallel output valid (1-cycle pulse when full) |

### PISO（并转串 | Parallel to Serial）

| 端口 Port | 位宽 Width | 方向 Dir | 说明 Description |
|:---|:---:|:---:|:---|
| pi_data | WIDTH | I | 待串行化的并行数据 / Parallel data to serialize |
| pi_load | 1 | I | 加载信号（启动串行输出）/ Load signal (starts serial output) |
| so_data | 1 | O | 串行数据输出（MSB 优先）/ Serial data output (MSB first) |
| so_valid | 1 | O | 串行传输期间为高 / High during serial transmission |

## 参数 | Parameters

| 参数 Parameter | 默认值 Default | 说明 Description |
|:---|:---:|:---|
| WIDTH | 8 | 数据位宽 / Data bit width |

## 数据顺序 | Data Order

- **MSB 优先 / MSB first**：最高位 bit[WIDTH-1] 最先发送/接收 / Highest bit transmitted/received first
- **PISO**：加载 pi_data → 先输出 bit[WIDTH-1]，左移，最后 bit[0] / Load pi_data → output bit[WIDTH-1] first, shift left, bit[0] last
- **SIPO**：先将 bit[WIDTH-1] 移入移位寄存器，MSB→LSB 组装 / Receive bit[WIDTH-1] first into shift reg, assemble MSB→LSB

## 仿真结果 | Simulation

运行命令 / Run: `cd sim && vsim -do batch.do`

| 测试项 Test Item | 说明 Description |
|:---|:---|
| SIPO 接收 SIPO Receive | 接收 0xA5 (10100101) / Receive 0xA5 (10100101) |
| SIPO 接收 SIPO Receive | 接收 0x3C (00111100) / Receive 0x3C (00111100) |
| PISO 发送 PISO Send | 发送 0x55 (01010101) / Send 0x55 (01010101) |
| 回环测试 Loopback | SIPO ← 0xA5 → PISO → 验证 0xA5 / SIPO ← 0xA5 → PISO → 0xA5 verified |

## 涉及技能 | Skills Demonstrated

- 移位寄存器设计 / Shift register design
- 串行协议基础 / Serial protocol fundamentals
- SIPO/PISO 状态机 / SIPO / PISO state machines
- 回环测试方法 / Loopback test methodology
- 参数化位宽 / Parameterized bit-width
