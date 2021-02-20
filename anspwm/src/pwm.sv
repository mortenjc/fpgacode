// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 16 bit pulse width modulator
//===----------------------------------------------------------------------===//

module pwm16(
  input clk,     // 5MHz
  input set_val,
  input bit [15:0] val,
  output bit clk_out
  );

logic [15:0] counter;
logic [15:0] pval;

bit new_clk_out;


always_ff @(posedge set_val) begin
	pval <= val;
end


always_ff @(posedge clk) begin
  if (counter == 65535) begin
    counter = 0;
	 if (counter < pval)
	   new_clk_out = 1;
	 else
	   new_clk_out = 0;	
  end else begin
    counter++;
	 if (counter < pval)
	   new_clk_out = 1;
	 else
	   new_clk_out = 0;
  end
  clk_out <= new_clk_out;
end
  
endmodule