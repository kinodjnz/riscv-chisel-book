test-targets := $(patsubst %.binhex,%,$(subst ../riscv-tests/isa/,test-,$(wildcard ../riscv-tests/isa/*.binhex)))

.PHONY: all-tests $(test-targest) test verilog bootrom rustfmt picocom help

all-tests:
	sbt "testOnly fpga.RiscvTest"

$(test-targets): ## Run individual test
	sbt "testOnly fpga.RiscvTest -- -t \"RiscV must runs $(patsubst test-%,%,$@)\""

test: ## Run tests
	sbt 'testOnly fpga.RiscvTest -- -t "RiscV must runs rv32ui-p-simple"'

verilog: ## Generate verilog from chisel source
	make -C ../vivado/riscv_arty35 src/riscv.v

bootrom: ## Make bootrom
	make -C src/rust/bootrom

rustfmt: ## Format rust files
	(cd src/rust/bootrom && cargo fmt)

picocom: ## Start picocom
	sudo picocom /dev/ttyUSB1 -b 115200 --omap crcrlf --imap lfcrlf

list-tests: ## List test targets
	for i in $(test-targets); do echo $$i; done

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
