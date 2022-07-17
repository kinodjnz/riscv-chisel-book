#include <stdint.h>

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

static volatile uint32_t uart_tx_waiting = 0;
static volatile uint8_t uart_tx_data = 0;

void __attribute__((naked)) intr_handler(void) {
    INTR_PROLOGUE();
    if (uart_tx_waiting) {
        if (!((*REG_UART_STATUS) & 4)) {
            *REG_UART_DATA = uart_tx_data;
            uart_tx_waiting = 0;
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
    while (uart_tx_waiting);
    uart_tx_data = value;
    uart_tx_waiting = 1;
    *REG_UART_STATUS = 1;
}

// static uint8_t uart_rx() 
// {
//     while((*REG_UART_STATUS & 0b10) == 0);
//     return *REG_UART_DATA;
// }

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

void __attribute__((noreturn)) main(void)
{
    uint32_t led_out = 1;
    uint32_t clock_hz = *REG_CONFIG_CLOCK_HZ;
    init_csr();
    while(1) {
        uart_puts("Hello, RISC-V\r\n");
        *REG_GPIO_OUT = led_out;
        led_out = (led_out << 1) | ((led_out >> 7) & 1);
        wait_cycles(clock_hz >> 1);
    }
}