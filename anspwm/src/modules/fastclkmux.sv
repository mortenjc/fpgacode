// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief clock multiplexer - select between clocks a and b
//===----------------------------------------------------------------------===//

module fastclkmux(
  input fast_clk_sel, // ext or divided
  input fast_clk_ext, // 6.5536MHz external
  input fast_clk_div, // 5MHz divided from 50MHz
  output fast_clk_out
  );

  always_comb begin
    if (fast_clk_sel == 1)
	   fast_clk_out = fast_clk_ext;
    else
	   fast_clk_out = fast_clk_div;
  end

endmodule
