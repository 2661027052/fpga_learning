// SPDX-License-Identifier: MIT  Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// 可配置N位计数器 — 时序逻辑电路
// 支持：递增/递减、计数使能、加载初值、溢出标志

module counter #(
    parameter WIDTH = 8           // 计数器位宽
)(
    input  wire                 clk,       // 时钟
    input  wire                 rst_n,     // 异步复位（低有效）
    input  wire                 en,        // 计数使能
    input  wire                 up_down,   // 1=递增, 0=递减
    input  wire                 load,      // 加载初值使能
    input  wire [WIDTH-1:0]     d,         // 加载初值
    output reg  [WIDTH-1:0]     q,         // 计数值输出
    output reg                  ovf,       // 溢出标志
    output wire                 at_max,    // 计数值==全1
    output wire                 at_zero    // 计数值==0
);

    assign at_max  = (q == {WIDTH{1'b1}});
    assign at_zero = (q == {WIDTH{1'b0}});

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q   <= {WIDTH{1'b0}};
            ovf <= 1'b0;
        end
        else if (load) begin
            q   <= d;
            ovf <= 1'b0;
        end
        else if (en) begin
            if (up_down) begin
                if (q == {WIDTH{1'b1}}) begin
                    q   <= {WIDTH{1'b0}};   // 溢出回绕
                    ovf <= 1'b1;
                end
                else begin
                    q   <= q + 1'b1;
                    ovf <= 1'b0;
                end
            end
            else begin
                if (q == {WIDTH{1'b0}}) begin
                    q   <= {WIDTH{1'b1}};   // 下溢回绕
                    ovf <= 1'b1;
                end
                else begin
                    q   <= q - 1'b1;
                    ovf <= 1'b0;
                end
            end
        end
        else begin
            ovf <= 1'b0;
        end
    end

endmodule
