#![no_std]

use core::arch::asm;

use core::panic::PanicInfo;
#[panic_handler]
#[no_mangle]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[no_mangle]
pub extern "C" fn main() -> i32 {
    unsafe {
        asm!(
            "   j       2f",
            "2:",
            "   li      gp, 2",
            "   la      ra, 999f",
            "   lw      a2, 0(ra)",
            "   lw      a3, 4(ra)",
            "   lw      a4, 0(ra)",
            "   lw      a5, 4(ra)",
            "   li      t2, 0x00ff00ff",
            "   bne     a2, t2, 99f",
            "   li      t2, 0xf00ff00f",
            "   bne     a3, t2, 99f",
            "   beq     a3, t2, 0f",
            "99:",
            "   fence",
            "98:",
            "   beqz    gp, 98b",
            "   slli    gp, gp, 1",
            "   ori     gp, gp, 1",
            "   li      a7, 93",
            "   mv      a0, gp",
            "   ecall",
            "   nop",
            "   nop",
            "   j       99b",
            "0:",
            "   fence",
            "   li      gp, 1",
            "   li      a7, 93",
            "   li      a0, 0",
            "   ecall",
            "   nop",
            "   nop",
            "   j       0b",
            "   .align  4",
            "999:",
            "   .4byte  0x00ff00ff",
            "   .4byte  0xf00ff00f",
        );
        0
    }
}
