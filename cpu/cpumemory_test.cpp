
#include <cpumemory.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint16_t addr;
  uint8_t data;
  uint8_t readwrite;
  uint8_t expected_data;
};

std::vector<TestCase> tests {
  {"read1", 0x000, 0x00, 1, 0xFF},
  {"read2", 0x001, 0x00, 1, 0xAA},
  {"read3", 0x002, 0x00, 1, 0x02},
  {"read4", 0x003, 0x00, 1, 0x03},
  {"read5", 0x3FF, 0x00, 1, 0x00},
  {"write1", 0x3FF, 0xAA, 0, 0xAA},
  {"rdbck1", 0x3FF, 0x00, 1, 0xAA},
};

class MEMTest: public ::testing::Test {
protected:
  cpumemory * mem;

  void SetUp( ) {
    mem = new cpumemory;
    mem->clk = 0;
    mem->addr = 0;
    mem->data = 0;
    mem->readwrite = 1;
    mem->eval();
  }

  void TearDown( ) {
    mem->final();
    delete mem;
  }
};


TEST_F(MEMTest, Initial) {
  ASSERT_EQ(mem->addr, 0);
}

TEST_F(MEMTest, Read) {
  for (auto & test : tests) {
    printf("Executing test %s\n", test.name.c_str());
    mem->addr = test.addr;
    mem->readwrite = test.readwrite;
    mem->data = test.data;
    mem->eval();

    mem->clk = 1;
    mem->eval();
    mem->clk = 0;
    mem->eval();
    ASSERT_EQ(mem->data, test.expected_data);
  }
}


int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
