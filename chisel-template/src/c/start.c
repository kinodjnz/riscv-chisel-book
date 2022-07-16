extern int main();

__attribute__((naked)) void _start()
{
    asm volatile ("lui sp, 0x20002");
    int res = main();
    asm volatile("mv gp, a0");
    asm volatile("li a7, 93");
    asm volatile("nop");
    asm volatile("nop");
    asm volatile("nop");
    asm volatile("nop");
    asm volatile("ecall");
}
