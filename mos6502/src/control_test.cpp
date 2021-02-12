// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for memory address multiplexer
//===----------------------------------------------------------------------===//

#include <control.h>
#include <control_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint16_t expected_data;
};

std::vector<TestCase> tests {
};

class ControlTest: public ::testing::Test {
protected:
  control * ctl;

  void SetUp( ) {
    ctl = new control;
    ctl->eval();
  }

  void TearDown( ) {
    ctl->final();
    delete ctl;
  }
};


TEST_F(ControlTest, Initial) {
  ASSERT_EQ(ctl->mm, 0);
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
