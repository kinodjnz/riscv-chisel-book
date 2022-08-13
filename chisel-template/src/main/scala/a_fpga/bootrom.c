#include <stdint.h>
#include <string.h>

extern void __attribute__((naked)) __attribute__((section(".isr_vector"))) isr_vector(void)
{
    asm volatile ("j _start");
    asm volatile ("j _start");
}

void __attribute__((noreturn)) main(void);

extern void __attribute__((naked)) _start(void)
{
    asm volatile ("la sp, ramend");
    main();
}

static volatile uint32_t* const REG_GPIO_OUT = (volatile uint32_t*)0x30000000;
static volatile uint32_t* const REG_UART_STATUS = (volatile uint32_t*)0x30001000;
static volatile uint32_t* const REG_UART_DATA = (volatile uint32_t*)0x30001004;
static volatile uint32_t* const REG_CONFIG_ID = (volatile uint32_t*)0x40000000;
static volatile uint32_t* const REG_CONFIG_CLOCK_HZ = (volatile uint32_t*)0x40000004;

#define INTR_PROLOGUE() \
    asm volatile ("addi sp, sp, -64"); \
    asm volatile ("sw ra, 0(sp)"); \
    asm volatile ("sw a0, 4(sp)"); \
    asm volatile ("sw a1, 8(sp)"); \
    asm volatile ("sw a2, 12(sp)"); \
    asm volatile ("sw a3, 16(sp)"); \
    asm volatile ("sw a4, 20(sp)"); \
    asm volatile ("sw a5, 24(sp)"); \
    asm volatile ("sw a6, 28(sp)"); \
    asm volatile ("sw a7, 32(sp)"); \
    asm volatile ("sw t0, 36(sp)"); \
    asm volatile ("sw t1, 40(sp)"); \
    asm volatile ("sw t2, 44(sp)"); \
    asm volatile ("sw t3, 48(sp)"); \
    asm volatile ("sw t4, 52(sp)"); \
    asm volatile ("sw t5, 56(sp)"); \
    asm volatile ("sw t6, 60(sp)")

#define INTR_EPILOGUE() \
    asm volatile ("lw t6, 60(sp)"); \
    asm volatile ("lw t5, 56(sp)"); \
    asm volatile ("lw t4, 52(sp)"); \
    asm volatile ("lw t3, 48(sp)"); \
    asm volatile ("lw t2, 44(sp)"); \
    asm volatile ("lw t1, 40(sp)"); \
    asm volatile ("lw t0, 36(sp)"); \
    asm volatile ("lw a7, 32(sp)"); \
    asm volatile ("lw a6, 28(sp)"); \
    asm volatile ("lw a5, 24(sp)"); \
    asm volatile ("lw a4, 20(sp)"); \
    asm volatile ("lw a3, 16(sp)"); \
    asm volatile ("lw a2, 12(sp)"); \
    asm volatile ("lw a1, 8(sp)"); \
    asm volatile ("lw a0, 4(sp)"); \
    asm volatile ("lw ra, 0(sp)"); \
    asm volatile ("addi sp, sp, 64"); \
    asm volatile ("mret")

#define UART_TX_BUF_SIZE 16
static volatile uint32_t uart_tx_write = 0;
static volatile uint32_t uart_tx_read = 0;
static volatile uint8_t uart_tx_buf[UART_TX_BUF_SIZE] = {};

void __attribute__((naked)) intr_handler(void) {
    INTR_PROLOGUE();
    if (uart_tx_read != uart_tx_write) {
        if (!((*REG_UART_STATUS) & 4)) {
            *REG_UART_DATA = uart_tx_buf[uart_tx_read];
            uart_tx_read = (uart_tx_read + 1) & (UART_TX_BUF_SIZE - 1);
            if (uart_tx_read == uart_tx_write)
                *REG_UART_STATUS = 0;
        }
    }
    INTR_EPILOGUE();
}

static uint64_t read_cycle(void)
{
    uint32_t l, h, hv;
    do {
        asm volatile ("rdcycleh %0" : "=r" (h));
        asm volatile ("rdcycle  %0" : "=r" (l));
        asm volatile ("rdcycleh %0" : "=r" (hv));
    } while(h != hv);
    return ((uint64_t)h << 32) | l;
}

static void uart_tx(uint8_t value) 
{
    uint32_t next = (uart_tx_write + 1) & (UART_TX_BUF_SIZE - 1);
    //*REG_GPIO_OUT = led_out | 1;
    while (uart_tx_read == next)
        ;
    //*REG_GPIO_OUT = led_out;
    uart_tx_buf[uart_tx_write] = value;
    uart_tx_write = next;
    *REG_UART_STATUS = 1;
}

static void uart_puts(const char* s)
{
    while(*s) {
        uart_tx((uint8_t)*(s++));
    }
}

static void wait_cycles(uint64_t cycles)
{
    uint64_t start = read_cycle();
    while(read_cycle() - start < cycles);
}

static inline void enable_interrupt(void)
{
    asm volatile("csrsi mstatus, 8");
}

static inline void enable_machine_external_interrupt(void)
{
    uint32_t mask;
	asm volatile("li %0, 0x800" : "=r" (mask));
	asm volatile("csrs mie, %0" : "=r" (mask));
}

static void init_csr(void)
{
    uint32_t intr_addr;
    asm volatile ("la %0, intr_handler" : "=r" (intr_addr));
    asm volatile ("csrw mtvec, %0" : "=r" (intr_addr));
    enable_interrupt();
    enable_machine_external_interrupt();
}

static inline void init_bss() {
    extern uint32_t __bss_start[];
    extern uint32_t __bss_end[];
    uint32_t *p = __bss_start;
    uint32_t *q = __bss_end;

    do {
        *(volatile uint32_t *)p = 0;
    } while (++p < q);
}

static inline int sum() {
    uint32_t *p = (uint32_t *)0x20010000;
    uint32_t *q = p;
    for (int i = 0; i < 0x8000; i++) {
        *q++ = i + 1;
    }
    uint64_t s = 0;
    q = p;
    for (int i = 0; i < 0x8000; i++) {
        s += *q++;
    }
    return (s == 536887296);
}

void __attribute__((noreturn)) main(void)
{
    init_bss();
    uint32_t led_out = 1;
    uint32_t clock_hz = *REG_CONFIG_CLOCK_HZ;
    *REG_UART_STATUS = 0;
    init_csr();
    uint32_t i = 0;
    while(1) {
        if (sum()) {
            uart_puts("Hello, RISC-V\r\n");
        } else {
            uart_puts("NG!!\r\n");
        }
        //uart_puts("A");
        *REG_GPIO_OUT = led_out;
        led_out = (led_out << 1) | ((led_out >> 7) & 1);
        wait_cycles(clock_hz >> 1);
    }
}