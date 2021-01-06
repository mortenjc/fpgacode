


test:
	verilator -Wall -cc microaddr.v microaddr_counter.v --prefix Microaddr \
	--exe test.cpp -CFLAGS "-std=c++11"
	make -C obj_dir -f Microaddr.mk


runtest: test
	./obj_dir/Microaddr
