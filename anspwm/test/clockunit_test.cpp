// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for the clock unit
//===----------------------------------------------------------------------===//

#include <clockunit.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

// input bit clk_src_fpga,      // 50MHz DE10-Lite board master clock
// input bit clk_src_ext,       // 6.5536MHz from external pin
// input bit clk_src_button,    // from push button
// input bit [1:0] clk_src_sel, // choose which source
//
// output bit clk_out,
// output bit clk_fast_out

class ClockunitTest: public ::testing::Test {
protected:
  clockunit * cku;

  void SetUp( ) {
    cku = new clockunit;
  }

  void TearDown( ) {
    cku->final();
    delete cku;
  }
};


TEST_F(ClockunitTest, Empty) {
  ASSERT_EQ(1,1);
}




int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
