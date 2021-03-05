// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief clock multiplexer - select between clocks a and b
//===----------------------------------------------------------------------===//

module clocksel(
  input bit sel,     // single step (0) or automatic (1)
  input bit clk_a,   // push button single step clock
  input bit clk_b,   // 100Hz derived from DE10-Lite board clock (50MHz) or external 6.5536MHz
  output bit clk_out
  );

  always_comb begin
    if (sel)
	   clk_out = clk_a;
    else
	   clk_out = clk_b;
  end

endmodule
