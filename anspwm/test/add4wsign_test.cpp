// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief test harness for pulse-period generator
//===----------------------------------------------------------------------===//

#include <add4wsign.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>

struct TestCase {
  std::string name;
  uint16_t c0, c1, c2, c3;
  uint8_t c1s, c2s, c3s;
  // expected outputs
  uint16_t exp_sum;
};

std::vector<TestCase> Tests {
  {"test1", 10000, 1, 2, 4, 0, 0, 0, 10007},
  {"test2", 10000, 1, 2, 4, 0, 0, 1,  9999},
  {"test3", 10000, 1, 2, 4, 0, 1, 0, 10003},
  {"test4", 10000, 1, 2, 4, 0, 1, 1,  9995},
  {"test5", 10000, 1, 2, 4, 1, 0, 0, 10005},
  {"test6", 10000, 1, 2, 4, 1, 0, 1,  9997},
  {"test7", 10000, 1, 2, 4, 1, 1, 0, 10001},
  {"test8", 10000, 1, 2, 4, 1, 1, 1,  9993},
};

class ADD4Test: public ::testing::Test {
protected:
add4wsign * add4;

  void SetUp( ) {
    add4 = new add4wsign;
  }

  void TearDown( ) {
    add4->final();
    delete add4;
  }
};


TEST_F(ADD4Test, Basic) {
  for (auto & Test : Tests) {
    printf("subtest: %s\n", Test.name.c_str());
    add4->rst_n = 1;
    add4->c0 = Test.c0;
    add4->c1 = Test.c1;
    add4->c1s = Test.c1s;
    add4->c2 = Test.c2;
    add4->c2s = Test.c2s;
    add4->c3 = Test.c3;
    add4->c3s = Test.c3s;
    add4->eval();
    printf("sum %u\n",add4->sum);
    ASSERT_EQ(add4->sum, Test.exp_sum);
  }
}

TEST_F(ADD4Test, Reset) {
  for (auto & Test : Tests) {
    printf("subtest: %s\n", Test.name.c_str());
    add4->rst_n = 0;
    add4->c0 = Test.c0;
    add4->c1 = Test.c1;
    add4->c1s = Test.c1s;
    add4->c2 = Test.c2;
    add4->c2s = Test.c2s;
    add4->c3 = Test.c3;
    add4->c3s = Test.c3s;
    add4->eval();
    //printf("sum %u\n",add4->sum);
    ASSERT_EQ(add4->sum, 0);
  }
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/add4wsign.dat");
  return res;
}
