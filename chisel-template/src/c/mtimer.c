void main()
{
	asm volatile("li gp,0");
	asm volatile("lui t1,0x30002");
	asm volatile("li t0,100");
	asm volatile("sw x0,12(t1)");
	asm volatile("sw t0,8(t1)");

	asm volatile("1:");
	asm volatile("auipc t0,%pcrel_hi(intr_handler)");
	asm volatile("addi t0,t0,%pcrel_lo(1b)");
    asm volatile("csrw mtvec,t0");
    asm volatile("csrsi mstatus,8");
	asm volatile("li t0,0x80");
	asm volatile("csrs mie,t0");
	asm volatile("li t0,100");
	asm volatile("mainloop:");
	asm volatile("addi t0,t0,-1");
	asm volatile("bne t0,x0,mainloop");
	asm volatile("addi a0,gp,-1");
}

__attribute__((naked)) void intr_handler()
{
    asm volatile("addi sp,sp,-20");
    asm volatile("sw t0,0(sp)");
    asm volatile("sw t1,4(sp)");
    asm volatile("sw t2,8(sp)");
    asm volatile("sw a0,12(sp)");
    asm volatile("sw a1,16(sp)");

	asm volatile("lui t1,0x30002");

	asm volatile("mtread:");
	asm volatile("lw a1,4(t1)");
	asm volatile("lw t2,0(t1)");
	asm volatile("lw t0,4(t1)");
	asm volatile("bne a1,t0,mtread");

	asm volatile("addi a0,t2,100");
	asm volatile("sltu t2,a0,t2");
	asm volatile("add a1,a1,t2");

	asm volatile("li t0,-1");
	asm volatile("sw t0,8(t1)");
	asm volatile("sw a1,12(t1)");
	asm volatile("sw a0,8(t1)");

	asm volatile("sltu t0,gp,2");
	asm volatile("add gp,gp,t0");

    asm volatile("lw a1,16(sp)");
    asm volatile("lw a0,12(sp)");
    asm volatile("lw t2,8(sp)");
    asm volatile("lw t1,4(sp)");
    asm volatile("lw t0,0(sp)");
	asm volatile("addi sp,sp,20");

    asm volatile("mret");
}
