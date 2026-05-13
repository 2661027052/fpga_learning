// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// 偶数分频器 — 计数器实现50%占空比时钟分频
// 输出频率 = 输入频率 / (2 * DIV_FACTOR)

module clk_div
    #(
    parameter DIV_FACTOR = 5      // 分频因子（半周期 = DIV_FACTOR个输入时钟）
    )
    (
    input  wire clk_in,            // 输入时钟
    input  wire rst_n,             // 异步复位（低有效）
    output reg  clk_out            // 输出时钟（50%占空比）
    );

    localparam CNT_W = (DIV_FACTOR <= 1) ? 1 : $clog2(DIV_FACTOR);  // 计数器位宽
    reg [CNT_W-1:0] cnt;           // 分频计数器

    //============ Divider Counter Logic ============
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= {CNT_W{1'b0}};
            clk_out <= 1'b0;
        end
        else begin
            if (cnt == DIV_FACTOR - 1) begin
                cnt     <= {CNT_W{1'b0}};
                clk_out <= ~clk_out;   // 每DIV_FACTOR个时钟翻转一次
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule
