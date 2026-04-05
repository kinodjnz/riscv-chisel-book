#![no_std]

use core::arch::naked_asm;

use core::panic::PanicInfo;
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
#[unsafe(naked)]
pub unsafe extern "C" fn main() -> ! {
    naked_asm!(r#"
            j       2f
        2:
            li      gp, 2
            li      a2, 6
            li      sp, 0
            bnei    sp, -1, 101f
            j       102f
        101:
            j       103f
        102:
            j       99f
        103:
            li      t2, 6
            bne     a2, t2, 99f
        3:
            li      gp, 3
            li      a2, 8
            li      sp, 0x20000001
            bnei    sp, 1, 101f
            j       102f
        101:
            j       103f
        102:
            j       99f
        103:
            li      t2, 8
            bne     a2, t2, 99f
        4:
            li      gp, 4
            li      a2, 1
            li      sp, 127
            bnei    sp, 127, 101f
            j       102f
        101:
            j       99f
        102:
            li      t2, 1
            bne     a2, t2, 99f
        5:
            li      gp, 5
            li      a2, 9
            li      sp, -1
            bnei    sp, -1, 101f
            j       102f
        101:
            j       99f
        102:
            li      t2, 9
            bne     a2, t2, 99f
            beq     a2, t2, 0f
        99:
            fence
        98:
            beqz    gp, 98b
            slli    gp, gp, 1
            ori     gp, gp, 1
            li      a7, 93
            mv      a0, gp
            ecall
            nop
            nop
            j       99b
        0:
            fence
            li      gp, 1
            li      a7, 93
            li      a0, 0
            ecall
            nop
            nop
            j       0b
    "#);
}
