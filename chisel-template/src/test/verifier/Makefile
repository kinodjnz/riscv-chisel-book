CRAMP_REPO?=$(realpath ../../../rtl/sim)
CRAMP_GEN_DIR?=$(CRAMP_REPO)

BOOT_BIN ?= ../../../../riscv-tests/isa/rv32ui-p-add.binhex
TIMEOUT ?= 2000

RISCV_TESTS_DIR ?= ../../../../riscv-tests/isa

TRACE?=yes

UT_OPTS?=

ADDCFLAGS += -CFLAGS -Isim/obj_dir

ADDCFLAGS += -CFLAGS -g
ADDCFLAGS += -CFLAGS -rdynamic

# spike
ADDCFLAGS += -CFLAGS -I$(realpath riscv-isa-sim/riscv)
# ADDCFLAGS += -CFLAGS -I riscv-isa-sim/fesvr
# ADDCFLAGS += -CFLAGS -I riscv-isa-sim/fdt
# ADDCFLAGS += -CFLAGS -I riscv-isa-sim

CXXFLAGS += -I riscv-isa-sim/riscv
CXXFLAGS += -I riscv-isa-sim/fesvr
CXXFLAGS += -I riscv-isa-sim/fdt
CXXFLAGS += -I riscv-isa-sim/softfloat
CXXFLAGS += -I riscv-isa-sim

FLAGS += --autoflush
FLAGS += --output-split 5000
FLAGS += --output-split-cfuncs 500
FLAGS += --output-split-ctrace 500
FLAGS +=  --x-assign unique

ADDCFLAGS += -O2 -CFLAGS -O2

SPIKE_DIR = $(realpath riscv-isa-sim)
SPIKE_RISCV_SRCS = $(filter-out $(SPIKE_DIR)/riscv/insn_template.cc $(SPIKE_DIR)/riscv/check-opcode-overlap.t.cc,$(wildcard $(SPIKE_DIR)/riscv/*.cc))
SPIKE_FESVR_SRCS = $(filter-out $(SPIKE_DIR)/fesvr/elf2hex.cc,$(wildcard $(SPIKE_DIR)/fesvr/*.cc))
SPIKE_CC_SRCS = $(SPIKE_RISCV_SRCS) $(SPIKE_FESVR_SRCS) $(wildcard $(SPIKE_DIR)/disasm/*.cc)
SPIKE_CC_OBJS = $(subst riscv-isa-sim/,riscv-isa-sim/obj_dir/,$(patsubst %.cc,%.o,$(SPIKE_CC_SRCS)))
SPIKE_C_SRCS = $(wildcard $(SPIKE_DIR)/fdt/*.c $(SPIKE_DIR)/softfloat/*.c)
SPIKE_C_OBJS = $(subst riscv-isa-sim/,riscv-isa-sim/obj_dir/,$(patsubst %.c,%.o,$(SPIKE_C_SRCS)))

SPIKE_SUBDIRS = riscv fesvr fdt disasm softfloat
SPIKE_OBJDIRS = $(patsubst %,$(SPIKE_DIR)/obj_dir/%,$(SPIKE_SUBDIRS))

SIM_NAME = riscv
SIM_VERILOG ?= $(CRAMP_GEN_DIR)/$(SIM_NAME).v
SIM_DIR = sim
SIM_SRCS = $(SIM_DIR)/src/main.cpp $(SPIKE_CC_OBJS) $(SPIKE_C_OBJS)

.PHONY: aaa
aaa: # $(SPIKE_OBJS)
	echo $(SPIKE_OBJDIRS)

CXX = c++
GCC_CXX = g++
GCC_CXXFLAGS_NO_UNUSED = -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-c++11-narrowing -Wno-constant-logical-operand -Wno-non-pod-varargs -Wno-parentheses-equality -Wno-shadow -Wno-sign-compare -Wno-tautological-bitwise-compare -Wno-tautological-compare -Wno-uninitialized -Wno-unused-but-set-parameter -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable
CC = cc
GCC_CC = gcc

OBJ_DIR = obj_dir
VERILATOR_OBJ_POSTFIXES = .cpp .h .mk

UT_DIRS = $(filter-out $(SIM_DIR),$(patsubst %/,%,$(wildcard */)))

SIM_VERILATOR_OBJ_NAMES=V$(SIM_NAME).cpp V$(SIM_NAME).h V$(SIM_NAME).mk
SIM_VERILATOR_OBJS=$(patsubst %,$(SIM_DIR)/$(OBJ_DIR)/%,$(SIM_VERILATOR_OBJ_NAMES))

RISCV_TESTS=$(wildcard $(RISCV_TESTS_DIR)/*.binhex)
RISCV_TESTS_EXCLUDES=hash8 opened_hash
RISCV_TESTS_DO=$(filter-out $(patsubst %,$(RISCV_TESTS_DIR)/%.binhex,$(RISCV_TESTS_EXCLUDES)),$(RISCV_TESTS))
RISCV_TESTS_TARGETS=$(patsubst %.binhex,%.target,$(RISCV_TESTS_DO))

# SPIKE_SRCS=

TIMEOUT_OVERRIDES = \
    fizzbuzz:10000 \
    dhry:20000 \
	coremark:20000 \
	sdc_rx:14000 \
	sdc_tx:14000

find_timeout = $(if $(firstword $(2)),$(if $(patsubst $(1):%,,$(firstword $(2))),$(call find_timeout,$(1),$(wordlist 2,9999,$(2))),$(patsubst $(1):%,%,$(firstword $(2)))),)

ifeq ($(TRACE),yes)
	VERILATOR_ARGS += --trace-fst --trace-params --trace-structs --trace-underscore
	ADDCFLAGS += -CFLAGS -DVERILATOR_TRACE
endif

LIBS += "-lpthread -ldl"

.DEFAULT_GOAL = help

print:
	@echo $(call find_timeout,dhry,$(TIMEOUT_OVERRIDES))
	@echo $(call find_timeout,fizzbuzz,$(TIMEOUT_OVERRIDES))
	@echo $(call find_timeout,abc,$(TIMEOUT_OVERRIDES))

run: sim-compile $(patsubst %.binhex,%.target,$(BOOT_BIN)) ## run

all-tests: sim-compile $(RISCV_TESTS_TARGETS)

test-%: sim-compile $(RISCV_TESTS_DIR)/%.binhex
	$(eval TIMEOUT_OVERRIDE=$(call find_timeout,$(patsubst test-%,%,$@),$(TIMEOUT_OVERRIDES)))
	$(SIM_DIR)/$(OBJ_DIR)/V$(SIM_NAME) --load-boot-bin $(word 2,$?) --timeout $(if $(TIMEOUT_OVERRIDE),$(TIMEOUT_OVERRIDE),$(TIMEOUT)) --trace-fst $(SIM_DIR)/logs/$@.fst

sim-compile: $(SIM_DIR)/$(OBJ_DIR)/V$(SIM_NAME)

$(SIM_DIR)/$(OBJ_DIR)/V$(SIM_NAME): sim-verilate $(SIM_SRCS)
	make -j$(THREAD_COUNT) -C $(SIM_DIR)/$(OBJ_DIR)/ -f V$(SIM_NAME).mk V$(SIM_NAME) LIBS=$(LIBS)

sim-verilate: $(SIM_VERILATOR_OBJS)

$(SIM_VERILATOR_OBJS): $(SIM_VERILOG) $(SIM_SRCS)
	verilator -cc --Mdir $(SIM_DIR)/$(OBJ_DIR) $(SIM_VERILOG) -CFLAGS -std=c++23 -LDFLAGS -pthread $(ADDCFLAGS) $(FLAGS) --gdbbt $(VERILATOR_ARGS) -Wno-UNOPTFLAT -Wno-WIDTH --x-initial 0 --x-assign unique --exe $(SIM_SRCS)

UT_VERILATOR_OBJS = $(foreach postfixes,.mk,$(foreach ut_name,$(UT_DIRS),$(ut_name)/$(OBJ_DIR)/V$(ut_name)$(postfixes)))
UT_EXECUTABLES = $(foreach ut_name,$(UT_DIRS),$(ut_name)/$(OBJ_DIR)/V$(ut_name))
UT_TARGET = $(patsubst %,ut-%,$(UT_DIRS))

.PHONY: all-ut
all-ut: $(UT_TARGET)

.PHONY: $(UT_TARGET)
.SECONDEXPANSION:
$(UT_TARGET): %: $$(foreach ut_name,$$(subst ut-,,%),$$(ut_name)/$(OBJ_DIR)/V$$(ut_name))
	$< $(UT_OPTS)

.PHONY: ut-compile
ut-compile: $(UT_EXECUTABLES)

.SECONDEXPANSION:
$(UT_EXECUTABLES): %: $(UT_VERILATOR_OBJS) $$(firstword $$(subst /, ,%))/src/main.cpp
	make -j$(THREAD_COUNT) -C $(firstword $(subst /, ,$@))/$(OBJ_DIR)/ -f V$(firstword $(subst /, ,$@)).mk V$(firstword $(subst /, ,$@)) CXX=$(GCC_CXX) LINK=$(GCC_CXX) USER_CPPFLAGS="$(USER_CPPFLAGS)" USER_LDFLAGS="$(USER_LDFLAGS)" USER_LDLIBS="$(USER_LDLIBS)" CFG_CXXFLAGS_NO_UNUSED="$(GCC_CXXFLAGS_NO_UNUSED)" VK_PCH_I_FAST= VK_PCH_I_SLOW= LIBS=$(LIBS)

.PHONY: ut-verilate
ut-verilate: $(UT_VERILATOR_OBJS)

.SECONDEXPANSION:
$(UT_VERILATOR_OBJS): %.mk: $(CRAMP_GEN_DIR)/$$(firstword $$(subst /, ,%)).v
	verilator -cc --Mdir $(firstword $(subst /, ,$@))/$(OBJ_DIR) $< -CFLAGS -std=c++23 -LDFLAGS -pthread $(ADDCFLAGS) $(FLAGS) --gdbbt $(VERILATOR_ARGS) -Wno-UNOPTFLAT -Wno-WIDTH --x-initial 0 --x-assign unique --exe $(firstword $(subst /, ,$@))/src/*.cpp

.PHONY: clean
clean: clean-ut
	rm -rf $(SIM_DIR)/$(OBJ_DIR)

CLEAN_UT_TARGET = $(patsubst %,clean-ut-%,$(UT_DIRS))

.PHONY: clean-ut
clean-ut: $(CLEAN_UT_TARGET)

$(CLEAN_UT_TARGET):
	rm -rf $(subst clean-ut-,,$@)/$(OBJ_DIR)

$(SPIKE_DIR)/obj_dir: $(SPIKE_OBJDIRS)

$(SPIKE_OBJDIRS):
	mkdir -p $@

$(SPIKE_CC_OBJS): %.o: $$(subst /obj_dir/,/,%.cc) $(SPIKE_DIR)/obj_dir
	$(CXX) -std=c++23 $(CXXFLAGS) -DPREFIX=\"$(SPIKE_DIR)/obj_dir\" -c -o $@ $<

$(SPIKE_C_OBJS): %.o: $$(subst /obj_dir/,/,%.c) $(SPIKE_DIR)/obj_dir
	$(CC) $(CXXFLAGS) -c -o $@ $<

.PHONY: gen_srcs
gen_srcs: $(SPIKE_DIR)/riscv/insn_list.h
	make -C $(dir $<) -f riscv.mk $@ src_dir=$(SPIKE_DIR)

$(SPIKE_DIR)/riscv/insn_list.h: $(SPIKE_DIR)/riscv/riscv.mk
	make -C $(dir $<) -f riscv.mk $(notdir $@) src_dir=$(SPIKE_DIR)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
