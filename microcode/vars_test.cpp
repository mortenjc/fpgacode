

#include <vars.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t V;
  uint32_t FP;
  uint32_t GP;
  uint32_t expected_addr;
};

std::vector<TestCase> tests {
  {"varL",  0x01, 0xFF12,  0,          0xFF12},
  {"varL",  0x02, 0xFF12,  0,          0xFF14},
  {"varG",  0x10, 0xFF12,  0xA000,     0xA000},
  {"varG",  0x12, 0xFF12,  0xA000,     0xA004},
};


class ADDRALUTest: public ::testing::Test {
protected:
  vars  * var;

  void SetUp( ) {
    var = new vars;
    var->V = 0;
    var->FP = 0;
    var->GP = 0;
    var->eval();
  }

  void TearDown( ) {
    var->final();
    delete var;
  }
};


TEST_F(ADDRALUTest, BasicCommands) {

  for (auto & test : tests) {
    var->V = test.V;
    var->FP = test.FP;
    var->GP = test.GP;
    var->eval();

    printf("subtest: %s\n", test.name.c_str());
    ASSERT_EQ(var->addr, test.expected_addr);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
