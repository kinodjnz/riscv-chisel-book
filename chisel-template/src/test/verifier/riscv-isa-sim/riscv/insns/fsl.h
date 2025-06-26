WRITE_RD(sext_xlen(((zext_xlen(RS3) | (RS1 << 32)) << (RS2 & 31)) >> 32));
