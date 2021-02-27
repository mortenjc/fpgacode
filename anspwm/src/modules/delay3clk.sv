// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief delay data and sign one to three clock cycles
//===----------------------------------------------------------------------===//

module delay3clk(
  input clk,
  input rst_n,
  input bit[15:0] val_in,
  input bit sign_in,

  output bit[15:0] d1_out,
  output bit d1s_out,
  output bit[15:0] d2_out,
  output bit d2s_out,
  output bit[15:0] d3_out,
  output bit d3s_out
  );


  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      d1_out <= 16'b0;
      d1s_out <= 1'b0;
      d2_out <= 16'b0;
      d2s_out <= 1'b0;
      d3_out <= 16'b0;
      d3s_out <= 1'b0;
    end else begin
      d1_out <= val_in;
      d1s_out <= sign_in;
      d2_out <= d1_out;
      d2s_out <= d1s_out;
      d3_out <= d2_out;
      d3s_out <= d2s_out;
    end
  end

 endmodule
