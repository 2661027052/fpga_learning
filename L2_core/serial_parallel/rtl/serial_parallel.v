// SPDX-License-Identifier: LicenseRef-Custom-Source-Available
// Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用

// 串并/并串转换模块
module serial_parallel #(
    parameter WIDTH = 8                      // 数据位宽
    )
    (
    input  wire                  clk,        // 系统时钟
    input  wire                  rst_n,      // 异步复位，低有效

    //===== 串转并（SIPO）接口 =====
    input  wire                  si_data,    // 串行数据输入
    input  wire                  si_valid,   // 串行输入有效（每个bit一个脉冲）
    output reg  [WIDTH-1:0]      po_data,    // 并行数据输出
    output reg                   po_valid,   // 并行输出有效（收满WIDTH位时置1）

    //===== 并转串（PISO）接口 =====
    input  wire [WIDTH-1:0]      pi_data,    // 并行数据输入
    input  wire                  pi_load,    // 并行加载使能
    output reg                   so_data,    // 串行数据输出
    output reg                   so_valid    // 串行输出有效（移位期间为1，完成后归0）
    );

//============ 串转并（SIPO）：移位寄存器 ============
reg [WIDTH-1:0]             sipo_shift;     // 移位寄存器，逐位接收
reg [$clog2(WIDTH)-1:0]     sipo_cnt;       // 已接收bit计数（0~WIDTH）

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sipo_shift <= {WIDTH{1'b0}};
        sipo_cnt   <= 'd0;
        po_data    <= {WIDTH{1'b0}};
        po_valid   <= 1'b0;
    end
    else begin
        po_valid <= 1'b0;                   // 默认无效（脉冲信号）
        if (si_valid) begin
            sipo_shift <= {sipo_shift[WIDTH-2:0], si_data};
            // 收满WIDTH位时输出并行数据，否则继续计数
            if (sipo_cnt == WIDTH - 1'b1) begin
                po_data  <= {sipo_shift[WIDTH-2:0], si_data};
                po_valid <= 1'b1;
                sipo_cnt <= 'd0;
            end else begin
                sipo_cnt <= sipo_cnt + 1'b1;
            end
        end
    end
end

//============ 并转串（PISO）：加载+移位 ============
reg [WIDTH-1:0]             piso_shift;     // 移位寄存器，逐位送出
reg [$clog2(WIDTH)-1:0]     piso_cnt;       // 已发送bit计数（0~WIDTH）
reg                         piso_active;    // 正在发送标志

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        piso_shift  <= {WIDTH{1'b0}};
        piso_cnt    <= 'd0;
        piso_active <= 1'b0;
        so_data     <= 1'b0;
        so_valid    <= 1'b0;
    end
    else begin
        if (pi_load && !piso_active) begin
            // 加载并行数据，最高位先出
            piso_shift  <= pi_data;
            piso_cnt    <= 'd0;
            piso_active <= 1'b1;
            so_data     <= pi_data[WIDTH-1];                          // 最高位先出（MSB first）
            so_valid    <= 1'b1;
        end
        else if (piso_active) begin
            if (piso_cnt == WIDTH - 1'b1) begin
                // 全部发完
                piso_active <= 1'b0;
                so_valid    <= 1'b0;
            end
            else begin
                // 左移：次高位→最高位，逐位移出
                piso_shift <= piso_shift << 1;
                so_data    <= piso_shift[WIDTH-2];                       // 下一个bit
                piso_cnt   <= piso_cnt + 1'b1;
            end
        end
        else begin
            so_valid <= 1'b0;
        end
    end
end

endmodule
