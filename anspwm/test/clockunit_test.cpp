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


TEST_F(ClockunitTest, TwoClocksInternal) {
  cku->clk_src_sel = 0;

  cku->clk_src_fpga = 1;
  cku->clk_src_ext = 0;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 0);

  cku->clk_src_fpga = 0;
  cku->clk_src_ext = 0;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 0);

  cku->clk_src_fpga = 1;
  cku->clk_src_ext = 0;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 0);

  cku->clk_src_fpga = 0;
  cku->clk_src_ext = 0;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 0);
}



TEST_F(ClockunitTest, ExternalClocks) {
  cku->clk_src_sel = 0;

  cku->clk_src_fpga = 0;
  cku->clk_src_ext = 1;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 0);

  cku->clk_src_fpga = 0;
  cku->clk_src_ext = 0;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 0);


  cku->clk_src_sel = 1;

  cku->clk_src_fpga = 0;
  cku->clk_src_ext = 1;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 1);

  cku->clk_src_fpga = 0;
  cku->clk_src_ext = 0;
  cku->clk_src_button = 0;
  cku->eval();
  ASSERT_EQ(cku->clk_out, 0);
  ASSERT_EQ(cku->clk_fast_out, 0);
}

TEST_F(ClockunitTest, Test50Mhz) {
  uint32_t ctr_slow{0};
  uint32_t ctr_fast{0};
  cku->clk_src_sel = 0; // 50MHz
  for (int i = 0; i < 50'000'000; i++) {
    cku->clk_src_fpga = 1;
    cku->clk_src_ext = 1;
    cku->clk_src_button = 1;
    cku->eval();

    cku->clk_src_fpga = 0;
    cku->clk_src_ext = 0;
    cku->clk_src_button = 0;
    cku->eval();

    if (cku->clk_out)
      ctr_slow++;
    if (cku->clk_fast_out)
      ctr_fast++;
  }
  ASSERT_EQ(ctr_fast, 5'000'000);
  ASSERT_EQ(ctr_slow, 100);
}

// TEST_F(ClockunitTest, Test6553600Hz) {
//   uint32_t ctr_slow{0};
//   uint32_t ctr_fast{0};
//   cku->clk_src_sel = 1;
//   //for (int i = 0; i < 6'553'600; i++) {
//   for (int i = 0; i < 20; i++) {
//     cku->clk_src_fpga = 1;
//     cku->clk_src_ext = 1;
//     cku->clk_src_button = 1;
//     cku->eval();
//
//     cku->clk_src_fpga = 0;
//     cku->clk_src_ext = 0;
//     cku->clk_src_button = 0;
//     cku->eval();
//
//     //printf("0%d: slow %d, fast %d\n", i, cslow, cfast);
//     if (cku->clk_out) {
//       ctr_slow++;
//     }
//     if (cku->clk_fast_out) {
//       ctr_fast++;
//     }
//   }
//   //ASSERT_EQ(ctr_fast, 6553600);
//   //ASSERT_EQ(ctr_slow, 100);
// }



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
