// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief switch between sum and contributions
//===----------------------------------------------------------------------===//

module ledselect(
  input sel,
  input [15:0] val_a,
  input [29:0] val_b,
  output [4:0] led5,
  output [4:0] led4,
  output [4:0] led3,
  output [4:0] led2,
  output [4:0] led1,
  output [4:0] led0
  );

  always_comb begin
    if (sel == 0) begin // A - sum
      led5 = {5'b0};
      led4 = {5'b0};
      led3 = {1'b0, val_a[15:12]};
      led2 = {1'b0, val_a[11: 8]};
      led1 = {1'b0, val_a[ 7: 4]};
      led0 = {1'b0, val_a[ 3: 0]};
	 end else begin // B - contributions
      led5 = val_b[29:25];
      led4 = val_b[24:20];
      led3 = val_b[19:15];
      led2 = val_b[14:10];
      led1 = val_b[9:5];
      led0 = val_b[4:0];
	 end
  end

endmodule
