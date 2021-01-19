// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for shifter logic
//===----------------------------------------------------------------------===//

#include <shifter.h>
#include <shifter_shifter_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t cmd;
  uint32_t B;
  uint8_t Cin;
  uint32_t exp_data;
  uint8_t exp_C;
};

std::vector<TestCase> tests {
  //                                     B  Cin res C
  {"shr0", shifter_shifter_types::SHR, 0x0f, 0, 0x07, 0},
  {"shr1", shifter_shifter_types::SHR, 0x0f, 1, 0x07, 0},
  {"shr2", shifter_shifter_types::SHR, 0x07, 0, 0x03, 0},
  {"shr3", shifter_shifter_types::SHR, 0x03, 0, 0x01, 0},
  {"shr4", shifter_shifter_types::SHR, 0x01, 0, 0x00, 0},
  {"shr4", shifter_shifter_types::SHR, 0x00, 0, 0x00, 0},

  {"shl0", shifter_shifter_types::SHL, 0x0f, 0, 0x1e, 0},
  {"shl1", shifter_shifter_types::SHL, 0x1e, 1, 0x3c, 0},
  {"shl2", shifter_shifter_types::SHL, 0x3c, 0, 0x78, 0},
  {"shl3", shifter_shifter_types::SHL, 0x00, 0, 0x00, 0},

  {"ror0", shifter_shifter_types::ROR, 0xAAAAAAAA, 0, 0x55555555, 0},
  {"rol0", shifter_shifter_types::ROL, 0xAAAAAAAA, 0, 0x55555554, 1},
};

class SHFTTest: public ::testing::Test {
protected:
  shifter * shft;

  void SetUp( ) {
    shft = new shifter;
    shft->B = 0;
    shft->eval();
  }

  void TearDown( ) {
    shft->final();
    delete shft;
  }
};


TEST_F(SHFTTest, Initial) {
  ASSERT_EQ(shft->B, 0);
}

TEST_F(SHFTTest, BasicTest) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    shft->B = test.B;
    shft->Cin = test.Cin;
    shft->cmd = test.cmd;
    shft->eval();

    ASSERT_EQ(shft->data, test.exp_data);
    ASSERT_EQ(shft->C, test.exp_C);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
