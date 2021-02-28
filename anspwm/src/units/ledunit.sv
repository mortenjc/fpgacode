// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief grouping of LED handling modules
//===----------------------------------------------------------------------===//

module ledunit(
  input [15:0] value,
  input [29:0] debug,
  input [9:0] switches,
  output bit [9:0] leds,
  output bit [7:0] hex5,
  output bit [7:0] hex4,
  output bit [7:0] hex3,
  output bit [7:0] hex2,
  output bit [7:0] hex1,
  output bit [7:0] hex0
  );
  
  assign leds = switches;
  
  // LED SELECTION
  wire [4:0] led5_i, led4_i, led3_i, led2_i, led1_i, led0_i;
  ledselect ledsel(
    .sel(switches[9]),
    .val_a(value),
    .val_b(debug),
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

