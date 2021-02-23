// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief clock multiplexer - select between clocks a and b
//===----------------------------------------------------------------------===//

module clocksel(
  input sel,
  input clk_a,
  input clk_b,
  output clk_out
  );

  always_comb begin
    if (sel == 0)
	   clk_out = clk_a;
	 else
	   clk_out = clk_b;
  end

endmodule
