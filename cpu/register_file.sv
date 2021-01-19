// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief register file module
/// r0 is always 0 and can be used for discarding calculations
//===----------------------------------------------------------------------===//

import register_types::cmd_t;

module register_file(
  input bit clk,
  input cmd_t cmd,
  input  bit[31:0] data,
  output bit[31:0] r0,
  output bit[31:0] r1,
  output bit[31:0] r2,
  output bit[31:0] r3,
  output bit[31:0] r4,
  output bit[31:0] r5,
  output bit[31:0] r6,
  output bit[31:0] r7
  );


always_comb begin
  unique case(cmd)
    register_types::NONE: r0 = 0;
    register_types::r0: r0 = 0;
    register_types::r1: r1 = data;
    register_types::r2: r2 = data;
    register_types::r3: r3 = data;
    register_types::r4: r4 = data;
    register_types::r5: r5 = data;
    register_types::r6: r6 = data;
    register_types::r7: r7 = data;
    default:
      r0 = 0;
  endcase


end // always_comb

always_ff @(posedge clk) begin

end // always_ff

endmodule // registers
