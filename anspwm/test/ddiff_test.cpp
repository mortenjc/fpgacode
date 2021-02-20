// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for delayed subtraaction
//===----------------------------------------------------------------------===//

#include <ddiff.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class DDIFFTest: public ::testing::Test {
protected:
ddiff * d;
uint32_t clocks{0};

  void debug() {
    // printf("pulse %u, clk: %u, rst_n:%u, A: %u, Asgn: %u,                      C: %u, Csgn: %u\n",
    //  clocks, d->clk, d->rst_n, d->A, d->A_sign, d->C, d->C_sign);
  }

  void one_pulse() {
    d->rst_n = 1;
    d->clk = 0;
    d->eval();
    debug();
    d->clk = 1;
    d->eval();
    debug();
    clocks++;
  }

  void SetUp( ) {
    d = new ddiff;
  }

  void TearDown( ) {
    d->final();
    delete d;
  }
};

TEST_F(DDIFFTest, Constructor) {
  d->clk = 0;
  d->eval();

  d->clk = 1;
  d->rst_n = 0;
  d->A = 1;
  d->A_sign = 0;
  d->eval();

  d->A = 0;
  one_pulse();
  d->A = 1;
  one_pulse();
  d->A = 0;
  one_pulse();
  d->A = 1;
  one_pulse();
  d->A = 0;
  one_pulse();
}

// Based on target 1234554321
TEST_F(DDIFFTest, C1) {
  std::vector<uint16_t> A  = {0, 1, 0, 1, 0, 0, 1, 0, 1, 0};
  std::vector<uint16_t> AS = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  std::vector<uint16_t> O  = {0, 1, 1, 1, 1, 0, 1, 1, 1, 1};
  std::vector<uint16_t> OS = {0, 0, 1, 0, 1, 0, 0, 1, 0, 1};

  for (int i = 0; i < A.size(); i++) {
    printf("round: %d\n", i);
    d->A = A[i];
    d->A_sign = AS[i];
    one_pulse();
    ASSERT_EQ(d->C, O[i]);
    ASSERT_EQ(d->C_sign, OS[i]);
  }
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
