// See LICENSE for license details.

#include "insn_template.h"
#include "insn_macros.h"

#define DECODE_MACRO_USAGE_LOGGED 0

#define PROLOGUE \
  reg_t npc = sext_xlen(pc + insn_length( MATCH_BCLR))

#define EPILOGUE \
  trace_opcode(p,  MATCH_BCLR, insn); \
  return npc

reg_t fast_rv32i_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 32
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}

reg_t fast_rv64i_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 64
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}

#undef DECODE_MACRO_USAGE_LOGGED
#define DECODE_MACRO_USAGE_LOGGED 1

reg_t logged_rv32i_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 32
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}

reg_t logged_rv64i_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 64
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}

#undef CHECK_REG
#define CHECK_REG(reg) require((reg) < 16)

#undef DECODE_MACRO_USAGE_LOGGED
#define DECODE_MACRO_USAGE_LOGGED 0

reg_t fast_rv32e_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 32
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}

reg_t fast_rv64e_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 64
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}

#undef DECODE_MACRO_USAGE_LOGGED
#define DECODE_MACRO_USAGE_LOGGED 1

reg_t logged_rv32e_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 32
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}

reg_t logged_rv64e_bclr(processor_t* p, insn_t insn, reg_t pc)
{
  #define xlen 64
  PROLOGUE;
  #include "insns/bclr.h"
  EPILOGUE;
  #undef xlen
}
