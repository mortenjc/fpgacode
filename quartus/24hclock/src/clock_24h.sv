// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief wall clock time generator with half second indicator
/// uses a second-clock and halfsecond-clock
//===----------------------------------------------------------------------===//

module clock_24h(
  input bit s_clk,
  input bit hs_clk,
  input bit reset_h,
  input bit reset_m,
  input bit [5:0] value, // from switch 5 - 0

  output bit [4:0] hour,
  output bit [5:0] min,
  output bit [5:0] sec,
  output bit dot
  );



   always_ff @(posedge hs_clk) begin
	   dot <= ~dot;
	end


	always_ff @(posedge s_clk) begin
		if (reset_h | reset_m) begin
			if (reset_h)
				hour <= value[4:0] % 5'b11000;
			else
				min <= value[5:0] % 6'b111100;
			sec <= 0;
		end else begin // not reset - normal clock
			if (sec == 59) begin // second overflow check
				sec <= 0;
				if (min == 59) begin // minute overflow check
					min <= 0;
					if (hour == 23) begin // hour overflow check
						hour <= 0;
					end else begin
					   hour <= hour + 1'b1;
					end // houroverflow check
				end else begin
					min <= min + 1'b1;
				end
			end else begin
				sec <= sec + 1'b1;
			end // sec overflow check
		end // not reset - normal clock

	end // posedge _clk

 endmodule
