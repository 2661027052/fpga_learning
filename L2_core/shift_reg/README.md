# 移位寄存器 | Shift Register

> 8 位通用移位寄存器。L2 核心技能：时序逻辑电路设计。
>
> 8-bit universal shift register. L2 core skill: sequential logic design.

## 功能 | Operations

| mode[1:0] | 操作 Operation | 行为 Behavior |
|:---:|:---|:---|
| 00 | 保持 / Hold | q 不变 / q unchanged |
| 01 | 左移 / Shift Left | q <= {q[6:0], si_left}，so_left=q[7] |
| 10 | 右移 / Shift Right | q <= {si_right, q[7:1]}，so_right=q[0] |
| 11 | 并行加载 / Load | q <= d |

## 框图 | Block Diagram

```
  si_right ──────────┐
                     ▼
   d[7:0] ──►┌──────────────┐──► q[7:0]
  si_left ──►│  移位寄存器   │──► so_left (q[7])
    en ─────►│   8-bit      │──► so_right (q[0])
  mode[1:0]─►│  Shift Reg   │
    clk ────►│              │
   rst_n ───►└──────────────┘
```

## 仿真 | Simulation

运行命令 / Run commands:

```bash
vlog shift_reg/rtl/shift_reg.v shift_reg/sim/tb_shift_reg.v
vsim -c tb_shift_reg -do "run -all; quit"
```

## 测试覆盖 | Test Coverage

| 测试项 Test Item | 说明 Description |
|:---|:---|
| 并行加载 Parallel Load | 加载 0xA6 验证 / Load 0xA6 and verify |
| 左移 Shift Left | 3 周期，交替 si_left，验证 so_left 串行输出 / 3 cycles, toggle si_left, verify so_left serial output |
| 右移 Shift Right | 3 周期，交替 si_right，验证 so_right 串行输出 / 3 cycles, toggle si_right, verify so_right serial output |
| 保持 Hold | mode=00 时 3 周期值不变 / 3 cycles with mode=00, value unchanged |
| 复位 Reset | 异步清零验证 / Verify async clear |
