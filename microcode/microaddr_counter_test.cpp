
#include <microaddr_counter_microaddr_types.h>
#include <microaddr_counter.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t reset;
  uint8_t zflag;
  uint8_t M;
  uint8_t cmd;
  uint16_t load_addr;
  uint16_t expected_addr;
};

using cmd_t = microaddr_counter_microaddr_types::cmd_t;

std::vector<TestCase> tests {
  {"reset",       1, 0, 0, cmd_t::NONE,  0,      0},
  {"inc",         0, 0, 0, cmd_t::INC,   0,      1},
  {"none",        0, 0, 0, cmd_t::NONE,  0,      1},
  {"reset2",      1, 0, 0, cmd_t::NONE,  0,      0},
  {"load",        0, 0, 0, cmd_t::JMP,   0x7FE,  0x7FE},
  {"inc",         0, 0, 0, cmd_t::INC,   0,      0x7FF},
  {"inc",         0, 0, 0, cmd_t::INC,   0,      0x000},
  {"reset3",      1, 0, 0, cmd_t::NONE,  0,      0},

  { "jmpF",       0, 0, 0, cmd_t::JMP,   0xFFFF, 0x7FF},

  { "reset_call", 1, 0, 0, cmd_t::NONE,  0,      0},
  { "call1",      0, 0, 0, cmd_t::CALL,  0xA0,   0xA0},
  { "ret1",       0, 0, 0, cmd_t::RET,   0,      0x01},

  { "reset4",     1, 0, 0, cmd_t::NONE,  0,      0},
  { "call2.1",    0, 0, 0, cmd_t::CALL,  0xA0,   0xA0},
  { "call2.2",    0, 0, 0, cmd_t::CALL,  0xB0,   0xB0},
  { "ret2.2",     0, 0, 0, cmd_t::RET,   0,      0xA1},
  { "ret2.1",     0, 0, 0, cmd_t::RET,   0,      0x01},

  { "reset5",     1, 0, 0, cmd_t::NONE,  0,      0},
  { "jnz",        0, 1, 0, cmd_t::JNZ,   0xA0,   0x01},
  { "jnz2",       0, 0, 0, cmd_t::JNZ,   0xA0,   0xA0},

  { "opjmp",      0, 0, 1, cmd_t::OPJMP, 0,     0x1AB},
  { "opjmp2",     0, 0, 2, cmd_t::OPJMP, 0,     0x012},
  { "opjmp3",     0, 0, 3, cmd_t::OPJMP, 0,     0}

};


class CMDTest: public ::testing::Test {
protected:
  microaddr_counter * counter;

  void SetUp( ) {
    counter = new microaddr_counter;
    counter->clk = 0;
    counter->reset = 0;
    counter->zflag = 0;
    counter->M = 0;
    counter->cmd = cmd_t::NONE;
    counter->load_addr = 0;
    counter->eval();
  }

  void TearDown( ) {
    counter->final();
    delete counter;
  }
};


TEST_F(CMDTest, BasicCommands) {

  ASSERT_EQ(counter->load_addr, 0);

  for (auto & test : tests) {
    counter->reset = test.reset;
    counter->zflag = test.zflag;
    counter->M = test.M;
    counter->cmd = test.cmd;
    counter->load_addr = test.load_addr;
    counter->eval();

    counter->clk = 1;
    counter->eval();
    counter->clk = 0;
    counter->eval();
    printf("subtest: %s\n", test.name.c_str());
    ASSERT_EQ(counter->addr, test.expected_addr);

  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
