CRAMP_REPO?=$(realpath ../../../rtl/sim)
CRAMP_GEN_DIR?=${CRAMP_REPO}
CRAMP_VERILOG?=${CRAMP_GEN_DIR}/riscv.v

BOOT_BIN ?= ../../../../riscv-tests/isa/rv32ui-p-add.binhex
TIMEOUT ?= 2000

RISCV_TESTS_DIR ?= ../../../../riscv-tests/isa

TRACE?=yes

ADDCFLAGS += -CFLAGS -Iobj_dir

ADDCFLAGS += -CFLAGS -g
ADDCFLAGS += -CFLAGS -rdynamic

FLAGS += --autoflush
FLAGS += --output-split 5000
FLAGS += --output-split-cfuncs 500
FLAGS += --output-split-ctrace 500
FLAGS +=  --x-assign unique

ADDCFLAGS += -O3 -CFLAGS -O3

SRCS=src/main.cpp

OBJDIR=obj_dir
VERILATOR_OBJ_NAMES=Vriscv.cpp Vriscv.h Vriscv.mk
VERILATOR_OBJS=$(patsubst %,$(OBJDIR)/%,$(VERILATOR_OBJ_NAMES))

RISCV_TESTS=$(wildcard $(RISCV_TESTS_DIR)/*.binhex)
RISCV_TESTS_EXCLUDES=hash8 opened_hash
RISCV_TESTS_DO=$(filter-out $(patsubst %,$(RISCV_TESTS_DIR)/%.binhex,$(RISCV_TESTS_EXCLUDES)),$(RISCV_TESTS))
RISCV_TESTS_TARGETS=$(patsubst %.binhex,%.target,$(RISCV_TESTS_DO))

TIMEOUT_OVERRIDES = \
    fizzbuzz:100000 \
    dhry:20000 \
	coremark:20000 \
	sdc_rx:14000 \
	sdc_tx:14000

find_timeout = $(if $(firstword $(2)),$(if $(patsubst $(1):%,,$(firstword $(2))),$(call find_timeout,$(1),$(wordlist 2,9999,$(2))),$(patsubst $(1):%,%,$(firstword $(2)))),)

ifeq ($(TRACE),yes)
	VERILATOR_ARGS += --trace-fst
	ADDCFLAGS += -CFLAGS -DTRACE
endif

LIBS += "-lpthread -ldl"

print:
	echo $(call find_timeout,dhry,$(TIMEOUT_OVERRIDES))
	echo $(call find_timeout,fizzbuzz,$(TIMEOUT_OVERRIDES))
	echo $(call find_timeout,abc,$(TIMEOUT_OVERRIDES))

run: compile $(patsubst %.binhex,%.target,$(BOOT_BIN))

all-tests: compile $(RISCV_TESTS_TARGETS)

$(RISCV_TESTS_DIR)/%.target: $(RISCV_TESTS_DIR)/%.binhex
	$(eval TIMEOUT_OVERRIDE=$(call find_timeout,$(basename $(notdir $<)),$(TIMEOUT_OVERRIDES)))
	./$(OBJDIR)/Vriscv --load-boot-bin $< --timeout $(if $(TIMEOUT_OVERRIDE),$(TIMEOUT_OVERRIDE),$(TIMEOUT))

verilate: $(VERILATOR_OBJS)

$(VERILATOR_OBJS): ${CRAMP_VERILOG}
	verilator -cc  ${CRAMP_VERILOG} -CFLAGS -std=c++14 -LDFLAGS -pthread  ${ADDCFLAGS} ${FLAGS} --gdbbt ${VERILATOR_ARGS} -Wno-UNOPTFLAT -Wno-WIDTH --x-initial 0 --x-assign unique --exe ${SRCS}

compile: ./$(OBJDIR)/Vriscv

./$(OBJDIR)/Vriscv: verilate ${SRCS}
	make -j${THREAD_COUNT} -C $(OBJDIR)/ -f Vriscv.mk Vriscv LIBS=${LIBS}

clean:
	rm -rf $(OBJDIR)
