# Copyright (C) 2020 Morten Jagd Christensen, LICENSE: BSD2
#

MODULES := clock_24h


clock_24h: src/clock_24h.sv
	verilator -Wall -cc src/clock_24h.sv -y . -Mdir clock_24h --prefix clock_24h \
            --exe src/clock_24h_test.cpp \
            -LDFLAGS "-L../googletest/build/lib -lgtest -lpthread" \
            -CFLAGS "-std=c++11" \
            -CFLAGS "-I../googletest/googletest/include/" $($(@:%=EXTRA_FLAGS_%))
	make -C clock_24h -j 8 -f $@.mk


all: $(MODULES)


runtest: $(MODULES)
	for test in $(MODULES); do ./$$test/$$test || exit 1; done

gtest:
	./scripts/makegtest


clean:
	rm -fr $(MODULES) *.bak

realclean: clean
	rm -fr googletest db output_files simulation
