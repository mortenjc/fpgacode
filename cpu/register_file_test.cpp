// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for registers
//===----------------------------------------------------------------------===//

#include <register_file.h>
#include <register_file_register_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>


class TestCase {
public:
  std::string name;
  uint8_t cmd;
  uint32_t data;
  uint32_t exp_r0, exp_r1, exp_r2, exp_r3, exp_r4, exp_r5, exp_r6, exp_r7;
};

std::vector<TestCase> tests {
  {"r0_0", register_file_register_types::r0, 0xffffffff, 0x00, 0x00, 0, 0, 0, 0, 0, 0},
  {"r0_1", register_file_register_types::r0, 0xffff0000, 0x00, 0x00, 0, 0, 0, 0, 0, 0},
  {"r0_2", register_file_register_types::r0, 0x00,       0x00, 0x00, 0, 0, 0, 0, 0, 0},
  {"r1_0", register_file_register_types::r1, 0xff,       0x00, 0xff, 0, 0, 0, 0, 0, 0},
  {"r2_0", register_file_register_types::r2, 0xfe,       0x00, 0xff, 0xfe, 0, 0, 0, 0, 0},
  {"r3_0", register_file_register_types::r3, 0xfd,       0x00, 0xff, 0xfe, 0xfd, 0, 0, 0, 0},
  {"r4_0", register_file_register_types::r4, 0xffff,     0x00, 0xff, 0xfe, 0xfd, 0xffff, 0, 0, 0},
  {"r5_0", register_file_register_types::r5, 0xffff00,   0x00, 0xff, 0xfe, 0xfd, 0xffff, 0xffff00, 0, 0},
  {"r6_0", register_file_register_types::r6, 0xffffff00, 0x00, 0xff, 0xfe, 0xfd, 0xffff, 0xffff00, 0xffffff00, 0},
  {"r7_0", register_file_register_types::r7, 0xaabbccdd, 0x00, 0xff, 0xfe, 0xfd, 0xffff, 0xffff00, 0xffffff00, 0xaabbccdd},
};

class REGTest: public ::testing::Test {
protected:
  register_file * regs;

  void SetUp( ) {
    regs = new register_file;
    regs->data = 0;
    regs->eval();
  }

  void TearDown( ) {
    regs->final();
    delete regs;
  }
};


TEST_F(REGTest, Initial) {
  ASSERT_EQ(regs->data, 0);
  ASSERT_EQ(regs->r0, 0);
}

TEST_F(REGTest, BasicTest) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    regs->data = test.data;
    regs->cmd = test.cmd;
    regs->eval();

    ASSERT_EQ(regs->r0, 0);
    ASSERT_EQ(regs->r1, test.exp_r1);
    ASSERT_EQ(regs->r2, test.exp_r2);
    ASSERT_EQ(regs->r3, test.exp_r3);
    ASSERT_EQ(regs->r4, test.exp_r4);
    ASSERT_EQ(regs->r5, test.exp_r5);
    ASSERT_EQ(regs->r6, test.exp_r6);
    ASSERT_EQ(regs->r7, test.exp_r7);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
