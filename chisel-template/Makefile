-include .env.mk

test-targets := $(patsubst %.binhex,%,$(subst ../riscv-tests/isa/,test-,$(wildcard ../riscv-tests/isa/*.binhex)))
scala-test-targets := $(patsubst %,scala-%,$(test-targets))

SBT ?= sbt

SCALA_DIR := src/main/scala/fpga
SCALA_SRCS := $(wildcard $(SCALA_DIR)/*.scala $(SCALA_DIR)/*/*.scala)
RISCV_CORE_DIR := rtl/riscv_arty_a7
RISCV_SIM_DIR := rtl/sim

.DEFAULT_GOAL = help

.PHONY: all-scala-tests
all-scala-tests: ## Run all tests by scalatest
	$(SBT) "testOnly fpga.RiscvTest"

.PHONY: $(scala-test-targets)
$(scala-test-targets): ## Run individual test by scalatest
	$(SBT) "testOnly fpga.RiscvTest -- -t \"RiscV must runs $(patsubst scala-test-%,%,$@)\""

.PHONY: scala-test
scala-test: ## Run simple test by scalatest
	$(SBT) 'testOnly fpga.RiscvTest -- -t "RiscV must runs rv32ui-p-simple"'

define TRACE_ASM_RULE
test_run_dir/RiscV_must_runs_$(subst -,,$(1))/trace.kanata.asm: test_run_dir/RiscV_must_runs_$(subst -,,$(1))/trace.kanata ../riscv-tests/isa/$(1).dump
	ruby trace_asm.rb $$^ -o $$@
endef

$(foreach target,$(test-targets),$(eval $(call TRACE_ASM_RULE,$(subst test-,,$(target)))))

asm-targets := $(subst -,,$(patsubst test-%,test_run_dir/RiscV_must_runs_%/trace.kanata.asm,$(test-targets)))

asm: $(asm-targets)

.PHONY: verilog
verilog: $(RISCV_CORE_DIR)/riscv.v ## Generate verilog from chisel source
# 	make -C ../vivado/riscv_arty35 src/riscv.v

.PHONY: vsim
vsim: $(RISCV_SIM_DIR)/riscv.v

$(RISCV_CORE_DIR)/riscv.v: $(SCALA_SRCS)
	$(SBT) "runMain fpga.ElaborateArtyA7"

$(RISCV_SIM_DIR)/riscv.v: $(SCALA_SRCS)
	$(SBT) "runMain fpga.sim.ElaborateSim"

.PHONY: bootrom
bootrom: ## Make bootrom
	make -C src/rust/bootrom

.PHONY: rustfmt
rustfmt: ## Format rust files
	(cd src/rust/bootrom && cargo fmt)

.PHONY: picocom
picocom: ## Start picocom
	sudo picocom /dev/ttyUSB1 -b 115200 --omap crcrlf --imap lfcrlf

.PHONY: list-tests
list-tests: ## List test targets
	@for i in $(test-targets); do echo $$i; done

.PHONY: test
test: vsim ## Run simple test
	$(MAKE) -C src/test/verifier test-rv32ui-p-add

.PHONY: $(test-targets)
$(test-targets): vsim
	$(MAKE) -C src/test/verifier $@

.PHONY: all-tests
all-tests: vsim $(test-targets) ## Run all tests

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1,$(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
