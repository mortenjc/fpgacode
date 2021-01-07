import register_types::addr_t;

module addr_alu (
  input alu_types::cmd_t cmd,
  input addr_t x,
  /* verilator lint_off UNUSED */
  input addr_t y,
  /* verilator lint_on UNUSED */
  output addr_t z,
  output bit zflag
);

always_comb begin
  unique case(cmd)
    alu_types::INC:
      z = x + 1;
    default:
      z = 0;
  endcase

  if (z == 0)
    zflag = 1;
  else
    zflag = 0;
end // always comb

endmodule // alu
