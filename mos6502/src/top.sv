// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief '6502' CPU
//===----------------------------------------------------------------------===//

import common_types::state_t;
import common_types::addr_t;
import common_types::data_t;
import common_types::il_t;
import common_types::mm_t;
import common_types::mw_t;

module top(
    input clk,
    output wire [7:0] led5,
	 output wire [7:0] led4,
	 output wire [7:0] led3
  );

  addr_t pcaddr_i = 16'b0;
  addr_t aaddr_i = 16'h0002;
  mw_t mw_i;
  mm_t mm_i;
  data_t mdatao_i;
 

  state_t stateo_i;
  logic il_i;
  control control_i(
    .clk(clk),
	 .stateo(stateo_i),
    .inst(mdatao_i),
    .il(il_i),
    .mw(mw_i),
    .mm(mm_i)
    );



  addr_t maddro_i;
  memmux memmux_i(
    .mm(mm_i),
    .pc_in(pcaddr_i),
    .addr_in(aaddr_i),
    .addr_out(maddro_i)
    );


  data_t mdatai_i = 0;
  cpumemory cpumemory_i(
    .clk(clk),
    .mw(mw_i),
    .addr(maddro_i),
    .data_in(mdatai_i),
    .data_out(mdatao_i)
    );
	 
  ledctrl led5_i (
    .value(stateo_i),
	 .led(led5)
	 );
	 
  ledctrl led4_i (
    .value(mdatao_i[7:4]),
	 .led(led4)
	 );
	 
  ledctrl led3_i (
    .value(mdatao_i[3:0]),
	 .led(led3)
	 );

endmodule
