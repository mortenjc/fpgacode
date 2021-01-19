// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief shifter command definitions
//===----------------------------------------------------------------------===//

package shifter_types;

typedef enum logic[2:0] {
  NONE, SHL, SHR, ROL, ROR
} cmd_t /* verilator public */ ;

endpackage : shifter_types
