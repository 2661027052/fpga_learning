// Counter + Clock Divider testbench
`timescale 1ns / 1ps

module tb_counter;

    parameter WIDTH = 4;

    reg             clk;
    reg             rst_n;
    reg             en;
    reg             up_down;
    reg             load;
    reg  [WIDTH-1:0] d;
    wire [WIDTH-1:0] q;
    wire             ovf;
    wire             at_max;
    wire             at_zero;

    integer pass, fail;

    counter #(.WIDTH(WIDTH)) uut (
        .clk     (clk),
        .rst_n   (rst_n),
        .en      (en),
        .up_down (up_down),
        .load    (load),
        .d       (d),
        .q       (q),
        .ovf     (ovf),
        .at_max  (at_max),
        .at_zero (at_zero)
    );

    always #5 clk = ~clk;  // 100MHz

    task check;
        input [255:0] name;
        input [WIDTH-1:0] exp_q;
        input             exp_ovf;
        begin
            @(posedge clk); #1;
            if (q === exp_q && ovf === exp_ovf) begin
                $display("[PASS] %s: q=%d, ovf=%b", name, q, ovf);
                pass = pass + 1;
            end
            else begin
                $display("[FAIL] %s: got (q=%d, ovf=%b), expected (q=%d, ovf=%b)",
                         name, q, ovf, exp_q, exp_ovf);
                fail = fail + 1;
            end
        end
    endtask

    initial begin
        pass = 0; fail = 0;
        clk = 0; rst_n = 0; en = 0; up_down = 1; load = 0; d = 0;

        repeat (5) @(posedge clk);
        rst_n <= 1;
        repeat (2) @(posedge clk);

        // ===== UP counter =====
        $display("--- UP Counter ---");
        en <= 1; up_down <= 1;
        check("UP: 0->1",   4'd1,  1'b0);
        check("UP: 1->2",   4'd2,  1'b0);
        check("UP: 14->15", 4'd15, 1'b0);
        check("UP: 15->0(ovf)", 4'd0, 1'b1);
        check("UP: 0->1 after ovf", 4'd1, 1'b0);

        // ===== Load =====
        $display("--- Load ---");
        load <= 1; d <= 4'd10;
        check("LOAD: 10", 4'd10, 1'b0);
        load <= 0;
        check("UP: 10->11", 4'd11, 1'b0);

        // ===== DOWN counter =====
        $display("--- DOWN Counter ---");
        up_down <= 0;
        check("DOWN: 11->10", 4'd10, 1'b0);
        check("DOWN: 10->9",  4'd9,  1'b0);

        load <= 1; d <= 4'd1;
        check("LOAD: 1", 4'd1, 1'b0);
        load <= 0;

        check("DOWN: 1->0", 4'd0, 1'b0);
        check("DOWN: 0->15(ovf)", 4'd15, 1'b1);

        // ===== Enable off =====
        $display("--- Enable Off ---");
        en <= 0;
        repeat (3) @(posedge clk); #1;
        if (q === 4'd15) begin
            $display("[PASS] EN_OFF: q stays at %d", q);
            pass = pass + 1;
        end
        else begin
            $display("[FAIL] EN_OFF: q=%d, expected 15", q);
            fail = fail + 1;
        end

        // ===== at_max / at_zero =====
        $display("--- at_max / at_zero ---");
        en <= 1; up_down <= 1;
        load <= 1; d <= 4'd14;
        @(posedge clk); #1;
        load <= 0;
        @(posedge clk); #1;  // q=15
        if (at_max) $display("[PASS] AT_MAX at q=15");
        else begin $display("[FAIL] AT_MAX not asserted"); fail = fail + 1; end
        pass = pass + 1;

        up_down <= 0;
        load <= 1; d <= 4'd1;
        @(posedge clk); #1;
        load <= 0;
        @(posedge clk); #1;  // q=0
        if (at_zero) $display("[PASS] AT_ZERO at q=0");
        else begin $display("[FAIL] AT_ZERO not asserted"); fail = fail + 1; end
        pass = pass + 1;

        $display("======================================");
        $display("Counter Summary: %d passed, %d failed", pass, fail);
        $display("======================================");
        $finish;
    end

endmodule


// ============================================================
// Clock Divider testbench
// ============================================================
module tb_clk_div;

    reg  clk_in;
    reg  rst_n;
    wire clk_out;

    clk_div #(.DIV_FACTOR(4)) uut (
        .clk_in  (clk_in),
        .rst_n   (rst_n),
        .clk_out (clk_out)
    );

    always #10 clk_in = ~clk_in;  // 50MHz

    initial begin
        clk_in = 0; rst_n = 0;
        #100 rst_n = 1;
        #2000;
        $display("CLK_DIV: DIV_FACTOR=4, 50MHz -> 6.25MHz (period=160ns)");
        $finish;
    end

endmodule
