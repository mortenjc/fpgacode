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

  output bit clk_slow_out,      // slow 100Hz update clock
  output bit clk_fast_out       // 5 or 6.5MHz PWM clock
  );


  bit ext_clk_sel;
  bit manual_clk_sel;
  assign ext_clk_sel = clk_src_sel[0];    // ext(1) int(0)
  assign manual_clk_sel = clk_src_sel[1]; // auto(1) manual(0)

  // Generate the fast and slow clocks
  // Fast is either internal 50MHz/10 = 5MHz or
  // external 6.553600MHz (not divided)
  // Slow is either internal 50MHz/500000 = 100Hz or
  // external 6553600/65536 = 100Hz
  bit fpgaclk_5Mhz;
  clockdivparm #(10) fpgaclk_to_5MHz(
    .clk(clk_src_fpga),
    .clk_out(fpgaclk_5Mhz)
    );

  bit fpgaclk_100Hz;
  clockdivparm #(500000) fpgaclk_to_100Hz(
    .clk(clk_src_fpga),
    .clk_out(fpgaclk_100Hz)
    );

  bit extclk_100Hz;
  clockdivparm #(65536) ext_to_100Hz(
    .clk(clk_src_ext),
    .clk_out(extclk_100Hz)
    );


  // Multiplexer for fast and slow (automatic) clocks
  bit clk_100Hz;
  always_comb begin
    if (ext_clk_sel) begin
      clk_fast_out = clk_src_ext;
      clk_100Hz = extclk_100Hz;
    end else begin
    clk_fast_out = fpgaclk_5Mhz;
    clk_100Hz = fpgaclk_100Hz;
    end
  end


  clocksel clocksel_i(
    .sel(manual_clk_sel),
    .clk_a(clk_src_button),
    .clk_b(clk_100Hz),
    .clk_out(clk_slow_out)
  );

endmodule
