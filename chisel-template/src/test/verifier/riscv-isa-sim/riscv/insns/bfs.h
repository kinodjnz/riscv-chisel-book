auto shamt = RS2 & 31;
WRITE_RD(sext(RS1 & (BFI5_MASK << shamt), std::min(insn.mask_len5_imm() + shamt, (reg_t)xlen)) >> shamt);
