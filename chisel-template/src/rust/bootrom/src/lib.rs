#![no_std]

mod cycle;
mod loader;
mod mmio;
mod sdc;
mod start;
mod uart;

use sdc::Sdc;

fn main() -> ! {
    let result = Sdc::init_card();
    match result {
        Err(e) => {
            uart::puts(b"sd init failed: ");
            uart::print(e);
            uart::puts(b"\r\n");
        }
        Ok(sdc) => {
            let s = loader::load_kernel(sdc);
            uart::puts(b"load failed: ");
            uart::print(s);
            uart::puts(b"\r\n");
        }
    }
    loop {}
}
