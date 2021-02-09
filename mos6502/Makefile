# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

define my_test
build/$(1)/$(1): build/$(1)
	@make -C build/$(1) -j 8 -f $(1).mk
endef

MODULES = cpumemory

EXTRA_FLAGS_cpumemory := -Gmemory_file='"src/memory_test.data"'

# Generate rules to make the test executable
$(foreach mymod, $(MODULES), $(eval $(call my_test,$(mymod))))

TARGETS = $(join $(addsuffix /, $(addprefix build/, $(MODULES))), $(MODULES))

build/%: src/%.sv
	@verilator -Wall -cc $< -y . -Mdir $@ --prefix $(notdir $@) \
            --exe ../../src/$(notdir $@)_test.cpp \
            -LDFLAGS "-L../../googletest/build/lib -lgtest -lpthread" \
            -CFLAGS "-std=c++11" \
            -CFLAGS "-I../../googletest/googletest/include/" $(EXTRA_FLAGS_cpumemory)


all: directories $(TARGETS)
	@echo "done"

runtest: $(TARGETS)
	for test in $(TARGETS); do ./$$test || exit 1; done

gtest:
	./scripts/makegtest


# make sure build directory i built
.PHONY: directories

directories: build

build:
	@mkdir -p build

# Misc clean targets
clean:
	@rm -fr build *.bak

realclean: clean
	@rm -fr googletest db output_files simulation
