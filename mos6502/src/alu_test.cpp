// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for ALU
//===----------------------------------------------------------------------===//

#include <alu.h>
#include <alu_common_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t func;
  uint8_t a_in;
  uint8_t b_in;
  uint8_t c_in;

  uint8_t exp_out;
  uint8_t exp_c_out;
};

/// \todo check operations with carry
using func = alu_common_types::alu_t;
std::vector<TestCase> tests {
  {"nop",        func::ANOP, 0xaa, 0xbb, 0, 0xaa, 0},
  {"inc",        func::AINC, 0xaa, 0xbb, 0, 0xab, 0},
  {"inc carry",  func::AINC, 0xff, 0xee, 0, 0x00, 0},
  {"inc carry2", func::AINC, 0xff, 0xee, 1, 0x00, 0},
  {"add",        func::AADD, 0x10, 0x20, 0, 0x30, 0},
  {"add c1",     func::AADD, 0xfe, 0x01, 0, 0xff, 0},
  {"add c2",     func::AADD, 0xfe, 0x01, 1, 0x00, 1},
  {"sub",        func::ASUB, 0x20, 0x10, 0, 0x10, 0},
  {"sub c1",     func::ASUB, 0x00, 0x01, 0, 0xff, 1},
  {"sub c2",     func::ASUB, 0x00, 0x01, 1, 0xfe, 1},
};

class ALUTest: public ::testing::Test {
protected:
  alu * alui;

  void SetUp( ) {
    alui = new alu;
    alui->eval();
  }

  void TearDown( ) {
    alui->final();
    delete alui;
  }
};


TEST_F(ALUTest, Initial) {
  ASSERT_EQ(alui->out, 0);
  ASSERT_EQ(alui->c_out, 0);
}

TEST_F(ALUTest, Functions) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    alui->func = test.func;
    alui->a_in = test.a_in;
    alui->b_in = test.b_in;
    alui->c_in = test.c_in;
    alui->eval();

    ASSERT_EQ(alui->out, test.exp_out);
    ASSERT_EQ(alui->c_out, test.exp_c_out);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
