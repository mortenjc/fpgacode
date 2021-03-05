// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief a 50MHz to 100Hz and 5MHz divider
//===----------------------------------------------------------------------===//

module clockdiv(
  input bit clk_in,
  input bit ext_sel,
  output bit clk_slow,
  output bit clk_fast
  );

  parameter CLK_HZ = 50000000;  // 50MHz
  parameter FAST_HZ = 5000000;  // 5MHz
  parameter SLOW_HZ = 100;

  parameter TICKS_FAST = CLK_HZ / FAST_HZ; // 10 ticks per divided clock
  parameter TICKS_SLOW = CLK_HZ / SLOW_HZ; // 500000 ticks per slow clock
  parameter FAST_MAX = TICKS_FAST - 1;
  parameter SLOW_MAX = TICKS_SLOW - 1;

  parameter EXT_CLK_HZ =  6553600; // 6.5536MHz

  parameter EXT_TICKS_SLOW = EXT_CLK_HZ / SLOW_HZ; // 65536 ticks per slow clock
  parameter EXT_SLOW_MAX = EXT_TICKS_SLOW - 1;

  bit [31:0] fast_max;
  bit [31:0] slow_max;

  bit [31:0] cnt_fast;
  bit new_fast;

  bit [31:0] cnt_slow;
  bit new_slow;

  always_comb begin
    if (ext_sel) begin
      fast_max = FAST_MAX;
      slow_max = EXT_SLOW_MAX;
    end else begin
      fast_max = FAST_MAX;
      slow_max = SLOW_MAX;
    end
  end

  /* verilator lint_off BLKSEQ */
  always_ff @(posedge clk_in) begin
    //$display("cnt_fast %d, cnt_slow %d", cnt_fast, cnt_slow);
    if (cnt_fast == fast_max) begin
      cnt_fast = 0;
      new_fast = 1;
    end else begin
      cnt_fast++;
      new_fast = 0;
    end

    if (cnt_slow == slow_max) begin
      cnt_slow = 0;
      new_slow = 1;
    end else begin
      cnt_slow++;
      new_slow = 0;
    end

	  clk_slow <= new_slow;
	  clk_fast <= new_fast;
  end
  /* verilator lint_on BLKSEQ */
endmodule
