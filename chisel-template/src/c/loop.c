void main()
{
	asm volatile("li a1,32");
	asm volatile("1:");
	asm volatile("addi a1,a1,-1");
	asm volatile("bne a1,zero,1b");
	asm volatile("nop");
	asm volatile("li a0,1");
}
