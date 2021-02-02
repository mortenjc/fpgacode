// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 7 segment LED display for DE10-lite which has 6 7-segment LEDs
//===----------------------------------------------------------------------===//

module ledctrl(
	input bit [4:0] h,
	input bit [5:0] m,
	input bit [5:0] s,
	input bit dot, // half second

	output bit[7:0] led0,
	output bit[7:0] led1,
	output bit[7:0] led2,
	output bit[7:0] led3,
	output bit[7:0] led4,
	output bit[7:0] led5
	);
	
	bit [6:0] led_dig_0 = 'b1000000;
	bit [6:0] led_dig_1 = 'b1111001;
	bit [6:0] led_dig_2 = 'b0100100;
	bit [6:0] led_dig_3 = 'b0110000;
	bit [6:0] led_dig_4 = 'b0011001;
	bit [6:0] led_dig_5 = 'b0010010;
	bit [6:0] led_dig_6 = 'b0000010;
	bit [6:0] led_dig_7 = 'b1111000;
	bit [6:0] led_dig_8 = 'b0000000;
	bit [6:0] led_dig_9 = 'b0010000;
	bit [7:0] led_off =   'b11111111;

	bit nodot = 1'b1;
	
	always_comb begin
		unique case (s % 10)
			0 : led0 = {nodot, led_dig_0};
	      1 : led0 = {nodot, led_dig_1};
			2 : led0 = {nodot, led_dig_2};
	      3 : led0 = {nodot, led_dig_3};
			4 : led0 = {nodot, led_dig_4};
	      5 : led0 = {nodot, led_dig_5};
			6 : led0 = {nodot, led_dig_6};
	      7 : led0 = {nodot, led_dig_7};
			8 : led0 = {nodot, led_dig_8};
			9 : led0 = {nodot, led_dig_9};			
	   default:
	      led0 = led_off;
	   endcase
	  
		unique case (s / 10)
			0 : led1 = {1'b1, led_dig_0};
	      1 : led1 = {1'b1, led_dig_1};
			2 : led1 = {1'b1, led_dig_2};
	      3 : led1 = {1'b1, led_dig_3};
			4 : led1 = {1'b1, led_dig_4};
	      5 : led1 = {1'b1, led_dig_5};		
		default:
			led1 = led_off;
		endcase
	  
		unique case (m % 10)
			0 : led2 = {dot, led_dig_0};
	      1 : led2 = {dot, led_dig_1};
			2 : led2 = {dot, led_dig_2};
	      3 : led2 = {dot, led_dig_3};
			4 : led2 = {dot, led_dig_4};
	      5 : led2 = {dot, led_dig_5};
			6 : led2 = {dot, led_dig_6};
	      7 : led2 = {dot, led_dig_7};
			8 : led2 = {dot, led_dig_8};
			9 : led2 = {dot, led_dig_9};			
	   default:
	      led2 = led_off;
	   endcase
	  
	   unique case (m / 10)
			0 : led3 = {1'b1, led_dig_0};
	      1 : led3 = {1'b1, led_dig_1};
			2 : led3 = {1'b1, led_dig_2};
	      3 : led3 = {1'b1, led_dig_3};
			4 : led3 = {1'b1, led_dig_4};
	      5 : led3 = {1'b1, led_dig_5};		
		default:
			led3 = led_off;
		endcase
		
	   unique case (h % 10)
			0 : led4 = {dot, led_dig_0};
	      1 : led4 = {dot, led_dig_1};
			2 : led4 = {dot, led_dig_2};
	      3 : led4 = {dot, led_dig_3};
			4 : led4 = {dot, led_dig_4};
	      5 : led4 = {dot, led_dig_5};
			6 : led4 = {dot, led_dig_6};
	      7 : led4 = {dot, led_dig_7};
			8 : led4 = {dot, led_dig_8};
			9 : led4 = {dot, led_dig_9};			
	   default:
	      led4 = led_off;
	   endcase
		
		unique case (h / 10)
	     1 : led5 = {1'b1, led_dig_1};
		  2 : led5 = {1'b1, led_dig_2};
		default:
			led5 = led_off;
		endcase
	  
	end
	
endmodule