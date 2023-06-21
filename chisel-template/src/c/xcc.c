#include <stdio.h>

int main()
{
	asm volatile("j      test_2");
	asm volatile(".align 4");
	asm volatile("data:");
	asm volatile(".2byte	0x3210");
	asm volatile(".2byte	0x7654");
	asm volatile(".2byte	0xba98");
	asm volatile(".2byte	0xfedc");
	asm volatile(".2byte	0x3210");
	asm volatile(".2byte	0x7654");
	asm volatile(".2byte	0xba98");
	asm volatile(".2byte	0xfedc");
	asm volatile("test_2:");
	asm volatile("lla    a1, data");
	asm volatile("li     gp, 2");
	asm volatile(".2byte 0x31c8"); // c.lb  a0, 5(a1)
	asm volatile("addi   a0, a0, 1");
	asm volatile(".2byte 0x71ca"); // c.sb  a0, 5(a1)
	asm volatile(".2byte 0x31d0"); // c.lb  a2, 5(a1)
	asm volatile("li     t2, 0xffffffbb");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_3:");
	asm volatile("lla    a1, data");
	asm volatile("li     gp, 3");
	asm volatile(".2byte 0x61e8"); // c.lbu a0, 6(a1)
	asm volatile("addi   a0, a0, 1");
	asm volatile(".2byte 0x61ea"); // c.sb  a0, 6(a1)
	asm volatile(".2byte 0x61f0"); // c.lbu a2, 6(a1)
	asm volatile("li     t2, 0xdd");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_4:");
	asm volatile("lla    a1, data");
	asm volatile("li     gp, 4");
	asm volatile(".2byte 0x25ca"); // c.lh  a0, 12(a1)
	asm volatile("addi   a0, a0, 1");
	asm volatile(".2byte 0x35ca"); // c.sh  a0, 12(a1)
	asm volatile(".2byte 0x25d2"); // c.lh  a2, 12(a1)
	asm volatile("li     t2, 0xffffba99");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_5:");
	asm volatile("lla    a1, data");
	asm volatile("li     gp, 5");
	asm volatile(".2byte 0x2dea"); // c.lhu a0, 14(a1)
	asm volatile("addi   a0, a0, 1");
	asm volatile(".2byte 0x35ea"); // c.sh  a0, 14(a1)
	asm volatile(".2byte 0x2df2"); // c.lhu a2, 14(a1)
	asm volatile("li     t2, 0xfedd");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_6:");
	asm volatile("lla    a1, data");
	asm volatile("li     gp, 6");
	asm volatile(".2byte 0x3982"); // c.sw0  0(a1)
	asm volatile("lw     a2, 0(a1)");
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_7:");
	asm volatile("lla    a1, data");
	asm volatile("li     gp, 7");
	asm volatile(".2byte 0x3d96"); // c.sb0  9(a1)
	asm volatile(".2byte 0x3dae"); // c.sh0  10(a1)
	asm volatile("lw     a2, 8(a1)");
	asm volatile("li     t2, 0x10");
	asm volatile("bne    a2, t2, fail");
	asm volatile("beq    a2, t2, pass");
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