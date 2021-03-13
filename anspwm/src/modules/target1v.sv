// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief generate target of 1v +- n * 1uV 
//===----------------------------------------------------------------------===//

module target1v(
  input bit [5:0] value,
  output bit [31:0] target
  );
  
  always_comb begin
    //target = 429359290 + value * 4295; // gives 10uV resolution
	 target = 429359290 + value * 430;  // gives 1uV resolution
  end
  
endmodule