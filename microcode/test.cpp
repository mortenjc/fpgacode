#include <Microaddr_microaddr.h>
#include <Microaddr.h>
#include <verilated.h>
#include <string>
#include <vector>

class TestCase {
public:
  std::string name;
  uint8_t reset;
  uint8_t cmd;
  uint16_t load_addr;
  uint16_t expected_addr;
};

std::vector<TestCase> tests {
  {"reset",  1, Microaddr_microaddr::cmd::NONE, 0,      0},
  {"inc",    0, Microaddr_microaddr::cmd::INC,  0,      1},
  {"none",   0, Microaddr_microaddr::cmd::NONE, 0,      1},
  {"reset2", 1, Microaddr_microaddr::cmd::NONE, 0,      0},
  {"load",   0, Microaddr_microaddr::cmd::LOAD, 0x7FE,  0x7FE},
  {"inc",    0, Microaddr_microaddr::cmd::INC,  0,      0x7FF},
  {"inc",    0, Microaddr_microaddr::cmd::INC,  0,      0x000},
  {"reset3", 1, Microaddr_microaddr::cmd::NONE, 0,      0}
};

int main(int argc, char * argv[]) {
  Verilated::commandArgs(argc, argv);

  Microaddr * counter = new Microaddr;

  counter->clk = 0;
  counter->reset = 0;
  counter->cmd = Microaddr_microaddr::cmd::NONE;
  counter->load_addr = 0;
  counter->eval();

  for (auto & test : tests) {
    counter->reset = test.reset;
    counter->cmd = test.cmd;
    counter->load_addr = test.load_addr;
    counter->eval();

    counter->clk = 1;
    counter->eval();
    counter->clk = 0;
    counter->eval();

    if (counter->addr != test.expected_addr) {
      printf("Test %s failed: expected %d, got %d\n",
        test.name.c_str(), test.expected_addr, counter->addr);
    } else {
      printf("Test %s passed\n", test.name.c_str());
    }
  }

  return 0;
}
