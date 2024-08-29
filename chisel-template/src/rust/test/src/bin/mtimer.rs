#![no_std]

use core::arch::asm;
use core::arch::global_asm;

use core::panic::PanicInfo;
#[panic_handler]
#[no_mangle]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

global_asm!(r#"
.global intr_handler
intr_handler:
    addi sp,sp,-20
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw a0,12(sp)
    sw a1,16(sp)

	lui t1,0x30002

1:
	lw a1,4(t1)
	lw t2,0(t1)
	lw t0,4(t1)
	bne a1,t0,1b

	addi a0,t2,100
	sltu t2,a0,t2
	add a1,a1,t2

	li t0,-1
	sw t0,8(t1)
	sw a1,12(t1)
	sw a0,8(t1)

	sltu t0,gp,2
	add gp,gp,t0

    lw a1,16(sp)
    lw a0,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
	addi sp,sp,20

    mret
"#);

#[no_mangle]
pub extern "C" fn main() -> i32 {
    let mut ret: i32;
    unsafe {
        asm!(r#"
	        li gp,0
	        lui t1,0x30002
	        li t0,100
	        sw x0,12(t1)
	        sw t0,8(t1)

	    1:
	        auipc t0,%pcrel_hi(intr_handler)
	        addi t0,t0,%pcrel_lo(1b)
            csrw mtvec,t0
            csrsi mstatus,8
	        li t0,0x80
	        csrs mie,t0
	        li t0,100
	    2:
	        addi t0,t0,-1
	        bne t0,x0,2b
            csrsi mstatus,0
	        addi {ret},gp,-1
        "#, ret = out(reg) ret);
        ret
    }
}
