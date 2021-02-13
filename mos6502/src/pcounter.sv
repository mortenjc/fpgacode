// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief program counter (PC) module
//===----------------------------------------------------------------------===//

import common_types::addr_t;
import common_types::ps_t;

module pcounter(
    input bit clk,
    input ps_t ps,
    input addr_t pc_in,
    output addr_t pc_out
  );

addr_t new_pc;
addr_t pc;

always_comb begin
  unique case(ps)
    common_types::HOLD: new_pc = pc;
    common_types::INC: new_pc = pc + 1;
    common_types::ABS: new_pc = pc_in;
    default:
      new_pc = 16'hFFFF;
  endcase
end

always_ff @(posedge clk) begin
    pc <= new_pc;
    pc_out <= new_pc;
end

endmodule
