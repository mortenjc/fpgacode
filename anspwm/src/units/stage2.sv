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

  input [15:0] A,
  output [15:0] C,     // to final signed addition
  output Csgn,         // to final signed addition
  output [31:0] nxttgt // for next stage
  );

  wire [15:0] quant;
  quantize16(
    .clk(clk),
    .rst_n(rst_n),
    .target(A),
    .quant(quant),
    .diff(nxttgt)
  );

  wire [15:0] dd;
  wire dds;
  ddiff3(
    .clk(clk),
    .rst_n(rst_n),
    .A(nxttgt),
    .dd1(dd),
    .dd1s(dds)
    );

  delay3clk(
    .clk(clk),
    .rst_n(rst_n),
    .val_in(dd),
    .sgn_in(dds),
    .d2_out(C),
    .d2s_out(Csgn)
  );

endmodule
