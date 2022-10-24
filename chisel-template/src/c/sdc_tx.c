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
    *sdc_control = 0x00004981;

    uint32_t r = 0;
    int done = 0;
    while (done < 1) {
        uint32_t s = *sdc_status;
        if (s & 1) {
            r = *sdc_response;
            done++;
        }
    }
    for (int i = 0; i < 128; i++) {
        *sdc_data = 0xa9876543;
    }
    while (done < 2) {
        uint32_t s = *sdc_status;
        if (s & 0x200000) {
            r = s;
            done++;
        }
    }

    if (r != 0x200000) return 3;
    return 1;
}
