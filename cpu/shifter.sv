
import shifter_types::cmd_t;

module shifter(
  input cmd_t cmd,
  input bit[31:0] B,
  input Cin,
  output bit[31:0] data,
  output bit C
  );

  bit[31:0] new_data;
  bit new_C;

  always_comb begin
    new_C = 0;

    unique case(cmd)
      shifter_types::SHL: new_data = {B[30:0], 1'b0};
      shifter_types::SHR: new_data = {1'b0, B[31:1]};
      shifter_types::ROL: {new_C, new_data} = {B[31], B[30:0], Cin};
      shifter_types::ROR: {new_C, new_data} = {B[0], Cin, B[31:1]};
      default:
        new_data = 0;
    endcase

    data = new_data;
    C = new_C;
  end

  endmodule
