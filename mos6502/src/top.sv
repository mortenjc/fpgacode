// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief '6502' CPU
//===----------------------------------------------------------------------===//

import common_types::state_t;
import common_types::data_t;
import common_types::il_t;
import common_types::mm_t;
import common_types::mw_t;

module top(
    input clk,
    input reset,
    output wire [7:0] led
  );

  logic [15:0] pcaddr_i = 4'h0000;
  logic [15:0] aaddr_i = 4'haaaa;
  logic mw_i;
  logic mm_i;
  logic il_i;
  logic [7:0]] mdatao_i;

  logic state_i;
  logic il_i;
  control control_i(
    .clk(clk),
    .state(state_i),
    .inst(mdatao_i),
    .next_state(state_i),
    .il(il_i),
    .mw(mw_i),
    .mm(mm_i)
    );


  logic [7:0]] mmdatao_i;
  memmux memmux_i(
    .mm(mm_i),
    .pc_in(pcaddr_i),
    .addr_in(aaddr_i),
    .addr_out(mmdatao_i)
    );


  logic [15:0] maddro_i;

  cpumemory cpumemory_i(
    .clk(clk),
    .mw(mw_i),
    .addr(maddr_i),
    .data_in(mdata_i),
    .data_out(mdatao_i)
    );

endmodule
