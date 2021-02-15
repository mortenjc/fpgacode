// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief combining four stages
//===----------------------------------------------------------------------===//

module fourmods(
  input clk,
  input rst,
  input wire [31:0] tgt_in;
  output wire [8:0] leds;
  );

  wire [15:0] val1;
  wire [15:0] val2;
  wire [15:0] val3;
  wire [15:0] val4;

  wire [31:0] mod2_tgt_in;
  anspwm mod1(
    .clk(clk),
    .src(rst),
    .tgt_in(tgt_in),
    .val_out(val1),
    .diff_out(mod2_tgt_in)
    );

  wire [31:0] mod3_tgt_in;
  anspwm mod2(
    .clk(clk),
    .src(rst),
    .tgt_in(mod2_tgt_in),
    .val_out(val2),
    .diff_out(mod3_tgt_in)
    );

  wire [31:0] mod4_tgt_in;
  anspwm mod3(
    .clk(clk),
    .src(rst),
    .tgt_in(mod3_tgt_in),
    .val_out(val3),
    .diff_out(mod4_tgt_in)
    );

  wire [31:0] unused;
  anspwm mod4(
    .clk(clk),
    .src(rst),
    .tgt_in(mod4_tgt_in),
    .val_out(val3),
    .diff_out(unused)
    );

endmodule
