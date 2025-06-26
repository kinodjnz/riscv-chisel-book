auto shamt = SHAMT & 31;
WRITE_RD(sext_xlen((zext_xlen(RS1 & (BFI3_MASK << shamt)) >> shamt) | (RS3 & ~(zext_xlen(BFI3_MASK << shamt) >> shamt))));
