// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief grouping of clock handling modules
//===----------------------------------------------------------------------===//

module clockunit(
  input bit clk_src_fpga,      // 50MHz DE10-Lite board master clock
  input bit clk_src_ext,       // 6.5536MHz from external pin
  input bit clk_src_button,    // from push button
  input bit [1:0] clk_src_sel, // choose which source

  output bit clk_out,
  output bit clk_fast_out
  );


  // Generate 100 Hz and 5MHz/6.5536MHz
  bit clk_100Hz;

  bit clk_src_fast;
  always_comb begin
    if (clk_src_sel[0])
	   clk_src_fast = clk_src_ext;
    else
	   clk_src_fast = clk_src_fpga;
  end

  logic clk_div;
  clockdiv clockdiv_i(
    .clk_in(clk_src_fast),
	 .ext_sel(clk_src_sel[0]),
    .clk_slow(clk_100Hz),
    .clk_fast(clk_div)
  );

  fastclkmux(
    .fast_clk_sel(clk_src_sel[0]),
    .fast_clk_ext(clk_src_ext),
    .fast_clk_div(clk_div),
    .fast_clk_out(clk_fast_out)
    );


  clocksel clocksel_i(
    .sel(clk_src_sel[1]),
    .clk_a(clk_src_button),
    .clk_b(clk_100Hz),
    .clk_out(clk_out)
  );



endmodule
