#include <stdio.h>

int main()
{
	asm volatile("j      test_2");
	asm volatile("test_2:");
	asm volatile("li     gp, 2");
	asm volatile("li     a2, 1");
	asm volatile("li     a1, 0x12345678");
	asm volatile("li     a3, 0xfedcba98");
	asm volatile(".word  0x6ec5d533"); // cmov  a0, a2, a1, a3 // 01101 11 01100 01011 101 01010 0110011
	asm volatile("li     t2, 0x12345678");
	asm volatile("bne    a0, t2, fail");
	asm volatile("test_3:");
	asm volatile("li     gp, 3");
	asm volatile("li     a2, 0");
	asm volatile("li     a1, 0x12345678");
	asm volatile("li     a3, 0xfedcba98");
	asm volatile(".word  0x6ec5d533"); // cmov  a0, a2, a1, a3 // 01101 11 01100 01011 101 01010 0110011
	asm volatile("li     t2, 0xfedcba98");
	asm volatile("bne    a0, t2, fail");
	asm volatile("beq    a0, t2, pass");
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