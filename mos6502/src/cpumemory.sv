// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief cpumemory module
/// read and write data to/from (internal) memory
//===----------------------------------------------------------------------===//

import common_types::addr_t;
import common_types::data_t;
import common_types::mw_t;

module cpumemory(
  input bit clk,
  input mw_t mw,
  input addr_t addr,
  input data_t data_in,
  output data_t data_out
  );

  parameter memory_file="memory_test.data";
  data_t memory_table[256*256];

  initial begin
    $display("Loading rom.");
    $readmemh(memory_file, memory_table);
  end

  always_ff @(posedge clk) begin
    if (mw == common_types::WRITE)
      memory_table[addr] <= data_in;
    else begin // read from mem
      data_out <= memory_table[addr];
    end
  end

  endmodule
