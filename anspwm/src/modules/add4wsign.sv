// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief signed addition of the four contributions
/// sum = c0 +- c1 +- c2 +- c3
//===----------------------------------------------------------------------===//

module add4wsign (
  input bit rst_n,
  input bit [15:0] c0, c1, c2, c3,
  input bit c1s, c2s, c3s,
  output [15:0] sum
  );

  always_comb begin
    unique case({c1s, c2s, c3s})
      3'b000: sum = c0 + c1 + c2 + c3;
      3'b001: sum = c0 + c1 + c2 - c3;
      3'b010: sum = c0 + c1 - c2 + c3;
      3'b011: sum = c0 + c1 - c2 - c3;
      3'b100: sum = c0 - c1 + c2 + c3;
      3'b101: sum = c0 - c1 + c2 - c3;
      3'b110: sum = c0 - c1 - c2 + c3;
      3'b111: sum = c0 - c1 - c2 - c3;
    endcase
    if (~rst_n) begin
      sum = 16'b0;
    end
  end

 endmodule
