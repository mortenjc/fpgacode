// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for delayed subtraaction
//===----------------------------------------------------------------------===//

#include <stage1.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class Stage1Test: public ::testing::Test {
protected:
stage1 * s1;

  void SetUp( ) {
    s1 = new stage1;
  }

  void TearDown( ) {
    s1->final();
    delete s1;
  }
};

TEST_F(Stage1Test, Constructor) {
  ASSERT_EQ(1,0);
}



int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
