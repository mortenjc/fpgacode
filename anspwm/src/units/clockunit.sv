// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief grouping of clock handling modules
//===----------------------------------------------------------------------===//

module clockunit(
  input bit clk_src_fpga,   // 50MHz DE10-Lite board master clock
  input bit clk_src_button, // from push button
  input bit clk_src,        // chose which source
 
  output bit clk_out,
  output bit clk_fast_out
  );


  // Generate 100 Hz and 5MHz
  bit clk_100Hz;

  clockdiv clockdiv_i(
    .clk_in(clk_src_fpga),
    .clk_slow(clk_100Hz),
    .clk_fast(clk_fast_out)
  );


  clocksel clocksel_i(
    .sel(clk_src),
    .clk_a(clk_src_button),
    .clk_b(clk_100Hz),
    .clk_out(clk_out)
  );



endmodule