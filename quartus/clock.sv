module clock(
  input bit sec_pulse,
  input bit reset,
  input bit enable,
  output bit [4:0] hour,
  output bit [5:0] min,
  output bit [5:0] sec
  );
  
  bit [4:0] hours;
  bit [16:0] hoursec;
  bit [5:0] minutes;
  bit [11:0] minsec;
  bit [5:0] seconds;
  
	always_ff @(posedge sec_pulse) begin
		if (enable) begin
			if (reset) begin
				hours = 0;
				minutes = 0;
				seconds = 0;
			end // reset
			else begin
				seconds++;
				minsec++;
				hoursec++;
				if (seconds == 60) begin
					seconds = 0;
					minutes++;
				end
		  
				if (minsec == 3600) begin
					minsec = 0;
					minutes = 0;
					hours++;
				end
				
		 	   if (hoursec == 3600*24) begin
					hoursec = 0;
					hours = 0;
				end
			
			end // not reset
				
			hour <= hours;
			min <= minutes;
			sec <= seconds;
		end // enable
	end
  
 endmodule