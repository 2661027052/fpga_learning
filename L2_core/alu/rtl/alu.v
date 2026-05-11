// SPDX-License-Identifier: LicenseRef-Custom-Source-Available  Copyright (c) 2026 2661027052  仅供学习参考，不保证生产环境可用
// 8-bit ALU — 组合逻辑电路，支持9种运算
// L2 核心技能：组合逻辑电路设计

module alu #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,        // 操作数A
    input  wire [WIDTH-1:0] b,        // 操作数B
    input  wire [3:0]       op,       // 操作码（9种运算）
    output wire [WIDTH-1:0] result,   // 运算结果
    output wire             zero,     // 零标志：result == 0
    output wire             carry     // 进位标志：ADD/SUB时产生进位/借位
);

    localparam OP_ADD = 4'b0000;  // 加法
    localparam OP_SUB = 4'b0001;  // 减法
    localparam OP_MUL = 4'b0010;  // 乘法
    localparam OP_AND = 4'b0011;  // 按位与
    localparam OP_OR  = 4'b0100;  // 按位或
    localparam OP_XOR = 4'b0101;  // 按位异或
    localparam OP_SLT = 4'b0110;  // 小于比较（有符号）
    localparam OP_SRL = 4'b0111;  // 逻辑右移
    localparam OP_SLL = 4'b1000;  // 逻辑左移

    reg [WIDTH:0] extended;  // 扩展1位缓冲进位/借位

    always @(*) begin
        extended = 9'd0;
        case (op)
            OP_ADD: extended = {1'b0, a} + {1'b0, b};
            OP_SUB: extended = {1'b0, a} - {1'b0, b};
            OP_MUL: extended = a * b;
            OP_AND: extended = {1'b0, a & b};
            OP_OR:  extended = {1'b0, a | b};
            OP_XOR: extended = {1'b0, a ^ b};
            OP_SLT: extended = ($signed(a) < $signed(b)) ? 9'd1 : 9'd0;
            OP_SRL: extended = {1'b0, a >> b[2:0]};
            OP_SLL: extended = {1'b0, a << b[2:0]};
            default: extended = 9'd0;
        endcase
    end

    assign result = extended[WIDTH-1:0];
    assign carry  = extended[WIDTH];
    assign zero   = (result == 8'd0);

endmodule
