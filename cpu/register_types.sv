// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief register name definitions
//===----------------------------------------------------------------------===//

package register_types;

typedef enum logic[3:0] {
  NONE, r0, r1, r2, r3, r4, r5, r6, r7
} cmd_t /* verilator public */ ;

endpackage : register_types
