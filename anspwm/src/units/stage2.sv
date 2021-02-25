// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief stage 2 uses one quant module, one delayed diff module and
/// one delay module (2 clks)
//===----------------------------------------------------------------------===//

module stage2 (
  input bit clk,
  input bit rst_n,

  input  [31:0] A,
  output [15:0] C,     // to final signed addition
  output Csgn,         // to final signed addition
  output [31:0] nxttgt // for next stage
  );

  //
  wire [15:0] quant;
  quantize16 quantize16_i(
    .clk(clk),
    .rst_n(rst_n),
    .target(A),
    .quant(quant),
    .diff(nxttgt)
  );

  //
  wire [15:0] dd;
  wire dds;
  ddiff3 ddiff3_i(
    .clk(clk),
    .rst_n(rst_n),
    .A(quant),
    .dd1(dd),
    .dd1s(dds),
	 .dd2(),
    .dd2s(),
	 .dd3(),
    .dd3s()
    );

  delay3clk delay3clk_i(
    .clk(clk),
    .rst_n(rst_n),
    .val_in(dd),
    .sign_in(dds),
	 .d1_out(),
	 .d1s_out(),
    .d2_out(C),
    .d2s_out(Csgn),
	 .d3_out(),
	 .d3s_out()
  );

endmodule
