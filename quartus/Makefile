# Copyright (C) 2020 Morten Jagd Christensen, LICENSE: BSD2
#

MODULES := clock 
TYPE_FILES :=

%:%.sv $(TYPE_FILES) %_test.cpp
	verilator -Wall -cc $@ -y . -Mdir $@ --prefix $@ \
		--exe  $(@:%=%_test.cpp) \
		-LDFLAGS "-L../googletest/build/lib -lgtest -lpthread" \
		-CFLAGS "-std=c++11" \
		-CFLAGS "-I../googletest/googletest/include/" $($(@:%=EXTRA_FLAGS_%))
		make -C $@ -j 8 -f $@.mk

all: $(MODULES)


runtest: $(MODULES)
	for test in $(MODULES); do ./$$test/$$test || exit 1; done

gtest:
	./scripts/makegtest


clean:
	rm -fr $(MODULES) *.bak

realclean: clean
	rm -fr googletest
