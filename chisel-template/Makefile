test:
	sbt "testOnly fpga.RiscvTest"

verilog:
	make -C ../vivado/riscv_arty35 src/riscv.v

bootrom:
	make -C src/rust/bootrom

rustfmt:
	(cd src/rust/bootrom && cargo fmt)

picocom:
	sudo picocom /dev/ttyUSB1 -b 115200
