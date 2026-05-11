# 计数器与分频器 (Counter & Clock Divider)

> 时序逻辑基础构件。L2 核心技能：时序逻辑电路设计。
>
> Sequential logic building blocks. L2 core skill: sequential logic design.

## counter.v — 可配置计数器 (Configurable Counter)

**功能**：递增/递减计数、计数使能、并行加载、溢出标志、边界检测。

### 状态转移表 (State Table)

| 条件 | 下一值 | ovf |
|------|--------|-----|
| UP, q < MAX | q + 1 | 0 |
| UP, q == MAX | 0（溢出回绕） | 1 |
| DOWN, q > 0 | q - 1 | 0 |
| DOWN, q == 0 | MAX（下溢回绕） | 1 |
| load=1 | d（加载初值） | 0 |
| en=0 | 保持 | 0 |

## clk_div.v — 偶数分频器 (Even Clock Divider)

50% 占空比。f_out = f_in / (2 × DIV_FACTOR)。

示例：50MHz 输入，DIV_FACTOR=5 → 5MHz 输出。

## 仿真 (Simulation)

```bash
vlog counter/rtl/counter.v counter/rtl/clk_div.v counter/sim/tb_counter.v
vsim -c tb_counter -do "run -all; quit"
vsim -c tb_clk_div -do "run -all; quit"
```

## 测试覆盖 (Test Coverage)

- 递增：正常递增、溢出回绕、溢出后继续计数
- 递减：正常递减、下溢回绕
- 加载：中途并行加载初值
- 使能关闭：值保持不变
- at_max / at_zero：边界标志正确置位
- 分频器：DIV_FACTOR=4 频率验证（50MHz→6.25MHz）
