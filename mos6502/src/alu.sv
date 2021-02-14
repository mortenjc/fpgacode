// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief ALU
//===----------------------------------------------------------------------===//

import common_types::data_t;
import common_types::alu_t;

module alu(
    input alu_t func,
    input data_t a_in,
    input data_t b_in,
    input bit c_in,
    output data_t out,
    output bit c_out
  );

/* verilator lint_off UNUSED */
bit tmp;
/* verilator lint_on UNUSED */

always_comb begin
  unique case(func)
    common_types::ANOP: {c_out, out} = {c_in, a_in};
    common_types::AINC: begin
      {tmp, out} = a_in + 1;
    end
    /* verilator lint_off WIDTH */
    common_types::AADD: {c_out, out} = a_in + b_in + c_in;
    common_types::ASUB: {c_out, out }= a_in - b_in - c_in;
    /* verilator lint_on WIDTH */
  endcase

end

endmodule
