

module clockdivider(
	input bit clk_in,
	output bit sec_pulse);

	bit [31:0] max_counter = 50000000;
	bit [31:0] counter;
	bit new_sec_pulse;
	
  
  initial begin
    counter = 0;
	 new_sec_pulse = 0;
  end
  
  always_ff @(posedge clk_in) begin
    counter = counter + 1;
	 if (counter == max_counter) begin
	   counter = 0;
		new_sec_pulse = 1;
	 end
	 else
	   new_sec_pulse = 0;
	 
    sec_pulse <= new_sec_pulse;
  end
	
endmodule