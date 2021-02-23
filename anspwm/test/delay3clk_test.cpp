// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for ALU logic
//===----------------------------------------------------------------------===//

#include <delay3clk.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class Delay3Test: public ::testing::Test {
protected:
delay3clk * delay;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      delay->clk = 1;
      delay->eval();
      delay->clk = 0;
      delay->eval();
    }
  }

  void SetUp( ) {
    delay = new delay3clk;
    delay->rst_n = 1;
    delay->eval();
  }

  void TearDown( ) {
    delay->final();
    delete delay;
  }
};


TEST_F(Delay3Test, TestDelay1) {
  delay->val_in = 42;
  delay->sign_in = 1;
  delay->eval();
  ASSERT_EQ(delay->d1_out, 0);

  clock_ticks(1);
  delay->eval();
  ASSERT_EQ(delay->d1_out, 42);
  ASSERT_EQ(delay->d2_out, 0);
  ASSERT_EQ(delay->d3_out, 0);

  clock_ticks(1);
  delay->eval();
  ASSERT_EQ(delay->d1_out, 42);
  ASSERT_EQ(delay->d2_out, 42);
  ASSERT_EQ(delay->d3_out, 0);

  clock_ticks(1);
  delay->eval();
  ASSERT_EQ(delay->d1_out, 42);
  ASSERT_EQ(delay->d2_out, 42);
  ASSERT_EQ(delay->d3_out, 42);
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
