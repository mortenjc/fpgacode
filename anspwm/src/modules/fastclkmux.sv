// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief clock multiplexer - select between clocks a and b
/// \todo UNUSED so far
//===----------------------------------------------------------------------===//

module fastclkmux(
  input bit fast_clk_sel, // ext (1) or divided (0)
  input bit fast_clk_ext, // 6.5536MHz external
  input bit fast_clk_div, // 5MHz divided from 50MHz
  output bit fast_clk_out
  );

  always_comb begin
    if (fast_clk_sel)
	   fast_clk_out = fast_clk_ext;
    else
	   fast_clk_out = fast_clk_div;
  end

endmodule
