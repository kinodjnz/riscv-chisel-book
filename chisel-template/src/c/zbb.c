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
	asm volatile("test_5:");
	asm volatile("li     gp, 5");
	asm volatile("li     ra, 0x80000000");
	asm volatile(".word  0x60009713"); // clz a4, ra
	asm volatile("li     t2, 0");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_6:");
	asm volatile("li     gp, 6");
	asm volatile("li     ra, 0x005f3a49");
	asm volatile(".word  0x60009713"); // clz a4, ra
	asm volatile("li     t2, 9");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_7:");
	asm volatile("li     gp, 7");
	asm volatile("li     ra, 0");
	asm volatile(".word  0x60009713"); // clz a4, ra
	asm volatile("li     t2, 32");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_8:");
	asm volatile("li     gp, 8");
	asm volatile("li     ra, 1");
	asm volatile(".word  0x60109713"); // ctz a4, ra
	asm volatile("li     t2, 0");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_9:");
	asm volatile("li     gp, 9");
	asm volatile("li     ra, 0x5fe1a000");
	asm volatile(".word  0x60109713"); // ctz a4, ra
	asm volatile("li     t2, 13");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_10:");
	asm volatile("li     gp, 10");
	asm volatile("li     ra, 0");
	asm volatile(".word  0x60109713"); // ctz a4, ra
	asm volatile("li     t2, 32");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_11:");
	asm volatile("li     gp, 11");
	asm volatile("li     ra, 0x80000000");
	asm volatile("li     sp, 0x7fffffff");
	asm volatile(".word  0x0a20d733"); // minu a4, ra, sp
	asm volatile("li     t2, 0x7fffffff");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_12:");
	asm volatile("li     gp, 12");
	asm volatile("li     ra, 14");
	asm volatile("li     sp, 22");
	asm volatile(".word  0x0a20d733"); // minu a4, ra, sp
	asm volatile("li     t2, 14");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_13:");
	asm volatile("li     gp, 13");
	asm volatile("li     ra, -1");
	asm volatile("li     sp, -1");
	asm volatile(".word  0x0a20d733"); // minu a4, ra, sp
	asm volatile("li     t2, -1");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_14:");
	asm volatile("li     gp, 14");
	asm volatile("li     ra, 0x80000000");
	asm volatile("li     sp, 0x7fffffff");
	asm volatile(".word  0x0a20f733"); // maxu a4, ra, sp
	asm volatile("li     t2, 0x80000000");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_15:");
	asm volatile("li     gp, 15");
	asm volatile("li     ra, 14");
	asm volatile("li     sp, 22");
	asm volatile(".word  0x0a20f733"); // maxu a4, ra, sp
	asm volatile("li     t2, 22");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_16:");
	asm volatile("li     gp, 16");
	asm volatile("li     ra, -1");
	asm volatile("li     sp, -1");
	asm volatile(".word  0x0a20f733"); // maxu a4, ra, sp
	asm volatile("li     t2, -1");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_17:");
	asm volatile("li     gp, 17");
	asm volatile("li     ra, 0xff4508ab");
	asm volatile("li     sp, 0x56f00f0d");
	asm volatile(".word  0x4020f733"); // andn a4, ra, sp
	asm volatile("li     t2, 0xa90500a2");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_18:");
	asm volatile("li     gp, 18");
	asm volatile("li     ra, 0x0045f8ab");
	asm volatile("li     sp, 0x56f00f3d");
	asm volatile(".word  0x4020e733"); // orn a4, ra, sp
	asm volatile("li     t2, 0xa94ff8eb");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_19:");
	asm volatile("li     gp, 19");
	asm volatile("li     ra, 0xff4508ab");
	asm volatile("li     sp, 0x56f00f0d");
	asm volatile(".word  0x4020c733"); // xnor a4, ra, sp
	asm volatile("li     t2, 0x564af859");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_20:");
	asm volatile("li     gp, 20");
	asm volatile("li     ra, 0x0123fedc");
	asm volatile(".word  0x0800c733"); // zext.h a4, ra
	asm volatile("li     t2, 0xfedc");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_21:");
	asm volatile("li     gp, 21");
	asm volatile("li     ra, 0x0123fedc");
	asm volatile(".word  0x60409713"); // sext.b a4, ra
	asm volatile("li     t2, 0xffffffdc");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_22:");
	asm volatile("li     gp, 22");
	asm volatile("li     ra, 0x0123fedc");
	asm volatile(".word  0x60509713"); // sext.h a4, ra
	asm volatile("li     t2, 0xfffffedc");
	asm volatile("bne    a4, t2, fail");
	asm volatile("test_23:");
	asm volatile("li     gp, 23");
	asm volatile("li     ra, 0x0123fedc");
	asm volatile(".word  0x6980d713"); // rev8 a4, ra
	asm volatile("li     t2, 0xdcfe2301");
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