# 交通灯 FSM 控制器 | Traffic Light FSM Controller

## 模块概述 | Module Overview

三段式 Moore 状态机交通灯控制器，独热码编码。4 状态循环：南北绿 → 南北黄 → 东西绿 → 东西黄 → 循环。

Three-stage Moore FSM traffic light controller with one-hot encoding. Controls 4 states: NS Green → NS Yellow → EW Green → EW Yellow → loop.

## 接口说明 | Interface

| 端口 Port | 位宽 Width | 方向 Dir | 说明 Description |
|:---|:---:|:---:|:---|
| clk | 1 | I | 系统时钟 / System clock |
| rst_n | 1 | I | 异步复位（低电平有效）/ Async reset (active low) |
| ns_green / yellow / red | 1 | O | 南北方向指示灯 / North-South lights |
| ew_green / yellow / red | 1 | O | 东西方向指示灯 / East-West lights |
| cnt_out | 6 | O | 倒计时值（调试用）/ Countdown value (for debug) |

## 参数 | Parameters

| 参数 Parameter | 默认值 Default | 说明 Description |
|:---|:---:|:---|
| TIME_GREEN | 60 | 绿灯持续时间（时钟周期数）/ Green light duration (cycles) |
| TIME_YELLOW | 5 | 黄灯持续时间（时钟周期数）/ Yellow light duration (cycles) |

## 设计要点 | Design Highlights

- **三段式状态机 / 3-stage FSM**：状态寄存器（时序）+ 次态逻辑（组合）+ 输出逻辑（时序） / State register (seq) + Next-state logic (comb) + Output logic (seq)
- **独热码编码 / One-hot encoding**：4 状态、4 bit — 译码快、FPGA 友好 / 4 states, 4 bits — fast decoding, FPGA-friendly
- **Moore 型 / Moore type**：输出仅取决于当前状态 — 无毛刺 / Outputs depend only on current state — glitch-free
- **Off-by-one 修正 / Off-by-one fix**：计数器从 time_limit-1 开始，每个状态精确 N 周期 / Counter starts from time_limit-1, exact N cycles per state
- **安全恢复 / Safe recovery**：非法状态时 default 分支回到 S_GREEN / default branch returns to S_GREEN on illegal state

## 仿真结果 | Simulation

运行命令 / Run: `cd sim && vsim -do batch.do`

| 测试项 Test Item | 说明 Description |
|:---|:---|
| 复位 → S_GREEN Reset → S_GREEN | NS 绿灯亮 / NS green on |
| S_GREEN → S_YELLOW | TIME_GREEN 周期后切换 / Transition after TIME_GREEN cycles |
| S_YELLOW → E_GREEN | 黄灯 → 东西绿灯 / Yellow → EW green |
| E_GREEN → E_YELLOW | 东西绿灯 → 东西黄灯 / EW green → EW yellow |
| E_YELLOW → S_GREEN（完整循环）| 返回起始状态 / Return to start state, full cycle |
| 互斥 Mutual Exclusion | NS 和 EW 不会同时绿灯 / NS and EW never green simultaneously |
| 复位恢复 Reset Recovery | 任意状态复位后回到 S_GREEN / Return to S_GREEN on reset from any state |

## 涉及技能 | Skills Demonstrated

- FSM 设计（三段式、Moore、独热码）/ FSM design (3-stage, Moore, one-hot)
- 计数器设计（避免 Off-by-one）/ Counter design (off-by-one avoidance)
- 互斥逻辑 / Mutual exclusion logic
- 参数化定时控制 / Parameterized timing control
