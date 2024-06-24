LLVM_PATH ?= ../../rust-lang/rust/build/aarch64-apple-darwin/llvm/bin

ARCH = riscv32
TARGET = $(ARCH)imc-unknown-none-elf

AS = $(LLVM_PATH)/llvm-mc
OBJDUMP = $(LLVM_PATH)/llvm-objdump
OBJCOPY = $(LLVM_PATH)/llvm-objcopy
STRIP = $(LLVM_PATH)/llvm-strip
LD = $(LLVM_PATH)/ld.lld
# HEXDUMP ?= od -An -tx1 -w1 -v
HEXDUMP ?= hexdump -e '"%08x\n"' -v

INSN_OPT = +zba,+zbs,+zbb,+xcramp
ASOPT = --arch=$(ARCH) --mattr=+c,+m,$(INSN_OPT),+relax

ADDRESS_COMMENT = ../address_comment.rb

target/lib%.a: src/bin/%.rs
	rustc --target=$(TARGET) -C relocation-model=pic -C target-feature=+zba,+zbs,+zbb,+xcramp,+relax -C opt-level=s -C lto=true -C codegen-units=1 -C panic=abort --crate-type=staticlib --out-dir=target $<
	# rustc --target=$(TARGET) -C relocation-model=pic -C target-feature=+zbb,+xcramp,+relax -C opt-level=s -C lto=true -C codegen-units=1 -C panic=abort --crate-type=staticlib --out-dir=target $<

target/%.o: src/%.S
	$(AS) $(ASOPT) --filetype=obj -o $@ $<

target/%.elf.fat: src/link.ld target/start.o target/lib%.a
	$(LD) -T $+ -o $@ -nostdlib --relax --gc-sections --nmagic

target/%.elf: target/%.elf.fat
	$(STRIP) --strip-all -o $@ $<

target/%.bin: target/%.elf.fat
	$(OBJCOPY) -O binary $< $@

../../../../riscv-tests/isa/%.binhex: target/%.bin
	$(HEXDUMP) $< > $@

target/%.dump.nocomment: target/%.elf.fat
	$(OBJDUMP) -dSC --mattr=$(INSN_OPT) --print-imm-hex $< > $@

../../dump/%.dump: target/%.dump.nocomment ../../../../riscv-tests/isa/%.binhex
	$(ADDRESS_COMMENT) < $< > $@
