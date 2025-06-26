auto shamt = SHAMT & 31;
WRITE_RD(sext_xlen((RS1 & BFI3_MASK) << shamt) | sext_xlen(RS3 & ~(BFI3_MASK << shamt)));
