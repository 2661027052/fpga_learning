# 单比特 CDC 跨时钟域

## 问题

> 单比特信号如何从慢时钟域跨到快时钟域？如何从快跨到慢？写出关键代码。

> 难度: ★ | 频率: 必问 | 层级: L1

## 结论

慢→快用两级同步器；快→慢用脉冲同步器（翻转法）：脉冲→电平→同步→边沿检测→恢复脉冲。

## 慢→快：两级同步器

条件: $f_{fast} \ge 2 \times f_{slow}$，数据每次变化保持至少一个慢时钟周期。

```verilog
reg sync1, sync2;
always @(posedge clk_fast) begin
    sync1 <= slow_data;   // 第一级
    sync2 <= sync1;       // 第二级
end
```

## 快→慢：脉冲同步器（翻转法）

问题：快域短脉冲可能落在慢时钟采样间隔内 → 完全漏采。

解法：脉冲 → 电平翻转 → 两级同步电平 → 边沿检测 → 恢复脉冲

```verilog
// 快域：脉冲翻转电平
always @(posedge clk_fast)
    if (pulse_in) toggle <= ~toggle;

// 慢域：两级同步 + 边沿检测
always @(posedge clk_slow) begin
    sync1 <= toggle; sync2 <= sync1; delay <= sync2;
end
assign pulse_out = sync2 ^ delay;
```

## 总结表

| 场景 | 信号类型 | 方法 |
|------|---------|------|
| 慢→快 | 电平/脉冲 | 两级同步器 |
| 快→慢 | 电平信号 | 两级同步器（宽度>2周期） |
| 快→慢 | 脉冲信号 | 脉冲同步器（翻转法） |
| 快→慢 | 连续脉冲 | 异步FIFO/握手 |

## 面试追问

Q: 快→慢为什么不能直接两级同步脉冲？
A: 慢时钟可能完全看不到。例如 200MHz 快脉冲 5ns，50MHz 慢时钟周期 20ns，脉冲在两个采样沿之间升起又消失 → 完全丢失。
