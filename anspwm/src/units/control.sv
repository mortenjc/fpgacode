// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief user control - implemented by mechanical switches
/// INPUTS
/// sw9   - select display - 0:  display PWM value, 1: show contributions
/// sw8   - select clock source: 0 clock a, 1: clock b
/// sw7-6 - select byte position for user configurable value
/// sw5-0 - six bit user value - will be shifted left 2 bits to make a 8 bit val
/// ext_clk_sel - single bit external clock select
//===----------------------------------------------------------------------===//


module control (
  input bit [9:0] sw,
  input bit ext_clk_sel,
  output bit [1:0] clk_sel,
  output [31:0] target
  );

  assign clk_sel = {sw[8], ext_clk_sel};
  bit [7:0] value;

  // 1'234'554'321 = 0x4995CDD1
  always_comb begin
	 value = {sw[5:0], 2'b0};
	 unique case (sw[7:6])
    0: target = {32'h4995CDD1};
    1: target = {16'h4995, value, 8'hD1};
    2: target = {8'h49, value, 16'hCDD1};
    3: target = {     value, 24'h95CDD1};
	 endcase
  end


endmodule
