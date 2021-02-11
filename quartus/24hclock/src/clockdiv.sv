// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief a 50MHz to 1Hz and 2Hz clock divider
//===----------------------------------------------------------------------===//

module clockdivider #(
   parameter SEC_TICKS = 50000001,
	parameter HALF_SEC_TICKS = 25000000)
	(
	input bit clk_in,
	output bit s,      // seconds
	output bit hs,     // half seconds
	output bit [9:0] ctr);    

	bit [31:0] s_max = SEC_TICKS - 1;
	bit [31:0] cnt_s;
	bit new_s;
	
	bit [31:0] hs_max = HALF_SEC_TICKS - 1;
	bit [31:0] cnt_hs;
	bit new_hs;
	
  
  initial begin // not synthesizable - for unit test
    s = 0;
	 hs = 0;
  end
  
  always_ff @(posedge clk_in) begin
	 if (cnt_s == s_max) begin
	   cnt_s = 0;
		new_s = 1;
	 end
	 else begin
	   cnt_s++;
	   new_s = 0;
	 end
		
	 if (cnt_hs == hs_max) begin
	   cnt_hs = 0;
		new_hs = 1;
	 end
	 else begin
	   cnt_hs++;
	   new_hs = 0;
	 end		
	 
    s <= new_s;
	 hs <= new_hs;
	 ctr <= cnt_s[25:16];
  end
	
endmodule