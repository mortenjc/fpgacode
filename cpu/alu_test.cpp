
#include <alu.h>
#include <alu_alu_types.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

#define fN 1
#define fNN 0
#define fZ 1
#define fNZ 0
#define fC 1
#define fNC 0

class TestCase {
public:
  std::string name;
  uint32_t A;
  uint32_t B;
  uint8_t cmd;
  uint32_t exp_data;
  uint8_t exp_Z;
  uint8_t exp_C;
  uint8_t exp_N;
  uint8_t exp_V;
};

std::vector<TestCase> tests {
  {"add0",      0,          0,          alu_alu_types::ADD, 0,          fZ,  fNC, fNN, 0},
  {"add1a",     1,          0,          alu_alu_types::ADD, 1,          fNZ, fNC, fNN, 0},
  {"add1b",     0,          1,          alu_alu_types::ADD, 1,          fNZ, fNC, fNN, 0},
  {"addcarry1", 0xffffffff, 1,          alu_alu_types::ADD, 0,          fZ,  fC,  fNN, 0},
  {"addcarry2", 0xffffffff, 0xffffffff, alu_alu_types::ADD, 0xfffffffe, fNZ, fC,  fN,  0},

  {"sub0",      0,          0,          alu_alu_types::SUB, 0,          fZ,  fNC, fNN, 0},
  {"sub1",      0,          1,          alu_alu_types::SUB, 0xffffffff, fNZ, fC,  fN,  0},

  {"inc0",      0,          0,          alu_alu_types::INC, 1,          fNZ, fNC, fNN, 0},
  {"inc1",      1,          0,          alu_alu_types::INC, 2,          fNZ, fNC, fNN, 0},
  {"inc2",      0xffffffff, 7,          alu_alu_types::INC, 0,          fZ,  fNC, fNN, 0},
};

class ALUTest: public ::testing::Test {
protected:
  alu * aluinst;

  void SetUp( ) {
    aluinst = new alu;
    aluinst->A = 0;
    aluinst->B = 0;
    aluinst->cmd = alu_alu_types::NONE;
    aluinst->eval();
  }

  void TearDown( ) {
    aluinst->final();
    delete aluinst;
  }
};


TEST_F(ALUTest, Initial) {
  ASSERT_EQ(aluinst->A, 0);
  ASSERT_EQ(aluinst->B, 0);
}

TEST_F(ALUTest, BasicTest) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    aluinst->A = test.A;
    aluinst->B = test.B;
    aluinst->cmd = test.cmd;
    aluinst->eval();

    ASSERT_EQ(aluinst->data, test.exp_data);
    ASSERT_EQ(aluinst->C, test.exp_C);
    ASSERT_EQ(aluinst->Z, test.exp_Z);
    ASSERT_EQ(aluinst->N, test.exp_N);
    ASSERT_EQ(aluinst->V, test.exp_V);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
