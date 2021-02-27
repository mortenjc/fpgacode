// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief user control - implemented by mechanical switches
/// sw9   - select display - 0:  display PWM value, 1: show contributions
/// sw8   - select clock source: 0 clock a, 1: clock b
/// sw7-6 - select byte position for user configurable value
/// sw5-0 - six bit user value - will be shifted left 2 bits to make a 8 bit val  
//===----------------------------------------------------------------------===//


module control (
  input bit [9:0] sw,
  output bit clk_sel,
  output bit disp_sel,
  output [31:0] target
  );

  assign disp_sel = sw[9];
  assign clk_sel = sw[8];
  bit [7:0] value;
  
  // 1'234'554'321 = 0x4996CDD1
  always_comb begin
	 value = {sw[5:0], 2'b0};
	 unique case (sw[7:6]) 
	   0: target = {24'h4996CD, value     };
		1: target = {16'h4996, value, 8'hD1};
		2: target = {8'h49, value, 16'hCDD1};
		3: target = {     value, 24'h96CDD1};
	 endcase
  end


endmodule