
import register_types::addr_t;

module vars (
  input byte unsigned V,
  input addr_t FP,
  input addr_t GP,
  output addr_t addr
);

always_comb begin
  addr = 0;
  /* verilator lint_off WIDTH */
  unique if (V >= 8'h01 && V <= 8'h0F)
    addr = FP + 2 * addr_t'(V - 1);
  else if (V >= 8'h10)
    addr = GP + 2 * addr_t'(V - 8'h10);
  else
    addr = 0;
  /* verilator lint_on WIDTH */
end // always comb

endmodule // vars
