extern int main();

__attribute__((noreturn)) void _start()
{
    int res = main();
    asm volatile("mv gp, a0");
    asm volatile("nop");
    asm volatile("nop");
    asm volatile("nop");
    asm volatile("nop");
    asm volatile("ecall");
}
