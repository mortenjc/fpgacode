# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

include makefiles/Makefile.macros

MODULES = add4wsign clockdivparm ddiff delay3clk quantize16 target1v
UNITS = dspmod stage1 stage2 clockunit

UNITS.dspmod = src/units/stage1.sv src/modules/quantize16.sv \
      src/modules/delay3clk.sv src/units/stage2.sv src/units/ddiff3.sv \
			src/modules/ddiff.sv src/units/stage3.sv src/units/stage4.sv \
			src/modules/add4wsign.sv
UNITS.stage1 = src/modules/quantize16.sv src/modules/delay3clk.sv
UNITS.stage2 = src/modules/quantize16.sv src/units/ddiff3.sv \
      src/modules/ddiff.sv src/modules/delay3clk.sv
UNITS.clockunit = src/modules/clockdivparm.sv src/modules/clocksel.sv

TARGETS = $(addsuffix Test, $(addprefix bin/, $(MODULES))) $(addsuffix Test, $(addprefix bin/, $(UNITS)))
COVTARGETS = $(addsuffix .dat, $(addprefix logs/, $(MODULES)))

vpath %.sv src/modules src/units

all: directories $(TARGETS)
	@echo "done"

# Create dependencies using macros
# main targets
$(foreach module, $(MODULES), $(eval $(call make_bintargets,$(module))))
$(foreach unit, $(UNITS), $(eval $(call make_bintargets,$(unit))))
# dependencies
$(foreach module, $(MODULES), $(eval $(call make_mktargets,$(module),modules)))
$(foreach unit, $(UNITS), $(eval $(call make_mktargets,$(unit),units,$(UNITS.$(unit)))))


include makefiles/Makefile.test

# make sure build directory is created
.PHONY: directories
#
directories: build bin

build:
	@mkdir -p build bin logs

# Misc clean targets
clean:
	@rm -fr build bin logs *.bak

realclean: clean
	@rm -fr googletest db output_files simulation
