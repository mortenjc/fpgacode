# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

# The main targets are the test executables: bin/xxxTest
define make_bintargets
bin/$(1)Test: build/$(1)/$(1).mk
endef

# Parametrise the dependencies
# $(1) verilog module name
# $(2) get .sv from module/ or unit/
# $(3) additional .sv sources (for units)
define make_mktargets
build/$(1)/$(1).mk: src/$(2)/$(1).sv test/$(1)_test.cpp
	@verilator -Wall -cc src/$(2)/$(1).sv $(3) -y . \
							-Mdir build/$(1) --prefix $(1) \
	            --exe ../test/$(1)_test.cpp \
							-o $(1)Test \
	            -LDFLAGS "-L../../googletest/build/lib -lgtest -lpthread" \
	            -CFLAGS "-std=c++11" \
	            -CFLAGS "-I../../googletest/googletest/include/"
	@make -C build/$(1) -j 8 -f $(1).mk
	cp build/$(1)/$(1)Test bin
endef

MODULES = add4wsign clockdiv ddiff delay3clk quantize16
UNITS = stage1
UNITS.stage1 = src/modules/quantize16.sv src/modules/delay3clk.sv
TARGETS = $(addsuffix Test, $(addprefix bin/, $(MODULES))) $(addsuffix Test, $(addprefix bin/, $(UNITS)))

vpath %.sv src/modules src/units

all: directories $(TARGETS)
	@echo "done"

# Create dependencies using macros
# main targets
$(foreach module, $(MODULES), $(eval $(call make_bintargets,$(module))))
$(foreach unit, $(UNITS), $(eval $(call make_bintargets,$(unit))))
# dependencies
$(foreach module, $(MODULES), $(eval $(call make_mktargets,$(module),modules)))
$(eval $(call make_mktargets,stage1,units,$(UNITS.stage1)))

#
runtest: $(TARGETS)
	for test in $(TARGETS); do ./$$test || exit 1; done

gtest:
	./scripts/makegtest

# make sure build directory is created
.PHONY: directories
#
directories: build bin

build:
	@mkdir -p build
	@mkdir -p bin

# Misc clean targets
clean:
	@rm -fr build *.bak bin

realclean: clean
	@rm -fr googletest db output_files simulation
