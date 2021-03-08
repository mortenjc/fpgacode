// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief generate target of 1v +- n * 10uV
//===----------------------------------------------------------------------===//

module target1v(
  input bit [5:0] value,
  output bit [31:0] target
  );
  
  always_comb begin
    target = 429359290 + value * 4295;
  end
  
endmodule