MODULES := microaddr_counter
TYPE_FILES := microaddr_types.sv

%:%.sv $(TYPE_FILES) %_test.cpp
	echo $(<:%.sv-%)
	verilator -Wall -cc $(TYPE_FILES) $@ -y . -Mdir $@ --prefix $@ \
		--exe  $(@:%=%_test.cpp) -CFLAGS "-std=c++11" \
		-Gopjump_table_file='"opjump_table_test.data"'
	make -C $@ -j 8 -f $@.mk

all: $(MODULES)


clean:
	rm -fr $(MODULES)
