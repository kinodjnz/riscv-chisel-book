test:
	sbt "testOnly fpga.RiscvTest"

verilog:
	make -C ../vivado/riscv_arty35 src/riscv.v

bootrom:
	make -C src/rust/bootrom
