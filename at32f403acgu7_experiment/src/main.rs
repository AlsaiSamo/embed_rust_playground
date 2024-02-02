#![no_std]
#![no_main]
#![feature(lang_items)]

use core::panic::PanicInfo;

#[no_mangle]
#[panic_handler]
fn panic(_panic: &PanicInfo<'_>) -> ! {
    loop {}
}

#[no_mangle]
#[lang = "eh_personality"]
extern "C" fn eh_personality() {}

#[no_mangle]
pub unsafe extern "C" fn Reset() -> ! {
    let _x = 42;
    loop {}
}

#[link_section = ".vector_table.reset_vector"]
#[no_mangle]
pub static RESET_VECTOR: unsafe extern "C" fn() -> ! = Reset;
