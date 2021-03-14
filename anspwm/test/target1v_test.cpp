// Copyright (C) 2021 Morten Jagd Christensen, see LICENSE file
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief 1volt +- n x 10 micro Volts
//===----------------------------------------------------------------------===//

#include <target1v.h>
#include <verilated.h>
#include <gtest/gtest.h>
#include <string>
#include <vector>
#include <math.h>


class OneVoltTest: public ::testing::Test {
protected:
  target1v * tgt;

  uint32_t baseline = round(0xFFFFFFFF/10.0);
  uint32_t increment_10uv = 4295;
  uint32_t increment_1uv = 430;

  void SetUp( ) {
    tgt = new target1v();
  }

  void TearDown( ) {
    tgt->final();
    delete tgt;
  }
};


TEST_F(OneVoltTest, OneVolt) {
  tgt->value = 32; // 1.000000 volt == index 32
  tgt->eval();
  ASSERT_EQ(tgt->target, baseline);
}

TEST_F(OneVoltTest, OneVoltPlus) {
  for (uint32_t i = 0; i < 32; i++) {
    tgt->value = 32 + i; // positive adjustments
    tgt->eval();
    printf("value: %u, target %u\n", tgt->value, tgt->target);
    ASSERT_EQ(tgt->target, baseline + i * increment_1uv);
  }
}

TEST_F(OneVoltTest, OneVoltMinus) {
  for (uint32_t i = 0; i < 33; i++) {
    tgt->value = 32 - i; // negative adjustments
    tgt->eval();
    printf("value: %u, target %u\n", tgt->value, tgt->target);
    ASSERT_EQ(tgt->target, baseline - i * increment_1uv);
  }
}

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  testing::InitGoogleTest(&argc, argv);
  auto res = RUN_ALL_TESTS();
  VerilatedCov::write("logs/target1v.dat");
  return res;
}
