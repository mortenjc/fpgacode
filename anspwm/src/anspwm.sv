// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Top level module - refactored but still too messy
//===----------------------------------------------------------------------===//

module anspwm(
  input clk,      // 50MHz -  PIN_P11
  input clk_btn,  // KEY0 - PIN_B8
  input rst_n,    // KEY1 - PIN_A7
  input bit [9:0] sw, // SW9 - SW0

  output bit pwm_out,
  output bit [9:0] leds,
  output bit [7:0] hex5,
  output bit [7:0] hex4,
  output bit [7:0] hex3,
  output bit [7:0] hex2,
  output bit [7:0] hex1,
  output bit [7:0] hex0
  );
  
  
  assign leds = sw;
  
  // Handle user control
  bit clk_src;
  bit disp_src;
  bit [31:0] target;
  control control_i(
    .sw(sw),
	 .clk_sel(clk_src),
	 .disp_sel(disp_src),
	 .target(target) 
  );

  
  // Clock module - clock division and clock multiplexer
  bit clk_in;
  bit clk_pwm;
  clockunit clockunit_i(
    .clk_src_fpga(clk),
	 .clk_src_button(clk_btn),
	 .clk_src(clk_src),
	 .clk_out(clk_in),
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


  // LED SELECTION
  wire [4:0] led5_i, led4_i, led3_i, led2_i, led1_i, led0_i;
  ledselect ledsel(
    .sel(disp_src),
     .val_a(duty_cycle),
     .val_b(debug),
     .led5(led5_i),
     .led4(led4_i),
     .led3(led3_i),
     .led2(led2_i),
     .led1(led1_i),
     .led0(led0_i)
  );

  //
  // hex5 - hex0 - either  contributions or sum
  ledctrl ledctrl_5(
     .value(led5_i),
     .led(hex5)
   );

  ledctrl ledctrl_4(
     .value(led4_i),
     .led(hex4)
   );

  ledctrl ledctrl_3(
     .value(led3_i),
     .led(hex3)
  );

  ledctrl ledctrl_2(
     .value(led2_i),
     .led(hex2)
   );

  ledctrl ledctrl_1(
     .value(led1_i),
     .led(hex1)
   );

  ledctrl ledctrl_0(
     .value(led0_i),
     .led(hex0)
   );
endmodule
