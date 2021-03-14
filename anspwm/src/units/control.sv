// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief user control - implemented by mechanical switches
/// INPUTS
/// sw9   - select display - 0:  display PWM value, 1: show contributions
/// sw8   - select clock source: 0 clock a, 1: clock b
/// sw7-6 - unused
/// sw5-0 - six bit user value selecting 1uV steps around 1V
//===----------------------------------------------------------------------===//

module control (
  input bit [9:0] sw,
  input bit ext_clk_sel,
  output bit [1:0] clk_sel,
  output [31:0] target
  );

  assign clk_sel = {sw[8], ext_clk_sel};

  target1v target1v_i(
  .value(sw[5:0]),
  .target(target)
  );

endmodule
