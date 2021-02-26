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

// we should add test cases here
std::vector<TestCase> Tests {
  {"test1", 0, 1234554321, 18837, 52689},
};

struct RefTest {
  uint32_t Target;
  std::vector<uint16_t> Values;
};
// Here we can add specific testcases when we see the need
// these should ALWAYS pass so any regressions affecting this
// should be caught
std::vector<struct RefTest> ReferenceTestExamples{
  {1234554321,
    {18837, 18838, 18838, 18838, 18838, 18837, 18838, 18838, 18838, 18838,
     18837, 18838, 18838, 18838, 18838}},
  {2331992345,
    {35583, 35583, 35584, 35583, 35583, 35584, 35583, 35584, 35583, 35583,
     35584, 35583, 35583, 35584, 35583, 35584, 35583, 35583}},

  {4157303487,
    {63435, 63435, 63436, 63435, 63436, 63435, 63435, 63436, 63435, 63436,
     63435, 63436, 63435, 63435, 63436, 63435, 63436, 63435, 63435, 63436,
     63435, 63436, 63435, 63436, 63435, 63435, 63436, 63435}},
  {1923508978,
    {29350, 29350, 29351, 29350, 29351, 29350, 29350, 29351, 29350, 29351,
     29350, 29351}},
  {1751304293,
    {26722, 26723, 26723, 26723, 26722, 26723, 26723, 26723, 26723, 26722,
     26723, 26723, 26723, 26722, 26723, 26723, 26723, 26723, 26722}},
  {2144771828,
    {32726, 32727, 32726, 32727, 32727, 32726, 32727, 32726, 32727, 32727,
     32726, 32727, 32727, 32726, 32727, 32726, 32727, 32727, 32726, 32727,
     32727, 32726, 32727, 32726, 32727, 32727, 32726}},
  {2752483370,
    {41999, 42000, 41999, 42000, 41999, 42000, 41999, 42000, 42000, 41999,
     42000, 41999, 42000, 41999, 42000, 42000, 41999, 42000, 41999, 42000,
     41999, 42000, 41999, 42000, 42000, 41999, 42000, 41999, 42000}},
  {3460903970,
    {52809, 52809, 52809, 52809, 52810, 52809, 52809, 52809, 52809, 52810,
     52809, 52809, 52809, 52809, 52810, 52809, 52809, 52809, 52809, 52810,
     52809, 52809, 52809, 52809, 52810, 52809, 52809, 52809, 52809, 52810}},
  {2657777568,
    {40554, 40554, 40555, 40554, 40555, 40554, 40555, 40554, 40555, 40554,
     40555, 40554, 40555, 40554, 40555, 40554, 40554, 40555, 40554, 40555,
     40554, 40555, 40554}},
  {3424152770,
    {52248, 52248, 52249, 52248, 52249, 52248, 52248, 52249, 52248, 52249,
     52248, 52249}},
  {4224245905,
    {64456, 64457, 64457, 64457, 64457, 64457, 64457, 64457, 64456, 64457,
     64457, 64457, 64457, 64457, 64457, 64457, 64456, 64457, 64457, 64457,
     64457, 64457, 64457, 64457, 64456, 64457, 64457, 64457, 64457}},
  {2352679831,
    {35899, 35899, 35899, 35899, 35899, 35899, 35899, 35899, 35899, 35899,
     35899, 35899, 35899, 35899, 35899, 35899, 35899, 35899, 35899, 35899,
     35899, 35899, 35900, 35899, 35899, 35899, 35899, 35899}}
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
    q16 = new quantize16;
    reset();
  }

  void TearDown( ) {
    q16->final();
    delete q16;
  }
};


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
