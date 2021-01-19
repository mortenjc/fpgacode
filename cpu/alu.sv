// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief ALU module
/// Currently implements basic operations ADD, SUB, INC, DEC, AND, OR, NOT
//===----------------------------------------------------------------------===//

import alu_types::cmd_t;

module alu(
  input cmd_t cmd,
  input bit[31:0] A,
  input bit[31:0] B,
  //input bit Cin,
  output logic[31:0] data,
  output bit V,
  output bit C,
  output bit N,
  output bit Z
  );


  bit[31:0] new_data;
  bit new_Z;
  bit new_N;
  bit new_V;
  bit new_C;



  always_comb begin
    new_C = 0;

    unique case(cmd)
      alu_types::ADD: {new_C, new_data} = A + B;
      alu_types::SUB: {new_C, new_data} = A - B;

      alu_types::INC: new_data = A + 1;
      alu_types::DEC: new_data = A - 1;

      alu_types::AND: new_data = A & B;
      alu_types::OR: new_data = A | B;
      alu_types::NOT: new_data = ~A;

      default:
        new_data = 0;
    endcase

    if (new_data == 0)
      new_Z = 1;
    else
      new_Z = 0;

    if (new_data[31])
      new_N = 1;
    else
      new_N = 0;

    new_V = 0;

    data = new_data;
    Z = new_Z;
    N = new_N;
    V = new_V;
    C = new_C;
  end

  endmodule
