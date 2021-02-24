// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for pulse-period generator
//===----------------------------------------------------------------------===//

#include <quantize16.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

struct TestCase {
  std::string name;
  // inputs
  uint8_t rst_n;
  uint32_t tgt_in;
  // expected outputs
  uint16_t exp_val_out;
  uint32_t exp_diff_out;
};

std::vector<TestCase> Tests {
  {"test1", 0, 1234554321, 18837, 52689},
};

class Q16Test: public ::testing::Test {
protected:
quantize16 * q16;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      q16->clk = 1;
      q16->eval();
      q16->clk = 0;
      q16->eval();
    }
  }

  void SetUp( ) {
    q16 = new quantize16;
    q16->rst_n = 0;
    q16->clk = 1;
    q16->eval();
    q16->rst_n = 1;
    q16->clk = 0;
    q16->eval();
  }

  void TearDown( ) {
    q16->final();
    delete q16;
  }
};

TEST_F(Q16Test, Loop15) {
  uint16_t values[] = {18837, 18838, 18838, 18838, 18838, 18837, 18838, 18838, 18838, 18838, 18837, 18838, 18838, 18838, 18838};
  for (int i = 0; i < 15; i++) {
    q16->rst_n = 1;
    q16->tgt_in = (uint32_t)1234554321;
    clock_ticks(1);
    ASSERT_EQ(q16->val_out, values[i]);
    printf("%3d: val %5u, diff %5u\n", i, q16->val_out, q16->diff_out);
  }
}

TEST_F(Q16Test, Loop100) {
  uint64_t sum{0};
  for (int i = 0; i < 100; i++) {
    q16->rst_n = 1;
    q16->tgt_in = (uint32_t)1234554321;
    clock_ticks(1);
    printf("%3d: val %5u, diff %5u\n", i, q16->val_out, q16->diff_out);
    sum += q16->val_out;
  }
  double avg = sum * 1.0/100;
  printf("Average value: %f (%u)\n", avg, (uint32_t)(65536 * avg));
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
