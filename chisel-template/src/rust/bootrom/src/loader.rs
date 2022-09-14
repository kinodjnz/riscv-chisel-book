use super::sdc;
use super::uart;

fn read_unaligned<T>(addr: *const u32, byte_offset: usize) -> T {
    unsafe {
        ((addr as *mut u8).add(byte_offset) as *mut T).read_unaligned()
    }
}

fn read(addr: *const u32, offset: usize) -> u32 {
    unsafe {
        addr.add(offset).read()
    }
}

pub fn load_kernel() -> u32 {
    let buf: *mut u32 = 0x2000_1000 as *mut u32;
    let s = sdc::read_sector(0, buf);
    if s != 0 {
        uart::print(s);
        uart::puts(b" ");
        return 1;
    }
    let boot_sector: u32 = read_unaligned(buf, 0x1c6);
    uart::print(boot_sector);
    uart::puts(b"\r\n");
    let s = sdc::read_sector(boot_sector, buf);
    if s != 0 {
        uart::print(s);
        uart::puts(b" ");
        return 2;
    }
    for i in 0..128 {
        uart::print(read(buf, i));
        uart::puts(b"\r\n");
    }
    0
}
