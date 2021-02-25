// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief chained delayed subtraction C = A - B, where B = A(n-1)
///  delays from 1 to 3 clock cycles are supported
//===----------------------------------------------------------------------===//

module dspmod(
  input bit clk,
  input bit rst_n,
  input [31:0] target,
  output [15:0] value,
  output [29:0] debug
  );
  
  assign debug = {
    1'b0,    target[7:4],
    1'b0,    target[3:0],
    1'b0,    c0_out[3:0],
    c1s_out, c1_out[3:0],
    c2s_out, c2_out[3:0],
    c3s_out, c3_out[3:0]
	 };

// Stage 1 - quantize, 0 delayed diff, 3 clk output delay
  wire [31:0] s2target;
  wire [15:0] c0_out;
  wire c0s_out;
  stage1 stage1_i(
    .clk(clk),
    .rst_n(rst_n),
    .A(target),
    .C(c0_out),
    .Csgn(c0s_out),
    .nxttgt(s2target)
    );

// Stage 2 - quantize, 1 delayed diff, 2 clk output delay
  wire [31:0] s3target;
  wire [15:0] c1_out;
  wire c1s_out;
  stage2 stage2_i(
    .clk(clk),
    .rst_n(rst_n),
    .A(s2target),
    .C(c1_out),
    .Csgn(c1s_out),
    .nxttgt(s3target)
    );

// Stage 3 - quantize, 2 delayed diff, 1 clk output delay
  wire [31:0] s4target;
  wire [15:0] c2_out;
  wire c2s_out;
  stage3 stage3_i(
    .clk(clk),
    .rst_n(rst_n),
    .A(s3target),
    .C(c2_out),
    .Csgn(c2s_out),
    .nxttgt(s4target)
    );

// Stage 4 - quantize, 3 delayed diff, 0 clk output delay
  wire [15:0] c3_out;
  wire c3s_out;
  stage4 stage4_i(
    .clk(clk),
    .rst_n(rst_n),
    .A(s4target),
    .C(c3_out),
    .Csgn(c3s_out)
    );


  // SUM
  add4wsign add4wsign_i(
    .clk(clk),
    .rst_n(rst_n),
    .c0(c0_out),
    .c1(c1_out),
    .c1s(c1s_out),
    .c2(c2_out),
    .c2s(c2s_out),
    .c3(c3_out),
    .c3s(c3s_out),
    .sum(value)
  );


endmodule
