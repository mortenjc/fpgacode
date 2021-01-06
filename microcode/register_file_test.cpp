
#include <register_file_register_types.h>
#include <register_file.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

using name_t = register_file_register_types::name_t;

class TestCase {
public:
	std::string name;

	name_t mem_dest_select;
	uint8_t mem_data;

	name_t addr_alu_dest_select;
	uint32_t addr_alu_data;

  name_t alu_dest_select;
  uint16_t alu_data;

  name_t var_dest_select;
  uint32_t var_data;

	uint8_t expected_M;
 	uint8_t expected_V;
 	uint16_t expected_OP0;
 	uint16_t expected_OP1;
 	uint32_t expected_X;
 	uint32_t expected_SP;
 	uint32_t expected_FP;
 	uint32_t expected_GP;
  uint32_t expected_IP;
  uint32_t expected_AP;
};

std::vector<TestCase> tests {
  { "mem -> M",
  	name_t::M, 0xA1,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> V",
  	name_t::V, 0xA2,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP0H",
  	name_t::OP0H, 0xBB,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0xBB00, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP0L",
  	name_t::OP0L, 0xCC,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0xBBCC, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP0",
    name_t::OP0, 0x12,
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x0012, 0, 0, 0, 0, 0, 0, 0},
  { "mem -> OP1H",
  	name_t::OP1H, 0xDD,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0xDD00, 0, 0, 0, 0, 0, 0},
  { "mem -> OP1L",
  	name_t::OP1L, 0xEE,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0xDDEE, 0, 0, 0, 0, 0, 0},
  { "mem -> OP1",
    name_t::OP1, 0x34,
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x0012, 0x0034, 0, 0, 0, 0, 0, 0},
  { "mem -> NONE",
  	name_t::NONE, 0,
  	name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0, 0, 0, 0, 0, 0},

  { "addr_alu -> X",
  	name_t::NONE, 0,
  	name_t::X, 0x1FABC,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0, 0, 0, 0, 0},
  { "addr_alu -> SP",
  	name_t::NONE, 0,
  	name_t::SP, 0x01234,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0, 0, 0, 0},
  { "addr_alu -> FP",
  	name_t::NONE, 0,
  	name_t::FP, 0x19876,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0, 0, 0},
  { "addr_alu -> GP",
  	name_t::NONE, 0,
  	name_t::GP, 0x0102C,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0, 0},
  { "addr_alu -> IP",
  	name_t::NONE, 0,
  	name_t::IP, 0x1CCCC,
    name_t::NONE, 0,
    name_t::NONE, 0,
  	0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0},
  { "addr_alu -> AP",
    name_t::NONE, 0,
    name_t::AP, 0x09876,
    name_t::NONE, 0,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x0012, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876},

  { "alu -> OP0",
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::OP0, 0x6543,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x6543, 0x0034, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876},
  { "alu -> OP1",
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::OP1, 0xFDCB,
    name_t::NONE, 0,
    0xA1, 0xA2, 0x6543, 0xFDCB, 0x1FABC, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876},

  { "var -> X",
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::NONE, 0,
    name_t::X, 0x14321,
    0xA1, 0xA2, 0x6543, 0xFDCB, 0x14321, 0x01234, 0x19876, 0x0102C, 0x1CCCC, 0x09876}
};

class REGTest: public ::testing::Test {
protected:
  register_file * registers;

  void SetUp( ) {
    registers = new register_file;
    registers->clk = 0;
    registers->mem_dest_select = name_t::NONE;
    registers->mem_data = 0;
    registers->addr_alu_dest_select = name_t::NONE;
    registers->addr_alu_data = 0;
    registers->alu_dest_select = name_t::NONE;
    registers->alu_data = 0;
    registers->var_dest_select = name_t::NONE;
    registers->var_data = 0;
    registers->eval();
  }

  void TearDown( ) {
    registers->final();
    delete registers;
  }
};


TEST_F(REGTest, Constructor) {
  ASSERT_EQ(registers->X, 0);
}

TEST_F(REGTest, FunctionalTests) {
  for (auto & test : tests) {
    printf("subtest %s\n", test.name.c_str());
    registers->mem_dest_select = test.mem_dest_select;
    registers->mem_data = test.mem_data;
  	registers->alu_dest_select = test.alu_dest_select;
    registers->alu_data = test.alu_data;
    registers->addr_alu_dest_select = test.addr_alu_dest_select;
    registers->addr_alu_data = test.addr_alu_data;
    registers->var_dest_select = test.var_dest_select;
    registers->var_data = test.var_data;
    registers->eval();

    registers->clk = 1;
    registers->eval();
    registers->clk = 0;
    registers->eval();

    ASSERT_EQ(registers->M, test.expected_M);
    ASSERT_EQ(registers->V, test.expected_V);
    ASSERT_EQ(registers->OP0, test.expected_OP0);
    ASSERT_EQ(registers->OP1, test.expected_OP1);
    ASSERT_EQ(registers->X, test.expected_X);
    ASSERT_EQ(registers->SP, test.expected_SP);
    ASSERT_EQ(registers->FP, test.expected_FP);
    ASSERT_EQ(registers->GP, test.expected_GP);
    ASSERT_EQ(registers->IP, test.expected_IP);
    ASSERT_EQ(registers->AP, test.expected_AP);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
