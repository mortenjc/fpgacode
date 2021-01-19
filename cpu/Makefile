# Copyright (C) 2020 Morten Jagd Christensen, LICENSE: BSD2
#

MODULES := register_file shifter alu cpumemory
TYPE_FILES := alu_types.sv shifter_types.sv register_types.sv

EXTRA_FLAGS_cpumemory := -Gmemory_file='"memory_test.data"'

%:%.sv $(TYPE_FILES) %_test.cpp
	verilator -Wall -cc $(TYPE_FILES) $@ -y . -Mdir $@ --prefix $@ \
		--exe  $(@:%=%_test.cpp) \
		-LDFLAGS "-L../googletest/build/lib -lgtest" \
		-CFLAGS "-std=c++11" \
		-CFLAGS "-I../googletest/googletest/include/" $($(@:%=EXTRA_FLAGS_%))
		make -C $@ -j 8 -f $@.mk

all: $(MODULES)


runtest: $(MODULES)
	for test in $(MODULES); do ./$$test/$$test || exit 1; done

gtest:
	./scripts/makegtest


clean:
	rm -fr $(MODULES)

realclean: clean
	rm -fr googletest
