// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for pulse-period generator
//===----------------------------------------------------------------------===//

#include <stage1.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>


struct Teststep {
  uint32_t target;
  uint32_t diff;
  uint16_t output;
  uint8_t sign;
};

std::vector<struct Teststep> RefTest1 {
  {1234554321, 52689, 18837, 0}, {1234554321, 39842, 18838, 0}, {1234554321, 26995, 18838, 0},
  {1234554321, 14148, 18838, 0}, {1234554321, 1301,  18838, 0}, {1234554321, 53990, 18837, 0}
};


class Stage1Test: public ::testing::Test {
protected:
stage1 * s1;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      s1->clk = 1;
      s1->eval();
      s1->clk = 0;
      s1->eval();
    }
  }

  void reset() {
    s1->A = 0;
    s1->rst_n = 0;
    s1->clk = 1;
    s1->eval();
    s1->rst_n = 1;
    s1->clk = 0;
    s1->eval();
  }

  void SetUp( ) {
    s1 = new stage1;
    reset();
  }

  void TearDown( ) {
    s1->final();
    delete s1;
  }
};


TEST_F(Stage1Test, StandardExample) {
  reset();
  for (int i = 0; i < RefTest1.size() + 3; i++) {
    s1->A = RefTest1[i].target;
    clock_ticks(1);
    printf("%2d: output %c%5u, diff %5u\n", i, s1->Csgn ? '-' : '+', s1->C, s1->nxttgt);
    if (i < RefTest1.size()) {
      ASSERT_EQ(s1->nxttgt, RefTest1[i].diff);
    }

    if (i >= 3) {
      ASSERT_EQ(s1->C, RefTest1[i - 3].output);
      ASSERT_EQ(s1->Csgn, RefTest1[i - 3].sign);
    }
  }
}



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
