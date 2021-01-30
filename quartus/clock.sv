module clock(
  input bit s_clk,
  input bit hs_clk,
  input bit reset,
  input bit enable,
  output bit [4:0] hour,
  output bit [5:0] min,
  output bit [5:0] sec,
  output bit dot
  );
  
  bit [4:0] new_hour;
  bit [5:0] new_min;
  bit [5:0] new_sec;
 
  bit [16:0] hoursec;
  bit [11:0] minsec;
  
   always_ff @(posedge hs_clk) begin
	   dot <= ~dot;
	end
   
	always_ff @(posedge s_clk) begin
		if (enable) begin
			if (reset) begin
				new_hour = 0;
				new_min = 0;
				new_sec = 0;
			end // reset
			else begin
				new_sec++;
				minsec++;
				hoursec++;
				if (new_sec == 60) begin
					new_sec = 0;
					new_min++;
				end
		  
				if (minsec == 3600) begin
					minsec = 0;
					new_min = 0;
					new_hour++;
				end
				
		 	   if (hoursec == 3600*24) begin
					hoursec = 0;
					new_hour = 0;
				end
			
			end // not reset
				
			hour <= new_hour;
			min <= new_min;
			sec <= new_sec;
		end // enable
	end
  
 endmodule