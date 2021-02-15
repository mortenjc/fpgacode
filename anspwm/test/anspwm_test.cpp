// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for pulse-period generator
//===----------------------------------------------------------------------===//

#include <anspwm.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

struct TestCase {
  std::string name;
  // inputs
  uint8_t rst;
  uint32_t tgt_in;
  // expected outputs
  uint16_t exp_val_out;
  uint32_t exp_diff_out;
};

std::vector<TestCase> Tests {
  {"test1", 0, 1234554321, 18837, 52689},
};

class ANSPWMTest: public ::testing::Test {
protected:
anspwm * pwm;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      pwm->clk = 1;
      pwm->eval();
      pwm->clk = 0;
      pwm->eval();
    }
  }

  void SetUp( ) {
    pwm = new anspwm;
    pwm->rst = 1;
    pwm->clk = 1;
    pwm->eval();
    pwm->clk = 0;
    pwm->eval();
  }

  void TearDown( ) {
    pwm->final();
    delete pwm;
  }
};

TEST_F(ANSPWMTest, Loop20) {
  for (int i = 0; i < 20; i++) {
    pwm->rst = 0;
    pwm->tgt_in = (uint32_t)1234554321;
    clock_ticks(1);
    printf("%3d: val %5u, diff %5u\n", i, pwm->val_out, pwm->diff_out);
  }
}

TEST_F(ANSPWMTest, Loop100) {
  uint64_t sum{0};
  for (int i = 0; i < 100; i++) {
    pwm->rst = 0;
    pwm->tgt_in = (uint32_t)1234554321;
    clock_ticks(1);
    printf("%3d: val %5u, diff %5u\n", i, pwm->val_out, pwm->diff_out);
    sum += pwm->val_out;
  }
  double avg = sum * 1.0/100;
  printf("Average value: %f (%u)\n", avg, (uint32_t)(65536 * avg));
}

// TEST_F(ANSPWMTest, Reset) {
//   for (auto & Test : Tests) {
//     printf("subtest: %s\n", Test.name.c_str());
//     pwm->rst = Test.rst;
//     pwm->tgt_in = Test.tgt_in;
//     clock_ticks(1);
//     ASSERT_EQ(pwm->val_out, Test.exp_val_out);
//     ASSERT_EQ(pwm->diff_out, Test.exp_diff_out);
//   }
// }

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
