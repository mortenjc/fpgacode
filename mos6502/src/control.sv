// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief cpu instruction register
//===----------------------------------------------------------------------===//

import common_types::state_t;
import common_types::data_t;
import common_types::il_t;
import common_types::mm_t;
import common_types::mw_t;

/* verilator lint_off UNUSED */

module control(
    input clk,
    input state_t state,
    input data_t inst,
    output state_t next_state,
    output il_t il,
    output mw_t mw,
    output mm_t mm
  );


state_t new_next_state;

always_comb begin
  unique case(state)
    common_types::INF: begin
      il = common_types::LOAD;
      mm = common_types::PC_ADDR;
      mw = common_types::READ;
      new_next_state = common_types::EX0;
    end

    common_types::EX0: begin
      il = common_types::NOLOAD;
      mm = common_types::A_ADDR;
      mw = common_types::READ;
      new_next_state = common_types::INF;
    end

    default: begin
    il = common_types::LOAD;
    mm = common_types::PC_ADDR;
    mw = common_types::READ;
    new_next_state = common_types::INF;
    end

  endcase
end


  always_ff @(posedge clk) begin
    next_state <= new_next_state;
  end
/* verilator lint_on UNUSED */
endmodule
