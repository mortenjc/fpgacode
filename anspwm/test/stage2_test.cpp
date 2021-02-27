// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for pulse-period generator
//===----------------------------------------------------------------------===//

#include <stage2.h>
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

std::vector<struct Teststep> RefTest2 {
  {52689, 52689, 0, 0}, {39842, 26995, 1, 0}, {26995, 53990, 1, 1},
  {14148,  2602, 1, 0}, { 1301,  3903, 1, 1}
};


class Stage2Test: public ::testing::Test {
protected:
stage2 * s2;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      s2->clk = 1;
      s2->eval();
      s2->clk = 0;
      s2->eval();
    }
  }

  void reset() {
    s2->A = 0;
    s2->rst_n = 0;
    s2->clk = 1;
    s2->eval();
    s2->rst_n = 1;
    s2->clk = 0;
    s2->eval();
  }

  void SetUp( ) {
    s2 = new stage2;
    reset();
  }

  void TearDown( ) {
    s2->final();
    delete s2;
  }
};

TEST_F(Stage2Test, ZeroIn) {
  reset();
  for (int i = 0; i < 100; i++) {
    printf("%d ", i);
    s2->A = 0;
    clock_ticks(1);
    ASSERT_EQ(s2->C, 0);
    ASSERT_EQ(s2->Csgn, 0);
    ASSERT_EQ(s2->nxttgt, 0);
  }
  printf("\n");
}

// TEST_F(Stage2Test, StandardExample) {
//   for (int i = 0; i < RefTest2.size() + 3; i++) {
//     s2->A = RefTest2[i].target;
//     clock_ticks(1);
//     printf("%2d: output %c%5u, diff %5u\n", i, s2->Csgn ? '-' : '+', s2->C, s2->nxttgt);
//     if (i < RefTest2.size()) {
//       ASSERT_EQ(s2->nxttgt, RefTest2[i].diff);
//     }
//
//     if (i >= 3) {
//       ASSERT_EQ(s2->C, RefTest2[i - 3].output);
//       ASSERT_EQ(s2->Csgn, RefTest2[i - 3].sign);
//     }
//   }
// }



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
