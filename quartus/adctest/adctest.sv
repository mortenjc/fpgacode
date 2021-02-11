
module adctest(
	input clk,
	input reset,
	output lock,
	output oclock
	);
	
		
	pll pll_i(.inclk0(clk), .areset(reset), .c0(oclock), .locked(lock));

endmodule