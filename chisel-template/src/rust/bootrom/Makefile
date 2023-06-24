NAME := bootrom

RUST_SRCS := $(wildcard src/*.rs)

TARGET := riscv32imc-unknown-none-elf

CARGO := cargo
ADDRESS_COMMENT := ./address_comment.rb

LLVM_BIN_PATH ?= /usr/bin
AS := $(LLVM_BIN_PATH)/llvm-mc
OBJDUMP := $(LLVM_BIN_PATH)/llvm-objdump
OBJCOPY := $(LLVM_BIN_PATH)/llvm-objcopy
LD := $(LLVM_BIN_PATH)/ld.lld

# HEXDUMP := od
# HEXDUMP_FLAGS := -An -tx4 -w4 -v
HEXDUMP := hexdump
HEXDUMP_FLAGS := -e '"%08x\n"' -v

CARGO_FLAGS := +stage1
AS_FLAGS := --arch=riscv32 --mattr=+c,+m,+zba,+zbb,+zbs,+relax

all: target/$(NAME).hex target/$(NAME).dump target/$(NAME).elf

target/CACHEDIR.TAG target/$(TARGET)/release/lib$(NAME).a: $(RUST_SRCS)
	$(CARGO) $(CARGO_FLAGS) build --release

target/boot.o: libsrc/boot.s target/CACHEDIR.TAG
	$(AS) $(AS_FLAGS) --filetype=obj -o $@ $<

target/%.elf: libsrc/linker.ld target/boot.o target/$(TARGET)/release/lib%.a
	$(LD) -T $+ -o $@ -nostdlib --relax

target/%.bin: target/%.elf
	$(OBJCOPY) -O binary $< $@

target/%.hex: target/%.bin
	$(HEXDUMP) $(HEXDUMP_FLAGS) $< > $@

target/%.dump.nocomment: target/%.elf
	$(OBJDUMP) -dSC --mattr=+zba,+zbb,+zbs --print-imm-hex $< > $@

target/%.dump: target/%.dump.nocomment
	$(ADDRESS_COMMENT) < $< > $@
