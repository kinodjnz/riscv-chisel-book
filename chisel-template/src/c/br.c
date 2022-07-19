void main()
{
	asm volatile("li a0,2");
	asm volatile("nop");
	asm volatile("nop");
	asm volatile("2:");
	asm volatile("li t2,0");
	asm volatile("li t0,0");
	asm volatile("li a4,-1");
	asm volatile("nop");
	asm volatile("beq t0,zero,1f");
	asm volatile("rdcycle a6");
	asm volatile("bne a4,a6,fail");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("j fail");
	asm volatile("1:");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("addi t2,t2,1");
	asm volatile("li a0,1");
    asm volatile("ret");
    asm volatile("nop");
	asm volatile("fail:");
	asm volatile("li a0,5");
}
