#![no_std]

mod cycle;
mod loader;
mod mmio;
mod sdc;
mod start;
mod uart;

fn main() -> ! {
    let s = sdc::init_card();
    if s != 0 {
        uart::puts(b"sd init failed: ");
        uart::print(s);
        uart::puts(b"\r\n");
    }
    let s = loader::load_kernel();
    uart::puts(b"load failed: ");
    uart::print(s);
    uart::puts(b"\r\n");
    loop {}
}
