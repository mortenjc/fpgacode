
#include <alu_alu_types.h>
#include <alu.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint16_t x;
  uint16_t y;
  uint8_t cmd;
  uint16_t expected_z;
  uint8_t expected_zflag;
};

using cmd_t = alu_alu_types::cmd_t;

std::vector<TestCase> tests {
  {"none",       0,      0,      cmd_t::NONE,  0,        1},
  {"inc1",       0,      0,      cmd_t::INC,   1,        0},
  {"inc2",       1,      0,      cmd_t::INC,   2,        0},
  {"inc3",       0xFFFE, 0,      cmd_t::INC,   0xFFFF,   0},
  {"inc3",       0xFFFF, 0,      cmd_t::INC,   0,        1},
  {"sub1",       0,      0,      cmd_t::SUB,   0,        1},
  {"sub2",       9,      9,      cmd_t::SUB,   0,        1},
  {"sub3",       1,      2,      cmd_t::SUB,   0xFFFF,   0},
  {"or1",        0xAAAA, 0x5555, cmd_t::OR,    0xFFFF,   0},
  {"or2",        0x0000, 0x0000, cmd_t::OR,    0,        1},
};


class ALUTest: public ::testing::Test {
protected:
  alu  * alu1;

  void SetUp( ) {
    alu1 = new alu;
    alu1->x = 0;
    alu1->y = 0;
    alu1->cmd = cmd_t::NONE;
    alu1->eval();
  }

  void TearDown( ) {
    alu1->final();
    delete alu1;
  }
};


TEST_F(ALUTest, BasicCommands) {

  for (auto & test : tests) {
    alu1->x = test.x;
    alu1->y = test.y;
    alu1->cmd = test.cmd;
    alu1->eval();

    printf("subtest: %s\n", test.name.c_str());
    ASSERT_EQ(alu1->z, test.expected_z);
    ASSERT_EQ(alu1->zflag, test.expected_zflag);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
