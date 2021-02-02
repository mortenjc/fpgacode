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
};

//std::vector<TestCase> tests {
//};

class ClockTest: public ::testing::Test {
protected:
  clock_24h * clock_i;

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
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
