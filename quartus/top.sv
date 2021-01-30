// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Implementing a clock (eventually) based on DE10-lite FPGA demo board
/// The system consists of
///   * a clock divider generating a half-second and a second clock
///   * clock module generating hour, minute and second values
///   * 7-segment led display module
//===----------------------------------------------------------------------===//

module top(
   input clk,
	input reset,
	output bit[7:0] hex0,
	output bit[7:0] hex1,
	output bit[7:0] hex2,
	output bit[7:0] hex3,
	output bit[7:0] hex4,
	output bit[7:0] hex5
	);
	

	
	wire s_clk_i;
	wire hs_clk_i;
   clockdivider clockdiv_i(
		.clk_in(clk), 
		.s(s_clk_i), 
		.hs(hs_clk_i));

		
	wire [5:0] sec_i;
	wire [5:0] min_i;
	wire [4:0] hour_i;
	wire dot_i;
	clock clock_i(
		.s_clk(s_clk_i),
		.hs_clk(hs_clk_i),
		.reset(~reset), 
		.enable(1), 
		.sec(sec_i), 
		.min(min_i), 
		.hour(hour_i),
		.dot(dot_i));
	
	
	ledctrl ledctrl_i(
		.s(sec_i), 
		.m(min_i),
		.h(hour_i),
		.dot(dot_i),
		.led0(hex0), 
		.led1(hex1), 
		.led2(hex2), 
		.led3(hex3), 
		.led4(hex4), 
		.led5(hex5));
  
endmodule