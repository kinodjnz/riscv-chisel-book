NAME = bootrom

RUST_SRCS = $(wildcard src/*.rs)

TARGET = riscv32imc-unknown-none-elf

AS = riscv32-elf-as
OBJDUMP = riscv32-elf-objdump
OBJCOPY = riscv32-elf-objcopy
LD = ld.lld

all: target/$(NAME).hex target/$(NAME).dump

target/CACHEDIR.TAG target/$(TARGET)/release/lib$(NAME).a: $(RUST_SRCS)
	cargo build --release

target/boot.o: libsrc/boot.s target/CACHEDIR.TAG
	$(AS) -mabi=ilp32 -o $@ $<

target/%.elf: libsrc/linker.ld target/boot.o target/$(TARGET)/release/lib%.a
	$(LD) -T $+ -o $@ -nostdlib --relax

target/%.bin: target/%.elf
	$(OBJCOPY) -O binary $< $@

target/%.hex: target/%.bin
	od -An -tx4 -w4 -v $< > $@

target/%.dump: target/%.elf
	$(OBJDUMP) -dSC $< > $@
