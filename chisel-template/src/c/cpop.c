#include <stdio.h>

int main()
{
	asm volatile("j      test_2");
	asm volatile("test_2:");
	asm volatile("li     gp, 2");
	asm volatile("li     ra, 0");
	asm volatile(".word  0x60209713"); // cpop a4, ra
	asm volatile("li     t2, 0");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_3:");
	asm volatile("li     gp, 3");
	asm volatile("li     ra, 0x500f0aa0");
	asm volatile(".word  0x60209713"); // cpop a4, ra
	asm volatile("li     t2, 10");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_4:");
	asm volatile("li     gp, 4");
	asm volatile("li     ra, 0xffffffff");
	asm volatile(".word  0x60209713"); // cpop a4, ra
	asm volatile("li     t2, 32");
	asm volatile("bne    a4, t2, fail");
	asm volatile("beq    a4, t2, pass");
	asm volatile("fail:");
	asm volatile("fence");
	asm volatile("1:");
	asm volatile("beqz   gp, 1b");
	asm volatile("slli   gp, gp, 1");
	asm volatile("ori    gp, gp, 1");
	asm volatile("li     a7, 93");
	asm volatile("mv     a0, gp");
	asm volatile("ecall");
	asm volatile("pass:");
	asm volatile("fence");
	asm volatile("li     gp, 1");
	asm volatile("li     a7, 93");
	asm volatile("li     a0, 0");
	asm volatile("ecall");
	asm volatile("unimp");

	return 0;
}