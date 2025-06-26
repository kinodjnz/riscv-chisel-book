auto shamt = SHAMT & 31;
WRITE_RD(sext(RS1 & (BFI5_MASK << shamt), std::min(insn.mask_len5_imm() + shamt, (sreg_t)xlen)) >> shamt);
