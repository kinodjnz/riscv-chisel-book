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
	asm volatile("test_8:");
	asm volatile("li     gp, 8");
	asm volatile("li     a2, 0x0002fe7d");
	asm volatile("li     a1, 0xaaaaaaab");
	asm volatile(".2byte 0x9e4d"); // c.mul  a2, a1
	asm volatile("li     t2, 0xff7f");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_9:");
	asm volatile("li     gp, 9");
	asm volatile("li     a2, 0x12349abc");
	asm volatile(".2byte 0x9e61"); // c.zext.b a2
	asm volatile("li     t2, 0xbc");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_10:");
	asm volatile("li     gp, 10");
	asm volatile("li     a2, 0x12349abc");
	asm volatile(".2byte 0x9e65"); // c.sext.b a2
	asm volatile("li     t2, 0xffffffbc");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_11:");
	asm volatile("li     gp, 11");
	asm volatile("li     a2, 0x12349abc");
	asm volatile(".2byte 0x9e69"); // c.zext.h a2
	asm volatile("li     t2, 0x9abc");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_12:");
	asm volatile("li     gp, 12");
	asm volatile("li     a2, 0x12349abc");
	asm volatile(".2byte 0x9e6d"); // c.sext.h a2
	asm volatile("li     t2, 0xffff9abc");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_13:");
	asm volatile("li     gp, 13");
	asm volatile("li     a2, 0x12349abc");
	asm volatile(".2byte 0x9e75"); // c.not a2
	asm volatile("li     t2, 0xedcb6543");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_14:");
	asm volatile("li     gp, 14");
	asm volatile("li     a2, 0x12349abc");
	asm volatile(".2byte 0x9e79"); // c.neg a2
	asm volatile("li     t2, 0xedcb6544");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_15:");
	asm volatile("li     gp, 15");
	asm volatile("li     a2, 0");
	asm volatile("li     a0, 0x98765432");
	asm volatile("li     a1, 0x98765432");
	asm volatile(".2byte 0x814c"); // c.beq a0, a1, 1f
	asm volatile("j      2f");
	asm volatile("1:");
	asm volatile("j      3f");
	asm volatile("2:");
	asm volatile("j      fail");
	asm volatile("3:");
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_16:");
	asm volatile("li     gp, 16");
	asm volatile("li     a2, 0");
	asm volatile("li     a0, 0");
	asm volatile("li     a1, 1");
	asm volatile(".2byte 0x814c"); // c.beq a0, a1, 1f
	asm volatile("j      2f");
	asm volatile("1:");
	asm volatile("j      fail");
	asm volatile("2:");
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_17:");
	asm volatile("li     gp, 17");
	asm volatile("li     a2, 0");
	asm volatile("li     a0, 0");
	asm volatile("li     a1, 1");
	asm volatile(".2byte 0xa14c"); // c.bne a0, a1, 1f
	asm volatile("j      2f");
	asm volatile("1:");
	asm volatile("j      3f");
	asm volatile("2:");
	asm volatile("j      fail");
	asm volatile("3:");
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_18:");
	asm volatile("li     gp, 18");
	asm volatile("li     a2, 0");
	asm volatile("li     a0, 0x98765432");
	asm volatile("li     a1, 0x98765432");
	asm volatile(".2byte 0xa14c"); // c.beq a0, a1, 1f
	asm volatile("j      2f");
	asm volatile("1:");
	asm volatile("j      fail");
	asm volatile("2:");
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_19:");
	asm volatile("li     gp, 19");
	asm volatile("li     a1, 96");
	asm volatile(".2byte 0xb1b2"); // c.addi2w a2, a1, -32
	asm volatile("li     t2, 64");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_20:");
	asm volatile("li     gp, 20");
	asm volatile("li     a0, 90");
	asm volatile("li     a1, 42");
	asm volatile(".2byte 0xe992"); // c.add2 a2, a1, a0
	asm volatile("li     t2, 132");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_21:");
	asm volatile("li     gp, 21");
	asm volatile("li     a1, 0");
	asm volatile(".2byte 0xe1b2"); // c.seqz a2, a1
	asm volatile("li     t2, 1");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_22:");
	asm volatile("li     gp, 22");
	asm volatile("li     a1, 1");
	asm volatile(".2byte 0xe1b2"); // c.seqz a2, a1
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_23:");
	asm volatile("li     gp, 23");
	asm volatile("li     a1, 0");
	asm volatile(".2byte 0xf1b2"); // c.snez a2, a1
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_24:");
	asm volatile("li     gp, 24");
	asm volatile("li     a1, 1");
	asm volatile(".2byte 0xf1b2"); // c.snez a2, a1
	asm volatile("li     t2, 1");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_25:");
	asm volatile("li     gp, 25");
	asm volatile("li     a1, 11");
	asm volatile(".2byte 0xf9b2"); // c.addi2b a2, a1, -2
	asm volatile("li     t2, 9");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_26:");
	asm volatile("li     gp, 26");
	asm volatile("li     a1, -5");
	asm volatile("li     a0, 11");
	asm volatile(".2byte 0xe9d2"); // c.slt a2, a1, a0
	asm volatile("li     t2, 1");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_27:");
	asm volatile("li     gp, 27");
	asm volatile("li     a1, -7");
	asm volatile("li     a0, -7");
	asm volatile(".2byte 0xe9d2"); // c.slt a2, a1, a0
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_28:");
	asm volatile("li     gp, 28");
	asm volatile("li     a1, 11");
	asm volatile("li     a0, -5");
	asm volatile(".2byte 0xe9d2"); // c.slt a2, a1, a0
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_29:");
	asm volatile("li     gp, 29");
	asm volatile("li     a1, 0x98765432");
	asm volatile("li     a0, 11");
	asm volatile(".2byte 0xe9f2"); // c.sltu a2, a1, a0
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_30:");
	asm volatile("li     gp, 30");
	asm volatile("li     a1, 0x98765432");
	asm volatile("li     a0, 0x98765432");
	asm volatile(".2byte 0xe9f2"); // c.sltu a2, a1, a0
	asm volatile("li     t2, 0");
	asm volatile("bne    a2, t2, fail");
	asm volatile("test_31:");
	asm volatile("li     gp, 31");
	asm volatile("li     a1, 11");
	asm volatile("li     a0, 0x98765432");
	asm volatile(".2byte 0xe9f2"); // c.sltu a2, a1, a0
	asm volatile("li     t2, 1");
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