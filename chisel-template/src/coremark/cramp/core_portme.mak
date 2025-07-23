# Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Original Author: Shay Gal-on

#File : core_portme.mak

.PHONY: default
.DEFAULT_GOAL := default
default: ../../../riscv-tests/isa/coremark.binhex ../dump/coremark.dump

ITERATIONS := 1

CLANG_PATH ?= /usr/bin
LLVM_PATH ?= /usr/bin
GCC_PATH ?= /usr/bin
GCC_BIN_PREFIX ?= riscv64-elf-
LIBGCC ?=

COMPILER ?= clang
# COMPILER ?= gcc

# Flag : OUTFLAG
#	Use this flag to define how to to get an executable (e.g -o)
OUTFLAG= -o

ifeq ($(COMPILER), clang)
# Flag : CC
#	Use this flag to define compiler to use
CC 		= $(CLANG_PATH)/clang
# Flag : LD
#	Use this flag to define compiler to use
LD		= $(LLVM_PATH)/ld.lld
# Flag : AS
#	Use this flag to define compiler to use
AS		= $(LLVM_PATH)/llvm-mc
LLC     = $(LLVM_PATH)/llc
else ifeq ($(COMPILER), gcc)
CC 		= $(GCC_PATH)/$(GCC_BIN_PREFIX)gcc
LD		= $(GCC_PATH)/$(GCC_BIN_PREFIX)gcc
AS		= $(GCC_PATH)/$(GCC_BIN_PREFIX)as
endif

OBJDUMP = $(LLVM_PATH)/llvm-objdump
OBJCOPY = $(LLVM_PATH)/llvm-objcopy
ADDRESS_COMMENT = ./address_comment.rb
HEXDUMP ?= hexdump -e '"%08x\n"' -v

# RUN_TYPE = 
RUN_TYPE = -DTOTAL_DATA_SIZE=360 -DPROFILE_RUN=1

OPT = -O2

#	Define any libraries needed for linking or other flags that should come at the end of the link line (e.g. linker scripts). 
#	Note : On certain platforms, the default clock_gettime implementation is supported but requires linking of librt.
SEPARATE_COMPILE=1
# Flag : SEPARATE_COMPILE
# You must also define below how to create an object file, and how to link.

ifeq ($(COMPILER), clang)
PORT_CFLAGS = $(OPT) -flto -funified-lto $(RUN_TYPE)
LCFLAGS = $(OPT) --march=riscv32 --mtriple=riscv32imc-unknown-none-elf --mattr=+c,+m,+zba,+zbs,+zbb,+xcramp,+relax --filetype=obj
LFLAGS 	= -nostdlib --relax --gc-sections --nmagic --fat-lto-objects --lto=full --lto-emit-llvm
LFLAGS_END = 
ASFLAGS = --arch=riscv32 --mattr=+c,+m,+zba,+zbs,+zbb,+xcramp,+relax --filetype=obj
LLOUT   = -S -emit-llvm --target=riscv32
BCOUT   = -c -emit-llvm --target=riscv32
LTOOUT  = -c --target=riscv32
LDFLAGS = -T cramp/link.ld cramp/start.o cramp/memset.o -nostdlib --relax --gc-sections --nmagic
PORT_CLEAN = coremark.hex coremark.dump coremark.lbc coremark.lto
# Flag : PORT_SRCS
# 	Port specific source files can be added here
#	You may also need cvt.c if the fcvt functions are not provided as intrinsics by your compiler!
PORT_SRCS = $(PORT_DIR)/core_portme.c $(PORT_DIR)/start.s $(PORT_DIR)/memset.s # $(PORT_DIR)/ee_printf.c
PORT_OBJS = $(PORT_DIR)/start.o $(PORT_DIR)/core_portme.o $(PORT_DIR)/memset.o
else ifeq ($(COMPILER), gcc)
PORT_CFLAGS = $(OPT) -flto -march=rv32imac_zba_zbs_zbb -mabi=ilp32 -finline-stringops $(RUN_TYPE)
ASFLAGS = -march=rv32imac_zba_zbs_zbb -mabi=ilp32
LFLAGS 	= -nostdlib $(OPT) -flto -march=rv32imac_zba_zbs_zbb -mabi=ilp32 -e _start -T cramp/link.ld
LFLAGS_END = $(LIBGCC)
PORT_CLEAN = coremark.hex coremark.dump coremark.elf
# Flag : PORT_SRCS
# 	Port specific source files can be added here
#	You may also need cvt.c if the fcvt functions are not provided as intrinsics by your compiler!
PORT_SRCS = $(PORT_DIR)/core_portme.c $(PORT_DIR)/start.s $(PORT_DIR)/memset_gcc.s # $(PORT_DIR)/ee_printf.c
PORT_OBJS = $(PORT_DIR)/start.o $(PORT_DIR)/core_portme.o # $(PORT_DIR)/memset_gcc.o
endif

# Flag : CFLAGS
#	Use this flag to define compiler options. Note, you can add compiler options from the command line using XCFLAGS="other flags"
FLAGS_STR = "$(PORT_CFLAGS) $(XCFLAGS) $(XLFLAGS) $(LFLAGS_END)"
CFLAGS = $(PORT_CFLAGS) -I$(PORT_DIR) -I. -DFLAGS_STR=\"$(FLAGS_STR)\" -DCLOCKS_PER_SEC=100000000
#Flag : LFLAGS_END
OBJOUT 	= -o
OFLAG 	= -o
COUT 	= -c

vpath %.c $(PORT_DIR)
vpath %.s $(PORT_DIR)

# Flag : LOAD
#	For a simple port, we assume self hosted compile and run, no load needed.

# Flag : RUN
#	For a simple port, we assume self hosted compile and run, simple invocation of the executable

LOAD = echo "Please set LOAD to the process of loading the executable to the flash"
RUN = echo "Please set LOAD to the process of running the executable (e.g. via jtag, or board reset)"

OEXT = .o

ifeq ($(COMPILER), clang)
EXE = .lbc
LLEXT = .ll
ASEXT = .s
BCEXT = .bc

.SUFFIXES:
.SUFFIXES: .o .bc .s .ll .lto

# $(OPATH)$(PORT_DIR)/%$(OEXT) : %.c
# 	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@

# $(OPATH)%$(OEXT) : %.c
# 	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@

$(OPATH)$(PORT_DIR)/%$(LLEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(LLOUT) $< $(OBJOUT) $@

$(OPATH)%$(LLEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(LLOUT) $< $(OBJOUT) $@

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(BCOUT) $< $(OBJOUT) $@

$(OPATH)%$(OEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(BCOUT) $< $(OBJOUT) $@

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.bc
	$(LLC) $(LCFLAGS) $< $(OBJOUT) $@

$(OPATH)%$(OEXT) : %.bc
	$(LLC) $(LCFLAGS) $< $(OBJOUT) $@

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.s
	$(AS) $(ASFLAGS) $< $(OBJOUT) $@

$(OPATH)%$(OEXT) : %.s
	$(AS) $(ASFLAGS) $< $(OBJOUT) $@
else ifeq ($(COMPILER), gcc)
EXE = .elf
ASEXT = .s

.SUFFIXES:
.SUFFIXES: .o .s

$(OPATH)$(PORT_DIR)/%$(OEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@

$(OPATH)%$(OEXT) : %.c
	$(CC) $(CFLAGS) $(XCFLAGS) $(COUT) $< $(OBJOUT) $@
endif

# Target : port_pre% and port_post%
# For the purpose of this simple port, no pre or post steps needed.

.PHONY : port_prebuild port_postbuild port_prerun port_postrun port_preload port_postload
port_pre% port_post% : 

# FLAG : OPATH
# Path to the output folder. Default - current folder.
OPATH = ./
MKDIR = mkdir -p

ifeq ($(COMPILER), clang)
$(OPATH)%.lto: %.lbc
	$(LLC) $(LCFLAGS) $< $(OBJOUT) $@

$(OPATH)%.elf: %.lto
	$(LD) $(LDFLAGS) $< $(OBJOUT) $@
endif

$(OPATH)%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

../../../riscv-tests/isa/%.binhex: %.bin
	$(HEXDUMP) $< > $@

$(OPATH)%.dump.nocomment: %.elf
	$(OBJDUMP) -dSC --mattr=+zba,+zbs,+zbb,+xcramp --print-imm-hex $< > $@

../dump/%.dump: %.dump.nocomment ../../../riscv-tests/isa/%.binhex
	$(ADDRESS_COMMENT) < $< > $@
