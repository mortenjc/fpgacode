// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Top level module - refactored
//===----------------------------------------------------------------------===//

module anspwm(
  input max10_clk,    // 50MHz -  PIN_P11
  input ext_clk,         //  6.5536MHz - PIN_AB20
  input btn_clk,         // KEY0 - PIN_B8
  input rst_n,           // KEY1 - PIN_A7
  input bit [9:0] sw,    // SW9 - SW0
  input bit ext_clk_sel, // PIN_AB17

  output bit pwm_out,
  output bit [9:0] leds,
  output bit [7:0] hex5,
  output bit [7:0] hex4,
  output bit [7:0] hex3,
  output bit [7:0] hex2,
  output bit [7:0] hex1,
  output bit [7:0] hex0
  );
  
  
  // Handle user control
  bit [1:0] clk_src;
  bit [31:0] target;
  control control_i(
    .sw(sw),
	 .ext_clk_sel(ext_clk_sel),
	 .clk_sel(clk_src),
	 .target(target) 
  );

  
  // Clock module - clock division and clock multiplexer
  bit clk_in;
  bit clk_pwm;
  clockunit clockunit_i(
    .clk_src_fpga(max10_clk),
	 .clk_src_ext(ext_clk),
	 .clk_src_button(btn_clk),
	 .clk_src_sel(clk_src),
	 .clk_slow_out(clk_in),
	 .clk_fast_out(clk_pwm)
  );

 //

  // DSP Module - four stages and adder
  logic [15:0] duty_cycle;
  logic [29:0] debug;
  dspmod dspmod_i(
    .clk(clk_in),
    .rst_n(rst_n),
    .target(target),
    .value(duty_cycle),
	 .debug(debug)
  );


  // PWM module
  pwm16 pwm16_i(
    .clk(clk_pwm),
    .set_val(clk_in),
    .val(duty_cycle),
    .clk_out(pwm_out)
  );
  //


  ledunit ledunit_i(
	 .value(duty_cycle),
	 .debug(debug),
	 .switches(sw),
	 .leds(leds),
	 .hex5(hex5),
	 .hex4(hex4),
	 .hex3(hex3),
	 .hex2(hex2),
	 .hex1(hex1),
	 .hex0(hex0)
  );

endmodule
