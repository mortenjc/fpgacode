# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

# Add comment
define make_bintargets
bin/$(1)Test: build/$(1)/$(1).mk
endef

# Add comment
define make_mktargets
build/$(1)/$(1).mk: src/$(2)/$(1).sv test/$(1)_test.cpp
	@verilator -Wall -cc src/$(2)/$(1).sv -y . \
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
TARGETS = $(addsuffix Test, $(addprefix bin/, $(MODULES))) $(addsuffix Test, $(addprefix bin/, $(UNITS)))

vpath %.sv src/modules src/units

all: directories $(TARGETS)
	echo $(MODSV)
	@echo "done"


stage1Test:
	  echo $(MODSV)
		@verilator -Wall -cc src/units/stage1.sv src/modules/quantize16.sv src/modules/delay3clk.sv\
								-y . \
								-Mdir build/stage1 --prefix stage1 \
		            --exe ../test/stage1_test.cpp \
								-o stage1Test \
		            -LDFLAGS "-L../../googletest/build/lib -lgtest -lpthread" \
		            -CFLAGS "-std=c++11" \
		            -CFLAGS "-I../../googletest/googletest/include/"
		@make -C build/stage1 -j 8 -f stage1.mk
		cp build/stage1/stage1Test bin

# Create dependencies using macros
$(foreach module, $(MODULES), $(eval $(call make_bintargets,$(module))))
$(foreach unit, $(UNITS), $(eval $(call make_bintargets,$(unit))))
$(foreach module, $(MODULES), $(eval $(call make_mktargets,$(module),modules)))
$(foreach unit, $(UNITS), $(eval $(call make_mktargets,$(unit),units)))


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
