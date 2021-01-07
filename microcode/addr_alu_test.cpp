
#include <addr_alu_alu_types.h>
#include <addr_alu.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint32_t x;
  uint32_t y; // unused
  uint8_t cmd;
  uint32_t expected_z;
  uint8_t expected_zflag;
};

using cmd_t = addr_alu_alu_types::cmd_t;

std::vector<TestCase> tests {
  {"inc1",       0,        0,      cmd_t::INC,   1,         0},
  {"inc2",       1,        0,      cmd_t::INC,   2,         0},
  {"inc3",       0x1FFFE,  0,      cmd_t::INC,   0x1FFFF,   0},
  {"inc4",       0x1FFFF,  0,      cmd_t::INC,   0,         1},
};


class ADDRALUTest: public ::testing::Test {
protected:
  addr_alu  * alu1;

  void SetUp( ) {
    alu1 = new addr_alu;
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


TEST_F(ADDRALUTest, BasicCommands) {

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
