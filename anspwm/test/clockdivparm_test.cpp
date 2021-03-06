// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for the clock unit
//===----------------------------------------------------------------------===//

#include <clockdivparm.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class ClockdivparmTest: public ::testing::Test {
protected:
  clockdivparm * div;

  void SetUp( ) {
    div = new clockdivparm;
  }

  void TearDown( ) {
    div->final();
    delete div;
  }
};


TEST_F(ClockdivparmTest, Empty) {
  ASSERT_EQ(1,1);
}




int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/clockdivparm.dat");
  return res;
}
