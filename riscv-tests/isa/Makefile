ELFDIR=../../../riscv-tests/isa
RV32UI_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32ui-p-*)))
RV32UC_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32uc-p-*)))
RV32UM_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32um-p-*)))
RV32UZBB_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32uzbb-p-*)))
RV32UZBA_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32uzba-p-*)))
RV32UZBA_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32uzbs-p-*)))
RV32MI_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32mi-p-*-misaligned)))
TARGETS=$(RV32UI_TARGETS) $(RV32UC_TARGETS) $(RV32UM_TARGETS) $(RV32UZBB_TARGETS) $(RV32UZBA_TARGETS) $(RV32UZBS_TARGETS) $(RV32MI_TARGETS)
BINHEX=$(patsubst %,%.binhex,$(TARGETS))
BIN=$(patsubst %,%.bin,$(TARGETS))
DUMP=$(patsubst %,%.dump,$(TARGETS))

.PHONY: all

all: $(BINHEX) $(DUMP)

$(BIN): %.bin: $(ELFDIR)/%
	riscv32-unknown-elf-objcopy -O binary $< $@

%.binhex: %.bin
	# od -An -tx4 -w4 -v $< > $@
	hexdump -e '"%08x\n"' -v $< > $@

$(DUMP): %.dump: $(ELFDIR)/%.dump
	ln -s $< $@
