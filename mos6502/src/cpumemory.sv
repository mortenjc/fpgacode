// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief cpumemory module
/// read and write data to/from (internal) memory
//===----------------------------------------------------------------------===//

typedef bit[15:0] addr_t /* verilator public */ ;
typedef bit[7:0] data_t /* verilator public */ ;

module cpumemory(
  input bit clk,
  input bit mw,
  input addr_t addr,
  input data_t data_in,
  output data_t data_out
  );

  parameter memory_file="";
  data_t memory_table[65536];

  initial begin
    $display("Loading rom.");
    $readmemh(memory_file, memory_table);
  end

  always_ff @(posedge clk) begin
    if (mw == 1) // write to mem
      memory_table[addr] <= data_in;
    else begin // read from mem
      data_out <= memory_table[addr];
    end
  end

  endmodule
