// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief TODO add description
//===----------------------------------------------------------------------===//

module quantize16 (
  input bit clk,
  input bit rst_n,
  input [31:0] target,
  output [15:0] quant,
  output [31:0] diff
  );

  bit [31:0] corr;
  bit [31:0] trunc;
  /* verilator lint_off UNUSED */
  bit [31:0] tmp;
  /* verilator lint_on UNUSED */

  always_comb begin
    if (~rst_n) begin
      tmp = 0;
      trunc = 0;
      quant = 0;
      diff = 0;
    end else begin
      tmp = target + corr;
      trunc = {tmp[31:16], 16'b0};
      quant = trunc[31:16];
      diff = tmp - trunc;
    end
    //$display("tmp %h, trunc %h, quant %h, diff %d", tmp, trunc, quant, diff);
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      corr <= 0;
    end else begin
      corr <= diff;

    end
	end

 endmodule
