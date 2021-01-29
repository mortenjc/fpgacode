

module top(input clk,
	output bit[7:0] hex0,
	output bit[7:0] hex1,
	output bit[7:0] hex2,
	output bit[7:0] hex3,
	output bit[7:0] hex4,
	output bit[7:0] hex5
	);
	
	wire sec_pulse_i;
   wire [5:0] sec_i;
	wire [5:0] min_i;
	wire [4:0] hour_i;
	
   clockdivider clockdiv_i(.clk_in(clk), .sec_pulse(sec_pulse_i));
	
	clock clock_i(.sec_pulse(sec_pulse_i), 
	              .reset(0), 
					  .enable(1), 
					  .sec(sec_i), 
					  .min(min_i), 
					  .hour(hour_i));
	
	ledctrl ledctrl_i(.s(sec_i), 
	                  .m(min_i),
							.h(hour_i),
							.led0(hex0), 
							.led1(hex1), 
							.led2(hex2), 
							.led3(hex3), 
							.led4(hex4), 
							.led5(hex5));
  
endmodule