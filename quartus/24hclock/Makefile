# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

define my_test
build/$(1)/$(1): build/$(1)
	make -C build/$(1) -j 8 -f $(1).mk
endef

MODULES = clock_24h

$(foreach mymod, $(MODULES), $(eval $(call my_test,$(mymod))))

TARGETS = $(join $(addsuffix /, $(addprefix build/, $(MODULES))), $(MODULES))

# build/clock_24h/clock_24h: build/clock_24h
# 	make -C $< -j 8 -f $(notdir $<).mk

build/%: src/%.sv
	verilator -Wall -cc $< -y . -Mdir $@ --prefix $(notdir $@) \
            --exe ../../src/$(notdir $@)_test.cpp \
            -LDFLAGS "-L../../googletest/build/lib -lgtest -lpthread" \
            -CFLAGS "-std=c++11" \
            -CFLAGS "-I../../googletest/googletest/include/"



all: directories $(TARGETS)
	echo "done"

runtest: $(TARGETS)
	for test in $(TARGETS); do ./$$test || exit 1; done

gtest:
	./scripts/makegtest


# make sure build directory i built
.PHONY: directories

directories: build

build:
	mkdir -p build

# Misc clean targets
clean:
	rm -fr build *.bak

realclean: clean
	rm -fr googletest db output_files simulation
