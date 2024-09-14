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
            "   bfxi    a2, sp, ra, 8, 4",
            "   li      t2, 0x9abcdef6",
            "   bne     a2, t2, 99f",
            "3:",
            "   li      gp, 3",
            "   li      sp, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   bfxi    a2, sp, ra, 4, 0",
            "   li      t2, 0x91234567",
            "   bne     a2, t2, 99f",
            "4:",
            "   li      gp, 4",
            "   li      sp, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   bfxi    a2, sp, ra, 24, 8",
            "   li      t2, 0x9abcde12",
            "   bne     a2, t2, 99f",
            "5:",
            "   li      gp, 5",
            "   li      sp, 0x12345678",
            "   li      ra, 0x9a8cdeda",
            "   bfxi    a2, sp, ra, 16, 6",
            "   li      t2, 0x9a8cdef4",
            "   bne     a2, t2, 99f",
            "6:",
            "   li      gp, 6",
            "   li      sp, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   bfxi    a2, sp, ra, 12, 3",
            "   li      t2, 0x9abcdefd",
            "   bne     a2, t2, 99f",
            "   beq     a2, t2, 0f",
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
