# 计数器与分频器 | Counter & Clock Divider

> 时序逻辑基础构件。L2 核心技能：时序逻辑电路设计。
>
> Sequential logic building blocks. L2 core skill: sequential logic design.

## counter.v — 可配置计数器 | Configurable Counter

**功能 / Function**：递增/递减计数、计数使能、并行加载、溢出标志、边界检测。
Increment/decrement counting, count enable, parallel load, overflow flag, boundary detection.

### 状态转移表 | State Table

| 条件 Condition | 下一值 Next Value | ovf |
|:---|---|:---:|
| UP, q < MAX | q + 1 | 0 |
| UP, q == MAX | 0（溢出回绕 / Overflow wrap） | 1 |
| DOWN, q > 0 | q - 1 | 0 |
| DOWN, q == 0 | MAX（下溢回绕 / Underflow wrap） | 1 |
| load=1 | d（加载初值 / Load initial value） | 0 |
| en=0 | 保持 / Hold | 0 |

## clk_div.v — 偶数分频器 | Even Clock Divider

50% 占空比 / 50% duty cycle。

**分频公式 / Division formula**：f_out = f_in / (2 x DIV_FACTOR)

**示例 / Example**：50MHz 输入，DIV_FACTOR=5 → 5MHz 输出。
50 MHz input, DIV_FACTOR=5 → 5 MHz output.

## 仿真 | Simulation

运行命令 / Run commands:

```bash
vlog counter/rtl/counter.v counter/rtl/clk_div.v counter/sim/tb_counter.v
vsim -c tb_counter -do "run -all; quit"
vsim -c tb_clk_div -do "run -all; quit"
```

## 测试覆盖 | Test Coverage

| 测试项 Test Item | 说明 Description |
|:---|:---|
| 递增 Increment | 正常递增、溢出回绕、溢出后继续计数 / Normal increment, overflow wrap, continue after overflow |
| 递减 Decrement | 正常递减、下溢回绕 / Normal decrement, underflow wrap |
| 加载 Load | 中途并行加载初值 / Parallel load mid-count |
| 使能关闭 Enable Off | 值保持不变 / Value holds steady |
| 边界标志 Boundary Flags | at_max / at_zero 正确置位 / Flags assert correctly |
| 分频器 Clock Divider | DIV_FACTOR=4 频率验证（50MHz→6.25MHz）/ Frequency verification (50MHz→6.25MHz) |
