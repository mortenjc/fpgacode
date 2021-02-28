// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief clock multiplexer - select between clocks a and b
//===----------------------------------------------------------------------===//

module clocksel(
  input sel,     // single step or automatic
  input clk_a,   // push button single step clock
  input clk_b,   // 100Hz derived from DE10-Lite board clock (50MHz) or external 6.5536MHz
  output clk_out
  );

  always_comb begin
    if (sel == 0)
	   clk_out = clk_a;
    else
	   clk_out = clk_b; 
  end

endmodule
