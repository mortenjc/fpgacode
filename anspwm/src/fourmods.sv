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






  // Generate 100 Hz and 5MHz
  bit clk_100Hz;
  bit clk_5MHz;

  clockdiv clockdiv_i(
    .clk_in(clk),
    .clk_slow(clk_100Hz),
    .clk_fast(clk_5MHz)
  );

  // Select manual or 100Hz clock
  bit clk_in;
  clocksel clocksel_i(
    .sel(clk_sel),
    .clk_a(clk_btn),
    .clk_b(clk_100Hz),
    .clk_out(clk_in)
  );
  
  assign leds[0] = clk_in;
  assign leds[1] = rst_n;

  wire [31:0] tgt_in_i = {24'h4995cd, tgt_val};


  // MODULE 1
  wire [31:0] mod1_diff_out;
  wire [15:0] val1;
  anspwm mod1(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(tgt_in_i),
    .val_out(val1),
    .diff_out(mod1_diff_out)
  );

  // delay this output 3 clocks
  wire [15:0] c0_out;
  wire c0s_out;
  delay3clk m1delay(
    .clk(clk_in),
    .rst_n(rst_n),
    .val_in(val1),
    .sign_in(1'b0),
    .d3_out(c0_out),
    .d3s_out(c0s_out)
  );


  // MODULE 2
  wire [31:0] mod2_diff_out;
  wire [15:0] val2;
  anspwm mod2(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(mod1_diff_out),
    .val_out(val2),
    .diff_out(mod2_diff_out)
  );

  wire [15:0] m2d1;
  wire m2d1s;
  ddiff ddiff1(
    .clk(clk_in),
    .rst_n(rst_n),
    .A(val2),
    .A_sign(1'b0),
    .C(m2d1),
    .C_sign(m2d1s)
  );

  // delay this output 2 clocks
  wire [15:0] c1_out;
  wire c1s_out;
  delay3clk m2delay(
    .clk(clk_in),
    .rst_n(rst_n),
    .val_in(m2d1),
    .sign_in(m2d1s),
    .d2_out(c1_out),
    .d2s_out(c1s_out)
  );


  // MODULE 3
  wire [31:0] mod3_diff_out;
  wire [15:0] val3;
  anspwm mod3(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(mod2_diff_out),
    .val_out(val3),
    .diff_out(mod3_diff_out)
  );

  wire [15:0] m3d1;
  wire m3d1s;
  ddiff ddiff2(
    .clk(clk_in),
    .rst_n(rst_n),
    .A(val3), .A_sign(1'b0),
    .C(m3d1), .C_sign(m3d1s)
  );

  wire [15:0]m3d2;
  wire m3d2s;
  ddiff ddiff2_2(
    .clk(clk_in),
    .rst_n(rst_n),
    .A(m3d1), .A_sign(m3d1s),
    .C(m3d2), .C_sign(m3d2s)
   );

  // delay this output 1 clock
  wire [15:0] c2_out;
  wire c2s_out;
  delay3clk m3delay(
    .clk(clk_in),
    .rst_n(rst_n),
    .val_in(m3d2),
    .sign_in(m3d2s),
    .d2_out(c2_out),
    .d2s_out(c2s_out)
  );


  // MODULE 4
  bit [31:0] unused;
  wire [15:0] val4;
  anspwm mod4(
    .clk(clk_in),
    .rst_n(rst_n),
    .tgt_in(mod3_diff_out),
    .val_out(val4),
    .diff_out(unused)
  );

   wire [15:0] m4d1;
   wire m4d1s;
   ddiff ddiff3(
     .clk(clk_in),
     .rst_n(rst_n),
     .A(val4), .A_sign(1'b0),
     .C(m4d1), .C_sign(m4d1s)
   );

   wire [15:0] m4d2;
   wire m4d2s;
   ddiff ddiff3_2(
     .clk(clk_in),
     .rst_n(rst_n),
     .A(m4d1), .A_sign(m4d1s),
     .C(m4d2), .C_sign(m4d2s)
   );

   wire [15:0] c3_out;
   wire c3s_out;
   ddiff ddiff3_3(
     .clk(clk_in),
     .rst_n(rst_n),
     .A(m4d2),   .A_sign(m4d2s),
     .C(c3_out), .C_sign(c3s_out)
   );


  // SUM
  wire [15:0] duty_cycle;
  add4wsign add4wsign_i(
    .clk(clk_in),
    .rst_n(rst_n),
    .c0(c0_out),
    .c1(c1_out),
    .c1s(c1s_out),
    .c2(c2_out),
    .c2s(c2s_out),
    .c3(c3_out),
    .c3s(c3s_out),
    .sum(duty_cycle)
  );

  //
  //
  pwm16 pwm16_i(
    .clk(clk_5MHz),
     .set_val(clk_in),
     .val(duty_cycle),
     .clk_out(pwm_out)
  );
  //
  //


  // LED SELECTION
  wire [4:0] led5_i, led4_i, led3_i, led2_i, led1_i, led0_i;
  ledselect ledsel(
    .sel(osel),
     .val_a(duty_cycle),
     .val_b(
       {
          1'b0,    tgt_in_i[7:4],
          1'b0,    tgt_in_i[3:0],
          1'b0,    c0_out[3:0],
          c1s_out, c1_out[3:0],
          c2s_out, c2_out[3:0],
          c3s_out, c3_out[3:0]
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
