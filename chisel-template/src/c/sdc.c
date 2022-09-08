#include <stdint.h>

int main() {
    volatile uint32_t *sdc_setting  = (volatile uint32_t *)0x30003000;
    volatile uint32_t *sdc_control  = (volatile uint32_t *)0x30003004;
    volatile uint32_t *sdc_status   = (volatile uint32_t *)0x30003004;
    volatile uint32_t *sdc_command  = (volatile uint32_t *)0x30003008;
    volatile uint32_t *sdc_response = (volatile uint32_t *)0x30003008;

    *sdc_setting = 0x80000002;
    *sdc_command = 0x1234cdef;
    *sdc_control = 0x00000811;

    uint32_t s;
    while (!((s = *sdc_status) & 1))
        ;
    uint32_t r = *sdc_response;
    return (s == 1) && (r == 0x1234cdef);
}
