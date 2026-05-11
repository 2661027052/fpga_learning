// Shift Register testbench
`timescale 1ns / 1ps

module tb_shift_reg;

    parameter WIDTH = 8;

    reg             clk, rst_n, en;
    reg  [1:0]      mode;
    reg  [WIDTH-1:0] d;
    reg             si_left, si_right;
    wire [WIDTH-1:0] q;
    wire            so_left, so_right;

    integer pass, fail;

    shift_reg #(.WIDTH(WIDTH)) uut (
        .clk(clk), .rst_n(rst_n), .en(en), .mode(mode),
        .d(d), .si_left(si_left), .si_right(si_right),
        .q(q), .so_left(so_left), .so_right(so_right)
    );

    always #5 clk = ~clk;

    task check;
        input [255:0] name;
        input [WIDTH-1:0] exp_q;
        begin
            @(posedge clk); #1;
            if (q === exp_q) begin
                $display("[PASS] %s: q=%b", name, q); pass = pass + 1;
            end
            else begin
                $display("[FAIL] %s: q=%b, expected %b", name, q, exp_q); fail = fail + 1;
            end
        end
    endtask

    initial begin
        pass = 0; fail = 0;
        clk = 0; rst_n = 0; en = 0; mode = 0; d = 0; si_left = 0; si_right = 0;

        repeat (5) @(posedge clk);
        rst_n <= 1; en <= 1;
        repeat (2) @(posedge clk);

        // 并行加载
        $display("--- Load ---");
        mode <= 2'b11; d <= 8'b1010_0110;
        check("LOAD: 0xA6", 8'b1010_0110);

        // 左移
        $display("--- Shift Left ---");
        mode <= 2'b01; si_left <= 1'b1;
        check("SHL[1]: +1", 8'b0100_1101);
        check("SHL[2]: +1", 8'b1001_1011);
        si_left <= 1'b0;
        check("SHL[3]: +0", 8'b0011_0110);

        @(posedge clk); #1;
        if (so_left === 1'b0) $display("[PASS] SO_LEFT");
        else begin $display("[FAIL] SO_LEFT=%b", so_left); fail = fail + 1; end
        pass = pass + 1;

        // 右移
        $display("--- Shift Right ---");
        mode <= 2'b11; d <= 8'b1010_0110;
        check("RELOAD", 8'b1010_0110);

        mode <= 2'b10; si_right <= 1'b1;
        check("SHR[1]: +1", 8'b1101_0011);
        check("SHR[2]: +1", 8'b1110_1001);
        si_right <= 1'b0;
        check("SHR[3]: +0", 8'b0111_0100);

        @(posedge clk); #1;
        if (so_right === 1'b0) $display("[PASS] SO_RIGHT");
        else begin $display("[FAIL] SO_RIGHT=%b", so_right); fail = fail + 1; end
        pass = pass + 1;

        // 保持
        $display("--- Hold ---");
        mode <= 2'b00;
        repeat (3) @(posedge clk); #1;
        if (q === 8'b0011_1010) $display("[PASS] HOLD: unchanged");
        else begin $display("[FAIL] HOLD: changed to %b", q); fail = fail + 1; end
        pass = pass + 1;

        // 复位
        $display("--- Reset ---");
        rst_n <= 0;
        @(posedge clk); #1;
        if (q === 8'd0) $display("[PASS] RST: zero");
        else begin $display("[FAIL] RST: q=%d", q); fail = fail + 1; end
        pass = pass + 1;

        $display("======================================");
        $display("Shift Reg: %d passed, %d failed", pass, fail);
        $display("======================================");
        $finish;
    end

endmodule
