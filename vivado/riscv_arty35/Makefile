.PHONY: all clean restore device-tree open

PROJECT_NAME := riscv_arty35
ARTY_SIZE ?= 35
TARGET_PART ?= digilentinc.com:arty-a7-$(ARTY_SIZE):part0:1.0
BD_NAME := design_top
BITSTREAM := project/$(PROJECT_NAME).runs/impl_1/$(BD_NAME)_wrapper.bit
BITSTREAM_BIN := $(BD_NAME)_wrapper.bit.bin
SDK_DIR := project/$(PROJECT_NAME).sdk
HARDWARE_DEF := $(SDK_DIR)/$(BD_NAME)_wrapper.xsa
BOOTROM := src/bootrom.hex
PACKAGE := fpga
SCALA_DIR := ../../chisel-template/src/main/scala/fpga
SCALA_SRCS := $(wildcard $(SCALA_DIR)/*.scala $(SCALA_DIR)/*/*.scala)

BASH := /bin/bash
RISCV_CORE_DIR := ../../chisel-template/rtl/riscv_arty_a7
RISCV_CORE := $(RISCV_CORE_DIR)/riscv.v
VIVADO ?= vivado
HSI ?= hsi
BOOTGEN ?= bootgen

SRCS := \
	src/riscv.v  \
	src/top.sv  \
	src/top_vivado.v \
	src/pins.xdc \
	src/debug.xdc \

all: $(HARDWARE_DEF)

restore: project/$(PROJECT_NAME).xpr

clean:
	-@rm -rf project
	-@rm *.jou *.str *.btree *.log
	cd src/sw; make clean

open: project/$(PROJECT_NAME).xpr
	$(VIVADO) $<&

project/$(PROJECT_NAME).xpr: $(SRCS) $(BOOTROM)
	$(VIVADO) -mode batch -source riscv_arty35.tcl -tclargs $(PROJECT_NAME) ${BD_NAME} ${TARGET_PART}

$(BITSTREAM) $(HARDWARE_DEF): project/$(PROJECT_NAME).xpr $(SRCS) project/$(PROJECT_NAME).srcs/sources_1/bd/$(BD_NAME)/$(BD_NAME).bd
	$(VIVADO) -mode batch -source implement.tcl -tclargs $(PROJECT_NAME) $(BD_NAME)

$(BOOTROM): src/sw/bootrom.c src/sw/link.ld src/sw/Makefile
	cd src/sw; make all

$(RISCV_CORE_DIR)/riscv.v: $(SCALA_SRCS)
	cd ../../chisel-template; sbt "runMain $(PACKAGE).ElaborateArtyA7"

src/riscv.v: $(RISCV_CORE_DIR)/riscv.v
