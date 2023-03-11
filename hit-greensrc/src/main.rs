#![feature(asm_experimental_arch)]
#![no_std]
#![no_main]

use core::arch::global_asm;
use core::panic::PanicInfo;

#[panic_handler]
fn on_panic(_info: &PanicInfo) -> ! {
    loop {};
}

global_asm!(include_str!("../intro.asm"));
