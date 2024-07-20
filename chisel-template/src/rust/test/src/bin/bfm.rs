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
            "   li      sp, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   li      a6, 8",
            "   bfm     ra, sp, a6, 4",
            "   li      t2, 0x9abcd6fa",
            "   bne     ra, t2, 99f",
            "3:",
            "   li      gp, 3",
            "   li      sp, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   li      a6, 8",
            "   bfm     ra, sp, a6, 0",
            "   li      t2, 0x123456fa",
            "   bne     ra, t2, 99f",
            "4:",
            "   li      gp, 4",
            "   li      sp, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   li      a6, 0",
            "   bfm     ra, sp, a6, 8",
            "   li      t2, 0x9abcde78",
            "   bne     ra, t2, 99f",
            "   beq     ra, t2, 0f",
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
        );
        0
    }
}
