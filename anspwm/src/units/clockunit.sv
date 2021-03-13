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
  // fpga clock is divided by 10 to give a 5MHz clock
  // ext and 5MHz clocks are divided by 65536 to give a slow (update) clock
  // If ext clk is 6.5536MHz - the update clock will be 100Hz
  bit fpgaclk_5Mhz;
  clockdivparm #(10) fpgaclk_to_5MHz(
    .clk(clk_src_fpga),
    .clk_out(fpgaclk_5Mhz)
    );

  bit fpgaclk_76Hz;
  clockdivparm #(65536) fpgaclk_to_76Hz( // 50Mhz/655360
    .clk(fpgaclk_5Mhz),
    .clk_out(fpgaclk_76Hz)
    );

  bit extclk_slowHz;
  clockdivparm #(65536) ext_to_slowHz(
    .clk(clk_src_ext),
    .clk_out(extclk_slowHz)
    );


  // Multiplexer for fast and slow (automatic) clocks
  bit clk_slowHz;
  always_comb begin
    if (ext_clk_sel) begin
      clk_fast_out = clk_src_ext;
      clk_slowHz = extclk_slowHz;
    end else begin
    clk_fast_out = fpgaclk_5Mhz;
    clk_slowHz = fpgaclk_76Hz;
    end
  end


  clocksel clocksel_i(
    .sel(manual_clk_sel),
    .clk_a(clk_src_button),
    .clk_b(clk_slowHz),
    .clk_out(clk_slow_out)
  );

endmodule
