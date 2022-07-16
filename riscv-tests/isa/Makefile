ELFDIR=../../../riscv-tests/isa
RV32UI_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32ui-p-*)))
RV32UC_TARGETS=$(subst $(ELFDIR)/,,$(filter-out %.dump,$(wildcard $(ELFDIR)/rv32uc-p-*)))
TARGETS=$(RV32UI_TARGETS) $(RV32UC_TARGETS)
BINHEX=$(patsubst %,%.binhex,$(TARGETS))
BIN=$(patsubst %,%.bin,$(TARGETS))
DUMP=$(patsubst %,%.dump,$(TARGETS))

.PHONY: all

all: $(BINHEX) $(DUMP)

$(BIN): %.bin: $(ELFDIR)/%
	riscv64-unknown-elf-objcopy -O binary $< $@

%.binhex: %.bin
	od -An -tx4 -w4 -v $< > $@
	od -An -tx1 -w1 -v $< | sed -n '1~4p' > $(patsubst %.binhex,%_0.binhex,$@)
	od -An -tx1 -w1 -v $< | sed -n '2~4p' > $(patsubst %.binhex,%_1.binhex,$@)
	od -An -tx1 -w1 -v $< | sed -n '3~4p' > $(patsubst %.binhex,%_2.binhex,$@)
	od -An -tx1 -w1 -v $< | sed -n '4~4p' > $(patsubst %.binhex,%_3.binhex,$@)

$(DUMP): %.dump: $(ELFDIR)/%.dump
	ln -s $< $@
