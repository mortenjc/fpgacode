// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief pulse width modulator
//===----------------------------------------------------------------------===//

module anspwm (
  input bit clk,
  input bit rst,
  input [31:0] tgt_in,
  output [15:0] val_out,
  output [31:0] diff_out
  );

  bit [31:0] corr;
  bit [31:0] quant;
  bit [31:0] target;

  always_comb begin
    target = tgt_in + corr;
    quant = {target[31:16], 16'b0};
    val_out = quant[31:16];
    diff_out = target - quant;
  end

  always_ff @(posedge clk) begin
    if (rst) begin
      corr <= 0;
    end else begin
      corr <= diff_out;
    end
	end



 endmodule
