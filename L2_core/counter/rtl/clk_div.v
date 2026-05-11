// 偶数分频器 — 计数器实现50%占空比时钟分频
// 输出频率 = 输入频率 / (2 * DIV_FACTOR)

module clk_div #(
    parameter DIV_FACTOR = 5    // 分频因子（半周期 = DIV_FACTOR个输入时钟）
)(
    input  wire clk_in,          // 输入时钟
    input  wire rst_n,           // 异步复位（低有效）
    output reg  clk_out          // 输出时钟（50%占空比）
);

    reg [31:0] cnt;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 32'd0;
            clk_out <= 1'b0;
        end
        else begin
            if (cnt == DIV_FACTOR - 1) begin
                cnt     <= 32'd0;
                clk_out <= ~clk_out;   // 每DIV_FACTOR个时钟翻转一次
            end
            else begin
                cnt <= cnt + 32'd1;
            end
        end
    end

endmodule
