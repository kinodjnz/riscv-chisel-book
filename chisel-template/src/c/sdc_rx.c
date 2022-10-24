#include <stdint.h>

int main() {
    volatile uint32_t *sdc_setting  = (volatile uint32_t *)0x30003000;
    volatile uint32_t *sdc_control  = (volatile uint32_t *)0x30003004;
    volatile uint32_t *sdc_status   = (volatile uint32_t *)0x30003004;
    volatile uint32_t *sdc_command  = (volatile uint32_t *)0x30003008;
    volatile uint32_t *sdc_response = (volatile uint32_t *)0x30003008;
    volatile uint32_t *sdc_data     = (volatile uint32_t *)0x3000300C;

    *sdc_setting = 0x80000001;
    *sdc_command = 0x1234cdef;
    *sdc_control = 0x00001811;

    uint32_t r = 0;
    uint32_t e = 0;
    int done = 0;
    while (done < 2) {
        uint32_t s = *sdc_status;
        if (s & 1) {
            r = *sdc_response;
            done++;
        }
        if (s & 0x10000) {
            for (int i = 0; i < 128; i++) {
                uint32_t x = *sdc_data;
                if (x != 0xdddddddd) {
                    e++;
                }
            }
            done++;
        }
    }
    if (r != 0x1234cdef) return 3;
    if (e != 0) return 3 + e;
    return 1;
}
