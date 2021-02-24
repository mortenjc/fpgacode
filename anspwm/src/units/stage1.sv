// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief stage 1 uses on quant module and one delay module (3 clks)
//===----------------------------------------------------------------------===//

module stage1 (
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

  // no delayed diff is required

  delay3clk(
    .clk(clk),
    .rst_n(rst_n),
    .val_in(quant),
    .sgn_in(1'b1),
    .d3_out(C),
    .d3s_out(Csgn)
  );

endmodule
