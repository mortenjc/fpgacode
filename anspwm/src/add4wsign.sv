// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief addition of the four contributions
//===----------------------------------------------------------------------===//

module add4wsign (
  input bit clk,
  input bit rst_n,
  input [15:0] c0,
  input [15:0] c1,
  input c1_sgn,
  input [15:0] c2,
  input c2_sgn,
  input [15:0] c3,
  input c3_sgn,

  output [15:0] val
  );
  
  logic [15:0] sum;
  
  always_comb begin
    unique case({c1_sgn, c2_sgn, c2_sgn})
	   3'b000: sum = c0 + c1 + c2 + c3;
		3'b001: sum = c0 + c1 + c2 - c3;
		3'b010: sum = c0 + c1 - c2 + c3;
		3'b011: sum = c0 + c1 - c2 - c3;
		3'b100: sum = c0 - c1 + c2 + c3;
		3'b101: sum = c0 + c1 + c2 - c3;
		3'b110: sum = c0 - c1 - c2 + c3;
		3'b111: sum = c0 - c1 - c2 - c3;
	 endcase
  end
  
  always_ff @(posedge clk) begin
    if (~rst_n) begin
      val <= 16'b0;
    end else begin
       val <= sum;
    end
  end
 
 endmodule