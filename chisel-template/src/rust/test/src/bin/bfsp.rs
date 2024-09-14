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
            "   li      sp, 0x9abcdefa",
            "   li      a6, 0x108",
            "   bfsp    a2, sp, a6",
            "   li      t2, 0xfffffffe",
            "   bne     a2, t2, 99f",
            "3:",
            "   li      gp, 3",
            "   li      sp, 0x9abcd6fa",
            "   li      a6, 0x108",
            "   bfsp    a2, sp, a6",
            "   li      t2, 0x00000006",
            "   bne     a2, t2, 99f",
            "4:",
            "   li      gp, 4",
            "   li      sp, 0x9abcdefa",
            "   li      a6, 8",
            "   bfsp    a2, sp, a6",
            "   li      t2, 0xff9abcde",
            "   bne     a2, t2, 99f",
            "5:",
            "   li      gp, 5",
            "   li      sp, 0x1abcdefa",
            "   li      a6, 8",
            "   bfsp    a2, sp, a6",
            "   li      t2, 0x001abcde",
            "   bne     a2, t2, 99f",
            "6:",
            "   li      gp, 6",
            "   li      sp, 0x9abcdef2",
            "   li      a6, 0x200",
            "   bfsp    a2, sp, a6",
            "   li      t2, 0xfffffff2",
            "   bne     a2, t2, 99f",
            "7:",
            "   li      gp, 7",
            "   li      sp, 0x9abcde72",
            "   li      a6, 0x200",
            "   bfsp    a2, sp, a6",
            "   li      t2, 0x00000072",
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
