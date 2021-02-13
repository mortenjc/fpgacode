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
    output wire [7:0] led5
  );

  addr_t pcaddr_i = 16'b0;
  addr_t aaddr_i = 40000;
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


<<<<<<< HEAD
  data_t mmdatao_i;
  logic [15:0] maddro_i;
=======
  addr_t mmaddro_i;
>>>>>>> 7478166401e720fccbc1401147a57d6f10ba76fa
  memmux memmux_i(
    .mm(mm_i),
    .pc_in(pcaddr_i),
    .addr_in(aaddr_i),
<<<<<<< HEAD
    .addr_out(maddro_i)
    );

=======
    .addr_out(mmaddro_i)
    );


  data_t mdatai_i = 0;
>>>>>>> 7478166401e720fccbc1401147a57d6f10ba76fa
  cpumemory cpumemory_i(
    .clk(clk),
    .mw(mw_i),
    .addr(mmaddro_i),
    .data_in(mdatai_i),
    .data_out(mdatao_i)
    );
	 
  ledctrl ledctrl_i (
    .value(stateo_i),
	 .led(led5)
	 );

endmodule
