// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief Top level module - refactored but still too messy
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


// Stage 1 - quantize, 0 delayed diff, 3 clk output delay
  wire [31:0] s2target;
  wire [15:0] c0_out;
  wire c0s_out;
  stage1(
    .clk(clk_in),
    .rst_n(rst_n),
    .A(tgt_in_i),
    .C(c0_out),
    .Csgn(c0s_out),
    .nxttgt(s2target)
    );

// Stage 2 - quantize, 1 delayed diff, 2 clk output delay
  wire [31:0] s3target;
  wire [15:0] c1_out;
  wire c1s_out;
  stage2(
    .clk(clk_in),
    .rst_n(rst_n),
    .A(s2target),
    .C(c1_out),
    .Csgn(c1s_out),
    .nxttgt(s3target)
    );

// Stage 3 - quantize, 2 delayed diff, 1 clk output delay
  wire [31:0] s4target;
  wire [15:0] c2_out;
  wire c2s_out;
  stage3(
    .clk(clk_in),
    .rst_n(rst_n),
    .A(s3target),
    .C(c2_out),
    .Csgn(c2s_out),
    .nxttgt(s4target)
    );

// Stage 4 - quantize, 3 delayed diff, 0 clk output delay
  wire [15:0] c3_out;
  wire c3s_out;
  stage3(
    .clk(clk_in),
    .rst_n(rst_n),
    .A(s4target),
    .C(c3_out),
    .Csgn(c3s_out),
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
