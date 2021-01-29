

module ledctrl(
	input bit [4:0] h,
	input bit [5:0] m,
	input bit [5:0] s,
	output bit[7:0] led0,
	output bit[7:0] led1,
	output bit[7:0] led2,
	output bit[7:0] led3,
	output bit[7:0] led4,
	output bit[7:0] led5
	);
	
	bit [7:0] led_dig_0 = 'b11000000;
	bit [7:0] led_dig_1 = 'b11111001;
	bit [7:0] led_dig_2 = 'b10100100;
	bit [7:0] led_dig_3 = 'b10110000;
	bit [7:0] led_dig_4 = 'b10011001;
	bit [7:0] led_dig_5 = 'b10010010;
	bit [7:0] led_dig_6 = 'b10000010;
	bit [7:0] led_dig_7 = 'b11111000;
	bit [7:0] led_dig_8 = 'b10000000;
	bit [7:0] led_dig_9 = 'b10010000;
	bit [7:0] led_off = 'b11111111;
	
	always_comb begin
		unique case (s % 10)
			0 : led0 = led_dig_0;
	      1 : led0 = led_dig_1;
			2 : led0 = led_dig_2;
	      3 : led0 = led_dig_3;
			4 : led0 = led_dig_4;
	      5 : led0 = led_dig_5;
			6 : led0 = led_dig_6;
	      7 : led0 = led_dig_7;
			8 : led0 = led_dig_8;
			9 : led0 = led_dig_9;			
	   default:
	      led0 = led_off;
	   endcase
	  
		unique case (s / 10)
			0 : led1 = led_dig_0;
	      1 : led1 = led_dig_1;
			2 : led1 = led_dig_2;
	      3 : led1 = led_dig_3;
			4 : led1 = led_dig_4;
	      5 : led1 = led_dig_5;		
		default:
			led1 = led_off;
		endcase
	  
		unique case (m % 10)
			0 : led2 = led_dig_0 & 8'b01111111;
	      1 : led2 = led_dig_1 & 8'b01111111;
			2 : led2 = led_dig_2 & 8'b01111111;
	      3 : led2 = led_dig_3 & 8'b01111111;
			4 : led2 = led_dig_4 & 8'b01111111;
	      5 : led2 = led_dig_5 & 8'b01111111;
			6 : led2 = led_dig_6 & 8'b01111111;
	      7 : led2 = led_dig_7 & 8'b01111111;
			8 : led2 = led_dig_8 & 8'b01111111;
			9 : led2 = led_dig_9 & 8'b01111111;			
	   default:
	      led2 = led_off;
	   endcase
	  
	   unique case (m / 10)
			0 : led3 = led_dig_0;
	      1 : led3 = led_dig_1;
			2 : led3 = led_dig_2;
	      3 : led3 = led_dig_3;
			4 : led3 = led_dig_4;
	      5 : led3 = led_dig_5;		
		default:
			led3 = led_off;
		endcase
		
	   unique case (h % 10)
			0 : led4 = led_dig_0 & 8'b01111111;
	      1 : led4 = led_dig_1 & 8'b01111111;
			2 : led4 = led_dig_2 & 8'b01111111;
	      3 : led4 = led_dig_3 & 8'b01111111;
			4 : led4 = led_dig_4 & 8'b01111111;
	      5 : led4 = led_dig_5 & 8'b01111111;
			6 : led4 = led_dig_6 & 8'b01111111;
	      7 : led4 = led_dig_7 & 8'b01111111;
			8 : led4 = led_dig_8 & 8'b01111111;
			9 : led4 = led_dig_9 & 8'b01111111;			
	   default:
	      led4 = led_off;
	   endcase
		
		unique case (h / 10)
	      1 : led5 = led_dig_1;
			2 : led5 = led_dig_2;
		default:
			led5 = led_off;
		endcase
	  
	end
	
endmodule