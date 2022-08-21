void main()
{
	asm volatile("addi sp,sp,-4");
	asm volatile("sw ra,0(sp)");

	asm volatile("li gp,3");
	asm volatile("lui s0,0x20000");
	asm volatile("lui s1,0x20001");
	asm volatile("lui s2,0x20002");

	asm volatile("la t2,func3");
	asm volatile("lw t0,0(t2)");
	asm volatile("sw t0,0(s0)");
	asm volatile("lw t0,4(t2)");
	asm volatile("sw t0,4(s0)");

	asm volatile("la t2,func1");
	asm volatile("lw t0,0(t2)");
	asm volatile("sw t0,0(s1)");
	asm volatile("lw t0,4(t2)");
	asm volatile("sw t0,4(s1)");
	asm volatile("fence.i");
	asm volatile("jalr s1");

	asm volatile("la t2,func2");
	asm volatile("lw t0,0(t2)");
	asm volatile("sw t0,0(s1)");
	asm volatile("lw t0,4(t2)");
	asm volatile("sw t0,4(s1)");
	asm volatile("fence.i");
	asm volatile("jalr s1");

	asm volatile("la t2,func4");
	asm volatile("lw t0,0(t2)");
	asm volatile("sw t0,0(s2)");
	asm volatile("lw t0,4(t2)");
	asm volatile("sw t0,4(s2)");

	asm volatile("fence.i");
	asm volatile("jalr s0");

	asm volatile("mv a0,gp");

	asm volatile("lw ra,0(sp)");
	asm volatile("addi sp,sp,4");
}

void func1()
{
    asm volatile("li gp,4");
}

void func2()
{
    asm volatile("addi gp,gp,-1");
}

void func3()
{
    asm volatile("addi gp,gp,-2");
}

void func4()
{
    asm volatile("li gp,12");
}
