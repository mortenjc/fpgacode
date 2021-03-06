// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief ALU command type definitions
//===----------------------------------------------------------------------===//

package alu_types;

typedef enum logic[2:0] {
  NONE, ADD, SUB, INC, DEC, AND, OR, NOT
} cmd_t /* verilator public */ ;

endpackage : alu_types
