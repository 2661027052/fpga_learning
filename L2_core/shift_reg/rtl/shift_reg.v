// SPDX-License-Identifier: MIT  Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// 8位通用移位寄存器 — 时序逻辑电路
// 支持：左移、右移、并行加载、保持、串行输入/输出

module shift_reg #(
    parameter WIDTH = 8
)(
    input  wire                 clk,         // 时钟
    input  wire                 rst_n,       // 异步复位（低有效）
    input  wire                 en,          // 移位使能
    input  wire [1:0]           mode,        // 00=保持, 01=左移, 10=右移, 11=并行加载
    input  wire [WIDTH-1:0]     d,           // 并行加载数据
    input  wire                 si_left,     // 左移时串行输入（补低位）
    input  wire                 si_right,    // 右移时串行输入（补高位）
    output reg  [WIDTH-1:0]     q,           // 移位寄存器输出
    output wire                 so_left,     // 左移串行输出（高位溢出）
    output wire                 so_right     // 右移串行输出（低位溢出）
);

    localparam MODE_HOLD = 2'b00;
    localparam MODE_SHL  = 2'b01;
    localparam MODE_SHR  = 2'b10;
    localparam MODE_LOAD = 2'b11;

    assign so_left  = q[WIDTH-1];
    assign so_right = q[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= {WIDTH{1'b0}};
        else if (en) begin
            case (mode)
                MODE_SHL:  q <= {q[WIDTH-2:0], si_left};
                MODE_SHR:  q <= {si_right, q[WIDTH-1:1]};
                MODE_LOAD: q <= d;
                default:   q <= q;
            endcase
        end
    end

endmodule
