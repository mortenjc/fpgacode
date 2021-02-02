// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for ALU logic
//===----------------------------------------------------------------------===//

#include <clock_24h.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t reset_h;
  uint8_t reset_m;
  uint8_t value;
  int ticks;

  uint8_t hour;
  uint8_t min;
  uint8_t sec;
  uint8_t dot;

  uint8_t exp_hour;
  uint8_t exp_min;
  uint8_t exp_sec;
  uint8_t exp_dot;
};

std::vector<TestCase> tests {
  {"one second", 0, 0,  0,     1,   0,  0,  0, 0,    0,  0,  1, 0},
  {"one minute", 0, 0,  0,    60,   0,  0,  0, 0,    0,  1,  0, 0},
  {"one hour",   0, 0,  0,  3600,   0,  0,  0, 0,    1,  0,  0, 0},
  {"midnight",   0, 0,  0,     1,  23, 59, 59, 0,    0,  0,  0, 0},
  {"1d - 1s",    0, 0,  0, 86399,   0,  0,  0, 0,   23, 59, 59, 0},
  {"24 hours",   0, 0,  0, 86400,   0,  0,  0, 0,    0,  0,  0, 0},

  {"set 42m",    0, 1, 42,     1,   1,  2,  3, 0,    1, 42,  0, 0},
  {"set 60m",    0, 1, 60,     1,   6,  5,  4, 0,    6,  0,  0, 0},
  {"set 99m",    0, 1, 99,     1,   7,  8,  9, 0,    7, 39,  0, 0},

  {"set 24h",    1, 0, 24,     1,   1,  2,  3, 0,    0,  2,  0, 0},
};

class ClockTest: public ::testing::Test {
protected:
  clock_24h * clock_i;

  void clock_ticks(int N) {
    for (int i = 1; i <= N; i++) {
      clock_i->s_clk = 1;
      clock_i->eval();
      clock_i->s_clk = 0;
      clock_i->eval();
    }
  }

  void SetUp( ) {
    clock_i = new clock_24h;
    clock_i->eval();
  }

  void TearDown( ) {
    clock_i->final();
    delete clock_i;
  }
};


TEST_F(ClockTest, Initial) {
  ASSERT_EQ(clock_i->hour, 0);
  ASSERT_EQ(clock_i->min, 0);
  ASSERT_EQ(clock_i->sec, 0);
}

TEST_F(ClockTest, TestSuite) {
  for (auto & test : tests) {
    printf("test: %s\n", test.name.c_str());
    clock_i->reset_h = test.reset_h;
    clock_i->reset_m = test.reset_m;
    clock_i->value = test.value;
    clock_i->hour = test.hour;
    clock_i->min = test.min;
    clock_i->sec = test.sec;
    clock_ticks(test.ticks);
    ASSERT_EQ(clock_i->sec, test.exp_sec);
    ASSERT_EQ(clock_i->min, test.exp_min);
    ASSERT_EQ(clock_i->hour, test.exp_hour);
  }
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
