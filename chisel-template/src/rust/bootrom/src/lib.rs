#![no_std]

mod start;
mod mmio;
mod uart;
mod cycle;
mod gpio;
mod sdc;

fn main() {
    sdc::init_card();
    let mut led_out: u32 = 1;
    loop {
        //uart::puts(b"Hello, RISC-V\r\n");
        gpio::out(led_out);
        led_out = (led_out << 1) | ((led_out >> 7) & 1);
        cycle::wait(cycle::clock_hz() >> 1);
    }
}
