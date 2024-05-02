# LIBGCC:=/opt/riscv/lib/gcc/riscv64-unknown-elf/11.1.0/rv32imac/ilp32/libgcc.a
LIBGCC=

XLEN ?= 32
RISCV_PREFIX ?= riscv$(XLEN)-unknown-elf-
RISCV_GCC ?= $(RISCV_PREFIX)gcc
RISCV_LD ?= $(RISCV_PREFIX)ld
RISCV_OBJCOPY ?= $(RISCV_PREFIX)objcopy
RISCV_OBJDUMP ?= $(RISCV_PREFIX)objdump
# HEXDUMP ?= od -An -tx1 -w1 -v
HEXDUMP ?= hexdump -e '"%08x\n"' -v

start.o: start.c
	$(RISCV_GCC) -O2 -march=rv32imac -mabi=ilp32 -c -o $@ $<

%: %.c start.o
	$(RISCV_GCC) -O2 -march=rv32imac -mabi=ilp32 -c -o $@.o $<
	$(RISCV_LD) -A rv32imac start.o $@.o $(LIBGCC) -e _start -T link.ld -o $@
	$(RISCV_OBJCOPY) -O binary $@ $@.bin
	$(HEXDUMP) $@.bin > ../../../riscv-tests/isa/$@.binhex
	$(RISCV_OBJDUMP) -b elf32-littleriscv -D $@ > ../dump/$@.elf.dmp
	rm -f $@.o
	rm -f $@
