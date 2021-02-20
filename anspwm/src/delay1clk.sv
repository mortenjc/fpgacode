// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief delay data and sign one clock cycle
//===----------------------------------------------------------------------===//

module delay1clk(
   input clk,
	input rst_n,
   input bit[15:0] val_in,
	input bit sign_in,
	output bit[15:0] val_out,
	output bit sign_out
	);

	

  always_ff @(posedge clk) begin
    if (~rst_n) begin
      val_out <= 16'b0;
		sign_out = 1'b0;
    end else begin
       val_out <= val_in;
		 sign_out <= sign_in;
    end
  end
  
 endmodule