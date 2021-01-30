

module clockdivider(
	input bit clk_in,
	output bit s,      // seconds
	output bit hs);    // half seconds

	bit [31:0] s_max = 50000000;
	bit [31:0] cnt_s;
	bit new_s;
	
	bit [31:0] hs_max = 25000000;
	bit [31:0] cnt_hs;
	bit new_hs;
	
  
  initial begin // not synthesizable - for unit test
    s = 0;
	 hs = 0;
  end
  
  always_ff @(posedge clk_in) begin
    cnt_s = cnt_s + 1;
	 cnt_hs = cnt_hs + 1;
	 
	 if (cnt_s == s_max) begin
	   cnt_s = 0;
		new_s = 1;
	 end
	 else
	   new_s = 0;
		
	 if (cnt_hs == hs_max) begin
	   cnt_hs = 0;
		new_hs = 1;
	 end
	 else
	   new_hs = 0;
	 
    s <= new_s;
	 hs <= new_hs;
  end
	
endmodule