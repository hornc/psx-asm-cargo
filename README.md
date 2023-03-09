# PSX assembler toolchain using Cargo-psx

This is an experiment in setting up an assembler toolchain for the original Playstation, using modern tools.

Using:

Cargo (Rust's build system) via [cargo-psx](https://github.com/ayrtonm/psx-sdk-rs) + LLVM with Rust's [`asm_experimental_arch`](https://doc.rust-lang.org/beta/unstable-book/language-features/asm-experimental-arch.html)
to write pure MIPS32el assembler for the PSX's R3000 chip.

Runner:
* [Mednafen](https://mednafen.github.io/), as used by [psx-sdk-rs](https://github.com/ayrtonm/psx-sdk-rs)


Inspirations:
* https://github.com/PeterLemon/PSX  (I had the idea to do revist PSX asm, then went looking for prior and recent art, this is what I found)
* [psx-sdk-rs](https://github.com/ayrtonm/psx-sdk-rs), although I'm bypassing all the helpful Rust by using `asm!` and `global-asm!`
* Hitmen's Greentro!!!


## Toolchain setup

(Linux x86 host specific)

Rust

<!--
Add the MIPS Sony PSX as a cross-compile target (<--- not necessary, `cargo-psx` seems to handle this itself?)

    rustup target add mipsel-sony-psx

Check installed targets with

    rustup target list
-->

Add Rust nightly to access the unstable `asm-experimental-arch` features:  (`cargo-psx` may handle this for us...)

    rustup component add rust-src --toolchain nightly-x86_64-unknown-linux-gnu

Install [`cargo-psx`](https://github.com/ayrtonm/psx-sdk-rs) following the instructions in the README. This tool generates PSX-EXE format binaries, instead of ELF.
(See https://doc.rust-lang.org/nightly/rustc/platform-support/mipsel-sony-psx.html)

*Optional at this stage, the NOP example doesn't need it:*
Install [Mednafen](https://mednafen.github.io/), a multi-system emulator.
We'll be using its PSX emulation for testing, although this build output should work on other emulators and original PSX hardware (I have not yet tested).
`psx-sdk-rs`' Mednafen integration is very smooth, and I am just using that for the moment.

## New project setup ([NOP](examples/nop))

This is how to compile a single MIPS `NOP` as a minimal test of the toolchain.

    cargo new nop
    cd nop

To set a specific project to use the `asm-experimental-features`,

    rustup override set nightly

<!-- 
Add a .cargo/config.toml file:

```
[build]
target = "mipsel-sony-psx"

[target.mipsel-sony-psx]
runner = "mednafen"
```
-->

Add the `psx` dependency to Cargo.toml

```
[dependencies]
psx = "0.1.6"
```

The main reason for this appears to be to allow `cargo-psx` to find the `psexe.ld` linker script to produce PSX executables from the compiled output.


Now, lets make a minimal Rust `main.rs` that simply includes a MIPS assembly source file:

```
#![feature(asm_experimental_arch)]
#![no_std]
#![no_main]

use core::arch::global_asm;
use core::panic::PanicInfo;

#[panic_handler]
fn on_panic(_info: &PanicInfo) -> ! {
    loop {};
}

global_asm!(include_str!("main.s"));
```

This adds just enough to allow the use of the `global_asm!` macro, and sets up a panic handler, which is the minimum Rust we need to build something that works.

Continuing the minimal theme, let's create a minimal assembler file `src/main.s`:

```
// Minimal MIPS assembler to test compilation.
.global __start
__start:
    nop
```

Now we can test everything is set up correctly by building with:

    $ cargo psx build

Output:
```
   Compiling compiler_builtins v0.1.87
   Compiling core v0.0.0 (/home/charles/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/core)
   Compiling psx v0.1.6
warning: MIPS-I support is experimental
   Compiling rustc-std-workspace-core v1.99.0 (/home/charles/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/rustc-std-workspace-core)
warning: MIPS-I support is experimental
warning: MIPS-I support is experimental
   Compiling alloc v0.0.0 (/home/charles/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/alloc)
warning: MIPS-I support is experimental
warning: MIPS-I support is experimental
   Compiling nop v0.1.0 (/home/charles/code/MIPS/psx-asm-cargo/examples/nop)
warning: MIPS-I support is experimental
    Finished release [optimized] target(s) in 6.53s
```

There should now be a 4096 byte PSX executable at `target/mipsel-sony-psx/release/nop.exe`

    $ stat target/mipsel-sony-psx/release/nop.exe
      File: target/mipsel-sony-psx/release/nop.exe
      Size: 4096      	Blocks: 8          IO Block: 4096   regular file
    ...

And confim the Magic number / string of the PSX executable format:

    $ head -c8 target/mipsel-sony-psx/release/nop.exe
    PS-X EXE


## Examples

### [nop](examples/nop)
A super minimal `NOP` example (described above) to test the toolchain is set up correctly and works with `cargo-psx`.

### [yellow-square](examples/yellow-square)

Inspired by Lameguy64's graphics tutorial (in C) http://lameguy64.net/tutorials/pstutorials/chapter1/2-graphics.html

Draw a single graphics primative (yellow square) on a blue background.



