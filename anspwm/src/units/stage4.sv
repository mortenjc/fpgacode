// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief stage 2 uses one quant module, one delayed diff module and
/// NO delay module (0 clks)
//===----------------------------------------------------------------------===//

module stage4 (
  input bit clk,
  input bit rst_n,

  input  [31:0] A,
  output [15:0] C,     // to final signed addition
  output Csgn,         // to final signed addition
  output [31:0] nxttgt // for next stage
  );

  wire [15:0] quant;
  quantize16 quantize16_i(
    .clk(clk),
    .rst_n(rst_n),
    .target(A),
    .quant(quant),
    .diff(nxttgt)
  );

  ddiff3 ddiff3_i(
    .clk(clk),
    .rst_n(rst_n),
    .A(quant),
	 .dd1(),
	 .dd1s(),
	 .dd2(),
	 .dd2s(),
    .dd3(C),
    .dd3s(Csgn)
    );

  // no output value delays are necessary

endmodule
