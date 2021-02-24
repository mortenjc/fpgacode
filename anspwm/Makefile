# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

# Add comment
define make_bintargets
bin/$(1)Test: build/$(1)/$(1).mk
endef

# Add comment
define make_mktargets
build/$(1)/$(1).mk: src/modules/$(1).sv test/$(1)_test.cpp
	@verilator -Wall -cc src/modules/$(1).sv -y . \
							-Mdir build/$(1) --prefix $(1) \
	            --exe ../test/$(1)_test.cpp \
							-o $(1)Test \
	            -LDFLAGS "-L../../googletest/build/lib -lgtest -lpthread" \
	            -CFLAGS "-std=c++11" \
	            -CFLAGS "-I../../googletest/googletest/include/"
	@make -C build/$(1) -j 8 -f $(1).mk
	cp build/$(1)/$(1)Test bin
endef

MODULES = add4wsign clockdiv ddiff delay3clk #quantize16
TARGETS = $(addsuffix Test, $(addprefix bin/, $(MODULES)))


all: directories $(TARGETS)
	@echo "done"

#
$(foreach mymod, $(MODULES), $(eval $(call make_bintargets,$(mymod))))

#
$(foreach mymod, $(MODULES), $(eval $(call make_mktargets,$(mymod))))


runtest: $(TARGETS)
	for test in $(TARGETS); do ./$$test || exit 1; done

gtest:
	./scripts/makegtest

# make sure build directory is created
.PHONY: directories
#
directories: build

build:
	@mkdir -p build

# Misc clean targets
clean:
	@rm -fr build *.bak bin/*

realclean: clean
	@rm -fr googletest db output_files simulation
