# NOP 2

This example tries to build the NOP code without using `cargo-psx`.

There are _no_ dependencies listed in Cargo.toml


    rustup override set nightly

is required to set flags to enable the `build-std` options:

    cargo build -Zbuild-std=core,alloc --target mipsel-sony-psx 


(command taken from https://doc.rust-lang.org/nightly/rustc/platform-support/mipsel-sony-psx.html )

Which generates an ELF file at `target/mipsel-sony-psx/debug/nop.exe`

    $ stat target/mipsel-sony-psx/debug/nop.exe
      File: target/mipsel-sony-psx/debug/nop.exe
      Size: 6996      	Blocks: 16         IO Block: 4096   regular file

This is _not_ a PSX EXE:

    $head -c32  target/mipsel-sony-psx/debug/nop.exe | xxd
    00000000: 7f45 4c46 0101 0100 0100 0000 0000 0000  .ELF............
    00000010: 0200 0800 0100 0000 5001 0200 3400 0000  ........P...4...

We can move the `cargo build` args into a `.cargo/config.toml` to produce the same result:

```
[build]
target = "mipsel-sony-psx"

[unstable]
build-std = ["core"]
```

Which can now be built with

    cargo build

To generate the same ELF as above.

To generate the PSX EXE, we need a linker script, like [`psexe.ld`](https://github.com/ayrtonm/psx-sdk-rs/blob/master/psx/psexe.ld) from [`psx-sdk-rs`](https://github.com/ayrtonm/psx-sdk-rs)

It needs to be on our PATH, or sitting in the project directory and we can pass the appropriate `RUSTFLAGS` using `config.toml`:

```
[build]
target = "mipsel-sony-psx"
rustflags = ["-Clink-arg=-Tpsexe.ld", "-Clink-arg=--oformat=binary"]

[unstable]
build-std = ["core"]
```

The easiest way to make `psexe.ld` available and have it in the correct place is to install `cargo-psx` and include `psx` as a dependency, which is what the first NOP example uses.

To get this example to work we can just drop the `psexe.ld` file in the project directory by fetching it from Github:

    wget https://raw.githubusercontent.com/ayrtonm/psx-sdk-rs/master/psx/psexe.ld

Now, with `psexe.ld` in place, we can run our MIPS NOP in Mednafen with

    cargo run

This demonstrates that for assembly only coding for the PSX, we are only using `cargo-psx` for its ability to generate PSX executables, which comes from its `psexe.ld` script.

Getting the PSX to _do_ anything will be more complex, but this is a start.


### Stripping everything back and using `clang` to cross compile our .s directly:

We can use `clang` (needs to be installed separately) to compile and assemble our MIPS assembly source to an object file `main.o`:

    clang --target=mipsel-sony-psx -c src/main.s

(**NOTE:**  `--target=mipsel` is sufficient here. Rust recognises the `mipsel-sony-psx` triple specifically, `clang` only seems to recognise the `mipsel` portion.)

Then use the `psexe.ld` script to create the PSX EXE:

    ld.lld -o nop.exe -T psexe.ld --oformat=binary  main.o

Which gives us our 4069 byte PSX EXE from the first NOP example:

    $ stat nop.exe
      File: nop.exe
      Size: 4096      	Blocks: 8          IO Block: 4096   regular file

    $ head -c8 nop.exe
    PS-X EXE


We can run our NOP executable using:

    mednafen nop.exe

It successfully does nothing. No error messages is the goal here.
