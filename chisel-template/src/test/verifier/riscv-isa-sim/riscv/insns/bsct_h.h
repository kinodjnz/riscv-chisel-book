reg_t x = RS1;
reg_t y = RS2;
int32_t c = 0;
uint32_t r = 0;
for (uint32_t i = 0; i < 16; i++) {
    if (y & (1 << i)) {
        r |= ((x >> c) & 1) << i;
        c += 1;
    }
}
WRITE_RD(sext_xlen(r));
