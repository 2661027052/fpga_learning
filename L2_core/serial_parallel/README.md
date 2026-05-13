# Serial-Parallel Converter

## Module Overview | 模块概述

Bidirectional serial-parallel converter combining SIPO (Serial-In Parallel-Out) and PISO (Parallel-In Serial-Out) in one module. MSB-first data ordering. Parameterized width.

双向串并转换模块，集成 SIPO（串入并出）和 PISO（并入串出）。MSB 优先，参数化位宽。

## Interface | 接口说明

### SIPO (串转并)

| Port | Width | Dir | Description |
|------|-------|-----|-------------|
| si_data | 1 | I | Serial data input (MSB first) |
| si_valid | 1 | I | Serial input valid (pulse per bit) |
| po_data | WIDTH | O | Parallel data output |
| po_valid | 1 | O | Parallel output valid (1-cycle pulse when full) |

### PISO (并转串)

| Port | Width | Dir | Description |
|------|-------|-----|-------------|
| pi_data | WIDTH | I | Parallel data to serialize |
| pi_load | 1 | I | Load signal (starts serial output) |
| so_data | 1 | O | Serial data output (MSB first) |
| so_valid | 1 | O | High during serial transmission |

## Parameters | 参数

| Parameter | Default | Description |
|-----------|---------|-------------|
| WIDTH | 8 | Data bit width |

## Data Order | 数据顺序

- **MSB first**: Highest bit (bit[WIDTH-1]) transmitted/received first
- PISO: Load pi_data → output bit[WIDTH-1] first, shift left, bit[0] last
- SIPO: Receive bit[WIDTH-1] first into shift reg, assemble MSB→LSB

## Simulation | 仿真结果

Run: `cd sim && vsim -do batch.do`

Test items:
1. SIPO receive 0xA5 (10100101)
2. SIPO receive 0x3C (00111100)
3. PISO send 0x55 (01010101)
4. Loopback: SIPO ← 0xA5 → PISO → 0xA5 verified

## Skills Demonstrated | 涉及技能

- Shift register design
- Serial protocol fundamentals
- SIPO / PISO state machines
- Loopback test methodology
- Parameterized bit-width
