# Traffic Light FSM Controller

## Module Overview | 模块概述

Three-stage Moore FSM traffic light controller with one-hot encoding. Controls 4 states: NS Green → NS Yellow → EW Green → EW Yellow → loop.

三段式 Moore 状态机交通灯控制器，独热码编码。4 状态循环：南北绿 → 南北黄 → 东西绿 → 东西黄 → 循环。

## Interface | 接口说明

| Port | Width | Dir | Description |
|------|-------|-----|-------------|
| clk | 1 | I | System clock |
| rst_n | 1 | I | Async reset (active low) |
| ns_green/yellow/red | 1 | O | North-South lights |
| ew_green/yellow/red | 1 | O | East-West lights |
| cnt_out | 6 | O | Countdown value (for debug) |

## Parameters | 参数

| Parameter | Default | Description |
|-----------|---------|-------------|
| TIME_GREEN | 60 | Green light duration (cycles) |
| TIME_YELLOW | 5 | Yellow light duration (cycles) |

## Design Highlights | 设计要点

- **3-stage FSM**: State register (seq) + Next-state logic (comb) + Output logic (seq)
- **One-hot encoding**: 4 states, 4 bits — fast decoding, FPGA-friendly
- **Moore type**: Outputs depend only on current state — glitch-free
- **Off-by-one fix**: Counter starts from time_limit-1, exact N cycles per state
- **Safe recovery**: default branch returns to S_GREEN on illegal state

## Simulation | 仿真结果

Run: `cd sim && vsim -do batch.do`

Test items:
1. Reset → S_GREEN (NS green on)
2. S_GREEN → S_YELLOW after TIME_GREEN cycles
3. S_YELLOW → E_GREEN
4. E_GREEN → E_YELLOW
5. E_YELLOW → S_GREEN (full cycle)
6. Mutual exclusion: NS and EW never green simultaneously
7. Reset recovery

## Skills Demonstrated | 涉及技能

- FSM design (3-stage, Moore, one-hot)
- Counter design (off-by-one avoidance)
- Mutual exclusion logic
- Parameterized timing control
