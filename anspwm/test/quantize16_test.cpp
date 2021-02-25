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
  uint32_t target;
  // expected outputs
  uint16_t exp_quant_out;
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

  void reset() {
    q16->target = 0;
    q16->rst_n = 0;
    q16->clk = 1;
    q16->eval();
    q16->rst_n = 1;
    q16->clk = 0;
    q16->eval();
  }

  void SetUp( ) {
    printf("<< Setup >>\n");
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

struct RefTest {
  uint32_t Target;
  std::vector<uint16_t> Values;
};

std::vector<struct RefTest> ReferenceTestExamples{
  {1234554321, {18837, 18838, 18838, 18838, 18838, 18837, 18838, 18838, 18838,
                18838, 18837, 18838, 18838, 18838, 18838}},
  {2331992345, {35583, 35583, 35584, 35583, 35583, 35584, 35583, 35584, 35583,
                35583, 35584, 35583, 35583, 35584, 35583, 35584, 35583, 35583}}
};

// TEST_F(Q16Test, T1234554321_S15) {
//   for (int i = 0; i < 15; i++) {
//     q16->rst_n = 1;
//     q16->target = ReferenceTestExamples[0].Target;
//     clock_ticks(1);
//     ASSERT_EQ(q16->quant, ReferenceTestExamples[0].Values[i]);
//     printf("%3d: val %5u (exp %5u), diff %5u\n",
//       i, q16->quant, ReferenceTestExamples[0].Values[i], q16->diff);
//   }
// }
//
// TEST_F(Q16Test, T2331992345_S18) {
//   for (int i = 0; i < 18; i++) {
//     q16->rst_n = 1;
//     q16->target = ReferenceTestExamples[1].Target;
//     clock_ticks(1);
//     ASSERT_EQ(q16->quant, ReferenceTestExamples[1].Values[i]);
//     printf("%3d: val %5u (exp %5u), diff %5u\n",
//       i, q16->quant, ReferenceTestExamples[1].Values[i], q16->diff);
//   }
// }

TEST_F(Q16Test, ReferenceTests) {
  for (auto & Test : ReferenceTestExamples) {
    printf("TARGET: %u - iterations %u\n", Test.Target, (uint16_t)Test.Values.size());
    reset();

    for (int i = 0; i < Test.Values.size(); i++) {
      q16->target = Test.Target;
      clock_ticks(1);
      ASSERT_EQ(q16->quant, Test.Values[i]);
      //printf("%3d: val %5u (exp %5u), diff %5u\n", i, q16->quant, Test.Values[i], q16->diff);
    }
  }
}

TEST_F(Q16Test, Loop100) {
  uint64_t sum{0};
  for (int i = 0; i < 100; i++) {
    q16->rst_n = 1;
    q16->target = (uint32_t)1234554321;
    clock_ticks(1);
    //printf("%3d: val %5u, diff %5u\n", i, q16->quant, q16->diff);
    sum += q16->quant;
  }
  double avg = sum * 1.0/100;
  printf("Average value: %f (%u)\n", avg, (uint32_t)(65536 * avg));
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
