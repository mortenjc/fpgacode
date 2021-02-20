// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief combining four stages
//===----------------------------------------------------------------------===//

module fourmods(
  input clk_in,
  input rstn_in,
  input bit [7:0] tgt_val,
  output bit [8:0] leds,
  output bit [7:0] hex5,
  output bit [7:0] hex4
  );
  
  assign leds[0] = clk_in;
  assign leds[1] = rstn_in;
  
  wire reset = ~rstn_in;

  wire [31:0] tgt_in_i = {24'h4995cd, tgt_val};
  wire [15:0] val1;
  wire [15:0] val2;
  wire [15:0] val3;
  wire [15:0] val4;

  wire [31:0] mod2_tgt_in;
  anspwm mod1(
    .clk(clk_in),
    .rst(reset),
    .tgt_in(tgt_in_i),
    .val_out(val1),
    .diff_out(mod2_tgt_in)
    );

  wire [31:0] mod3_tgt_in;
  anspwm mod2(
    .clk(clk_in),
    .rst(reset),
    .tgt_in(mod2_tgt_in),
    .val_out(val2),
    .diff_out(mod3_tgt_in)
    );

  wire [31:0] mod4_tgt_in;
  anspwm mod3(
    .clk(clk_in),
    .rst(reset),
    .tgt_in(mod3_tgt_in),
    .val_out(val3),
    .diff_out(mod4_tgt_in)
    );

  wire [31:0] unused;
  anspwm mod4(
    .clk(clk_in),
    .rst(reset),
    .tgt_in(mod4_tgt_in),
    .val_out(val3),
    .diff_out(unused)
    );
	 
  ledctrl ledctrl_5(
	 .value(val1[7:4]),
	 .led(hex5)
	 );
	 
  ledctrl ledctrl_4(
	 .value(val1[3:0]),
	 .led(hex4)
	 );
	 
endmodule
