// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief common definitions used across modules
//===----------------------------------------------------------------------===//

package common_types;

// instruction register load/noload control
typedef enum logic {
  NOLOAD, LOAD
} il_t /* verilator public */ ;

// memory read/write control
typedef enum logic {
  WRITE, READ
} mw_t /* verilator public */ ;

// memory mux selecting between PC or address register
// for memory access
typedef enum logic {
  PC_ADDR, A_ADDR
} mm_t /* verilator public */ ;

// Control states for the multi-cycle operation
typedef enum logic {
  INF, EX0
} state_t /* verilator public */ ;

typedef bit[15:0] addr_t /* verilator public */ ;
typedef bit[7:0] data_t /* verilator public */ ;
typedef bit[7:0] opc_t /* verilator public */ ;


endpackage : common_types
