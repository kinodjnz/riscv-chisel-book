auto shamt = RS2 & 31;
auto mask = RS2_MASK;
WRITE_RD(sext_xlen((zext_xlen(RS1 & (mask << shamt)) >> shamt) | (RS3 & ~(zext_xlen(mask << shamt) >> shamt))));
