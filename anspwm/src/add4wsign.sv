// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief signed addition of the four contributions
/// sum = c0 +- c1 +- c2 +- c3
//===----------------------------------------------------------------------===//

module add4wsign (
  input bit clk,
  input bit rst_n,
  
  input [15:0] c0, c1, c2, c3,
  input c1s, c2s, c3s,

  output [15:0] sum
  );

  logic [15:0] tmpsum;

  always_comb begin
    unique case({c1s, c2s, c3s})
      3'b000: tmpsum = c0 + c1 + c2 + c3;
      3'b001: tmpsum = c0 + c1 + c2 - c3;
      3'b010: tmpsum = c0 + c1 - c2 + c3;
      3'b011: tmpsum = c0 + c1 - c2 - c3;
      3'b100: tmpsum = c0 - c1 + c2 + c3;
      3'b101: tmpsum = c0 + c1 + c2 - c3;
      3'b110: tmpsum = c0 - c1 - c2 + c3;
      3'b111: tmpsum = c0 - c1 - c2 - c3;
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sum <= 16'b0;
    end else begin
       sum <= tmpsum;
    end
  end

 endmodule
