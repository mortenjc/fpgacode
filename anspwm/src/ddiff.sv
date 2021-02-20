// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief delayed subtraction C = A - B, where B = A(n-1)
//===----------------------------------------------------------------------===//

module ddiff (
  input bit clk,
  input bit rst_n,
  input [15:0] A,
  input bit A_sign,   // 1 is negative

  output [15:0] C,
  output bit C_sign
  );

  bit [15:0] B;
  bit B_sign;
  bit [15:0] new_C;
  bit new_C_sign;

  always_comb begin
    unique case ({A_sign, B_sign})
      2'b00: begin
        if (A >= B) begin
          new_C = A - B;
          new_C_sign = 0;
        end else begin
          new_C = B - A;
          new_C_sign = 1;
        end
      end
      2'b01: begin
        new_C_sign = 0;
        new_C = A + B;
      end
      2'b10: begin
        new_C_sign = 1;
        new_C = A + B;
      end
      2'b11:  begin
        if (A >= B) begin
          new_C = A - B;
          new_C_sign = 1;
        end else begin
          new_C = B - A;
          new_C_sign = 0;
        end
      end
    endcase
  end

  always_ff @(posedge clk) begin
    if (~rst_n) begin
      $display("RESET");
      B <= 0;
      B_sign <= 0;
		C <= 0;
		C_sign <= 0;
    end else begin
      B <= A;
      B_sign <= A_sign;
      C <= new_C;
      C_sign <= new_C_sign;
      $display("A: %4d, AS: %0d, B: %4d, BS: %0d, C: %4d, CS: %0d", A, A_sign, B, B_sign, C, C_sign);
    end
	end



 endmodule
