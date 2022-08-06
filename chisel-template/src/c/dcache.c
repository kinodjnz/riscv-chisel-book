#include <stdint.h>

int main() {
    volatile uint32_t *p1  = (volatile uint32_t *)0x20001100;
    volatile uint32_t *p2  = (volatile uint32_t *)0x2000111c;
    volatile uint8_t  *pb2 = (volatile uint8_t *) 0x2000111d;
    volatile uint32_t *p3  = (volatile uint32_t *)0x20002100;
    volatile uint16_t *ph3 = (volatile uint16_t *)0x20002102;
    volatile uint32_t *p4  = (volatile uint32_t *)0x2000211c;
    volatile uint8_t  *pb4 = (volatile uint8_t *) 0x2000211f;
    volatile uint32_t *p5  = (volatile uint32_t *)0x20003100;
    volatile uint32_t *p6  = (volatile uint32_t *)0x2000311c;

    *p1 = 1;
    *pb2 = 2;
    *ph3 = 3;
    *pb4 = 4;

    uint32_t x = 0;
    x |= *p1 ^ 1;
    if (x != 0) return 2;
    x |= *p2 ^ (2 * 0x100);
    if (x != 0) return 3;
    x |= *p3 ^ (3 * 0x10000);
    if (x != 0) return 4;
    x |= *p4 ^ (4 * 0x1000000);
    if (x != 0) return 5;

    *p5 = 5;
    *p6 = 6;

    x |= *p5 ^ 5;
    if (x != 0) return 6;
    x |= *p6 ^ 6;
    if (x != 0) return 7;

    x |= *p1 ^ 1;
    if (x != 0) return 8;
    x |= *p2 ^ (2 * 0x100);
    if (x != 0) return 9;
    x |= *p3 ^ (3 * 0x10000);
    if (x != 0) return 10;
    x |= *p4 ^ (4 * 0x1000000);
    if (x != 0) return 11;

    return 1;
}
