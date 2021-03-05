// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for dspmod
//===----------------------------------------------------------------------===//

#include <dspmod.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class DSPModTest: public ::testing::Test {
protected:
  dspmod * dsp;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      dsp->clk = 1;
      dsp->eval();
      dsp->clk = 0;
      dsp->eval();
    }
  }

  void reset() {
    dsp->target = 0;
    dsp->rst_n = 0;
    dsp->clk = 1;
    dsp->eval();
    dsp->rst_n = 1;
    dsp->clk = 0;
    dsp->eval();
}

  void SetUp( ) {
    dsp = new dspmod;
    reset();
  }

  void TearDown( ) {
    dsp->final();
    delete dsp;
  }
};

TEST_F(DSPModTest, Basic) {
  dsp->target = 1234554321;
  dsp->eval();
  clock_ticks(1);
  ASSERT_EQ(dsp->value, 0);

  clock_ticks(1);
  ASSERT_EQ(dsp->value, 0);

  clock_ticks(1);
  ASSERT_EQ(dsp->value, 18837);

  clock_ticks(1);
  printf("%d\n", dsp->value);

  clock_ticks(1);
  printf("%d\n", dsp->value);

  clock_ticks(1);
  printf("%d\n", dsp->value);
}



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
