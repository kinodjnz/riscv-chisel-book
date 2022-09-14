#![no_std]

mod start;
mod mmio;
mod uart;
mod cycle;
mod gpio;
mod sdc;
mod loader;

fn main() {
    let s = sdc::init_card();
    uart::print(s);
    uart::puts(b" sd\r\n");
    let s = loader::load_kernel();
    uart::print(s);
    uart::puts(b" ld\r\n");
    let mut led_out: u32 = 1;
    loop {
        //uart::puts(b"Hello, RISC-V\r\n");
        gpio::out(led_out);
        led_out = (led_out << 1) | ((led_out >> 7) & 1);
        cycle::wait(cycle::clock_hz() >> 1);
    }
}
