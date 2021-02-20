// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief combining four stages
//===----------------------------------------------------------------------===//

module fourmods(
  input clk,      // 50MHz -  PIN_P11
  input clk_btn,  // KEY0 - PIN_B8
  input rst_n,    // KEY1 - PIN_A7
  input clk_sel,  // SW8 - PIN_B14
  input osel,     // SW9 - PIN_F15
  input bit [7:0] tgt_val, // SW7 - SW0 
  output bit pwm_out,
  output bit [8:0] leds,
  output bit [7:0] hex5,
  output bit [7:0] hex4,
  output bit [7:0] hex3,
  output bit [7:0] hex2,
  output bit [7:0] hex1,
  output bit [7:0] hex0
  );
  
  
  bit clk_in;
  assign leds[0] = clk_in;
  assign leds[1] = rst_n;
  
 
  // Generate 100 Hz and 5MHz 
  bit clk_100Hz;
  bit clk_5MHz;
 
  clockdiv clockdiv_i(
    .clk_in(clk),
	 .clk_slow(clk_100Hz),
	 .clk_fast(clk_5MHz)
  );
  
  // Select manual or slow clock
  clocksel clocksel_i(
    .sel(clk_sel),
	 .clk_a(clk_btn),
	 .clk_b(clk_100Hz),
	 .clk_out(clk_in)
 );

  wire [31:0] tgt_in_i = {24'h4995cd, tgt_val};
  wire [15:0] val1;
  wire [15:0] val2;
  wire [15:0] val3;
  wire [15:0] val4;

  
  // MODULE 1
  wire [31:0] mod1_diff_out;
  
  wire [15:0] val1_out;
  anspwm mod1(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(tgt_in_i),
    .val_out(val1_out),
    .diff_out(mod1_diff_out)
    );

	 
  // MOD1 DELAY 1
  wire [15:0] m1d1_out;
  wire m1d1sgn_out;
  
  delay1clk mod1d1(
     .clk(clk_in),
    .rst_n(rst_n),
	 .val_in(val1_out),
	 .sign_in(1'b0),
	 .val_out(m1d1_out),
	 .sign_out(m1d1sgn_out)
  );

  // MOD1 DELAY 2  
  wire [15:0] m1d2_out;
  wire m1d2sgn_out;
  
  delay1clk m1d2(
     .clk(clk_in),
    .rst_n(rst_n),
	 .val_in(m1d1_out),
	 .sign_in(m1d1sgn_out),
	 .val_out(m1d2_out),
	 .sign_out(m1d2sgn_out)
  );
  
  // MOD1 DELAY 3
  wire m1d3sgn_out;
  
  delay1clk m1d3(
     .clk(clk_in),
    .rst_n(rst_n),
	 .val_in(m1d2_out),
	 .sign_in(m1d2sgn_out),
	 .val_out(val1),
	 .sign_out(m1d3sgn_out)
  );

  // MODULE 2
  wire [31:0] mod2_diff_out;
  anspwm mod2(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(mod1_diff_out),
    .val_out(val2),
    .diff_out(mod2_diff_out)
    );
	 
	wire [15:0] c1;
	wire c1_sgn;
	ddiff ddiff1(
	.clk(clk_in),
	.rst_n(rst_n),
	.A(val2),
	.A_sign(1'b0),
   .C(c1),
	.C_sign(c1_sgn)
	);
	
	// MOD2 DELAY 1
  wire [15:0] m2d1_out;
  wire m2d1sgn_out;
  
  delay1clk m2d1(
     .clk(clk_in),
    .rst_n(rst_n),
	 .val_in(c1),
	 .sign_in(c1_sgn),
	 .val_out(m2d1_out),
	 .sign_out(m2d1sgn_out)
  );

  // MOD2 DELAY 2  
  wire [15:0] m2d2_out;
  wire m2d2sgn_out;
  
  delay1clk m2d2(
     .clk(clk_in),
    .rst_n(rst_n),
	 .val_in(m2d1_out),
	 .sign_in(m2d1sgn_out),
	 .val_out(m2d2_out),
	 .sign_out(m2d2sgn_out)
  );

  // MODULE 3
  wire [31:0] mod3_diff_out;
  anspwm mod3(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(mod2_diff_out),
    .val_out(val3),
    .diff_out(mod3_diff_out)
    );
	 
	wire [15:0] c2_1;
	wire c2_sgn_1;
	ddiff ddiff2(
	.clk(clk_in),
	.rst_n(rst_n),
	.A(val3),
	.A_sign(1'b0),
   .C(c2_1),
	.C_sign(c2_sgn_1)
	);
	
	wire [15:0] c2_2;
	wire c2_sgn_2;
	ddiff ddiff2_2(
	.clk(clk_in),
	.rst_n(rst_n),
	.A(c2_1),
	.A_sign(c2_sgn_1),
   .C(c2_2),
	.C_sign(c2_sgn_2)
	);
	
	// MOD3 DELAY 1 (final)
  wire [15:0] m3d1_out;
  wire m3d1sgn_out;
  
  delay1clk m3d1(
     .clk(clk_in),
    .rst_n(rst_n),
	 .val_in(c2_2),
	 .sign_in(c2_sgn_2),
	 .val_out(m3d1_out),
	 .sign_out(m3d1sgn_out)
  );

  // MODULE 4
  bit [31:0] unused;
  anspwm mod4(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(mod3_diff_out),
    .val_out(val4),
    .diff_out(unused)
    );
	 
	wire [15:0] c3_1;
	wire c3_sgn_1;
	ddiff ddiff3(
	.clk(clk_in),
	.rst_n(rst_n),
	.A(val4),
	.A_sign(1'b0),
   .C(c3_1),
	.C_sign(c3_sgn_1)
	);
	
	wire [15:0] c3_2;
	wire c3_sgn_2;
	ddiff ddiff3_2(
	.clk(clk_in),
	.rst_n(rst_n),
	.A(c3_1),
	.A_sign(c3_sgn_1),
   .C(c3_2),
	.C_sign(c3_sgn_2)
	); 
	
	wire [15:0] c3_3;
	wire c3_sgn_3;
	ddiff ddiff3_3(
	.clk(clk_in),
	.rst_n(rst_n),
	.A(c3_2),
	.A_sign(c3_sgn_2),
   .C(c3_3),
	.C_sign(c3_sgn_3)
	);
	
	
  // SUM
  wire [15:0] sum_i;
  add4wsign add4wsign_i(
    .clk(clk_in),
	 .rst_n(rst_n),
	 .c0(val1),
	 .c1(m2d2_out),
	 .c1_sgn(m2d2sgn_out),
	 .c2(m3d1_out),
	 .c2_sgn(m3d1sgn_out),
	 .c3(c3_3),
	 .c3_sgn(c3_sgn_3),
	 .val(sum_i)
  );
  
  //
  //
  pwm16 pwm16_i(
    .clk(clk_5MHz),
	 .set_val(clk_in),
	 .val(sum_i),
	 .clk_out(pwm_out)
  );
  //
  //


  // LED SELECTION
  wire [4:0] led5_i, led4_i, led3_i, led2_i, led1_i, led0_i;
  ledselect ledsel(
    .sel(osel),
	 .val_a(sum_i),
	 .val_b(
	   {
		 1'b0,        tgt_in_i[7:4],
		 1'b0,        tgt_in_i[3:0],
		 1'b0,        val1[3:0], 
	    m2d2sgn_out, m2d2_out[3:0],
	    m3d1sgn_out, m3d1_out[3:0],
	    c3_sgn_3,    c3_3[3:0]
	   }
	 ),
	 .led5(led5_i),
	 .led4(led4_i),
	 .led3(led3_i),
	 .led2(led2_i),
	 .led1(led1_i),
	 .led0(led0_i)
  ); 
	 
  //
  // hex5 - hex0 - either  contributions or sum
  ledctrl ledctrl_5(
	 .value(led5_i),
	 .led(hex5)
	 );
	 
  ledctrl ledctrl_4(
	 .value(led4_i),
	 .led(hex4)
	 );
	 
  ledctrl ledctrl_3(
	 .value(led3_i),
	 .led(hex3)
	 );
	 
  ledctrl ledctrl_2(
	 .value(led2_i),
	 .led(hex2)
	 );
	 
  ledctrl ledctrl_1(
	 .value(led1_i),
	 .led(hex1)
	 );
	 
  ledctrl ledctrl_0(
	 .value(led0_i),
	 .led(hex0)
	 );	 
endmodule
