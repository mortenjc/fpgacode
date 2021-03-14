// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief generate target of 1v +- n * 1uV
//===----------------------------------------------------------------------===//

module target1v#(
  parameter RESOLUTION=RES_1_UV)(
  input bit [5:0] value,
  output bit [31:0] target
  );

  parameter RES_10_UV = 4295; // gives 10uV steps
  parameter RES_1_UV = 430;   // gives 1uV steps

  always_comb begin
    target = 429496730 + ({26'b0,value} - 32) * RESOLUTION;
  end

endmodule
