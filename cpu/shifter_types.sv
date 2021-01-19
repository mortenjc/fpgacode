
package shifter_types;

typedef enum logic[2:0] {
  NONE, SHL, SHR, ROL, ROR
} cmd_t /* verilator public */ ;

endpackage : shifter_types
