auto shamt = RS2 & 31;
WRITE_RD(sext_xlen(zext_xlen(RS1 & (BFI5_MASK << shamt)) >> shamt));
