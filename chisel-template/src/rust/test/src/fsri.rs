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
            "   li      a4, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   fsri    a2, a4, ra, 8",
            "   li      t2, 0xfa123456",
            "   bne     a2, t2, 99f",
            "3:",
            "   li      gp, 3",
            "   li      a4, 0x87654321",
            "   li      ra, 0xafedcba9",
            "   fsri    a2, a4, ra, 31",
            "   li      t2, 0x5fdb9753",
            "   bne     a2, t2, 99f",
            "4:",
            "   li      gp, 4",
            "   li      a4, 0x12345678",
            "   li      ra, 0x9abcdefa",
            "   fsri    a2, a4, ra, 0",
            "   li      t2, 0x12345678",
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
