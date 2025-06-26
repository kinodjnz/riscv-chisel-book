auto shamt = SHAMT & 31;
WRITE_RD(sext_xlen(zext_xlen(RS1 & (BFI5_MASK << shamt)) >> shamt));
