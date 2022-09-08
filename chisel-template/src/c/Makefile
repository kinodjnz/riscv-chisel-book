LIBGCC:=/opt/riscv/lib/gcc/riscv64-unknown-elf/11.1.0/rv32iac/ilp32/libgcc.a

start.o: start.c
	riscv64-unknown-elf-gcc -O2 -march=rv32iac -mabi=ilp32 -c -o $@ $<

%: %.c start.o
	riscv64-unknown-elf-gcc -O2 -march=rv32iac -mabi=ilp32 -c -o $@.o $<
	riscv64-unknown-elf-ld -b elf32-littleriscv start.o $@.o $(LIBGCC) -e _start -T link.ld -o $@
	riscv64-unknown-elf-objcopy -O binary $@ $@.bin
	od -An -tx1 -w1 -v $@.bin > ../hex/$@.hex   
	riscv64-unknown-elf-objdump -b elf32-littleriscv -D $@ > ../dump/$@.elf.dmp
	rm -f $@.o
	rm -f $@
