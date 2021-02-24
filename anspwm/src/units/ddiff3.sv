// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief chained delayed subtraction C = A - B, where B = A(n-1)
///  delays from 1 to 3 clock cycles are supported
//===----------------------------------------------------------------------===//

module ddiff3 (
  input bit clk,
  input bit rst_n,
  input [15:0] A,

  output [15:0] dd1,  // first delayed difference
  output bit dd1s,
  output [15:0] dd2,
  output bit dd2s,
  output [15:0] dd3,  // third delayed difference
  output bit dd3s
  );

  ddiff ddiff_i1(
    .clk(clk),
    .rst_n(rst_n),
    .A(A),
    .A_sign(1'b1),
    .C(dd1),
    .C_sign(dd1s)
  );

  ddiff ddiff_i2(
    .clk(clk),
    .rst_n(rst_n),
    .A(dd1),
    .A_sign(dd1s),
    .C(dd2),
    .C_sign(dd2s)
  );

  ddiff ddiff_i3(
    .clk(clk),
    .rst_n(rst_n),
    .A(dd2),
    .A_sign(dd2s),
    .C(dd3),
    .C_sign(dd3s)
  );

 endmodule
