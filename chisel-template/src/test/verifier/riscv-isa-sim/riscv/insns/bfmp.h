auto shamt = RS2 & 31;
WRITE_RD(sext_xlen(RS1 & (RS2_MASK << shamt)) | sext_xlen(RS3 & ~(RS2_MASK << shamt)));
