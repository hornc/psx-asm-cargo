# Death (Sandman character) image demo

This is a little moving image demo I put together in around 1999 for the PSX, written in assembly, and using Yaroze library functions for graphics.

I'm still working out exactly what toolchain I used.

It was written on an Amiga, and transferred to my modded PSX (it had a blue power LED, and a rainbow ribbon cable fish-tail hanging out the back through the serial port)
 using a tool called `PSXControl` over a Skywalker serial cable / converter box I built (and still have).

Amazingly, this code compiles and runs in an emulator after the conversions, and being passed through [Yarexe](https://github.com/gwald/Yarexe).

I'm still trying to figure out why the load addresses don't seem correct, but it still works. The original EXE was meant to load to `0x80100000`, but the current
`cargo-psx` ld script hardcodes the standard `0x80010000` location. It feels like this should conflict with `libps.exe`

Initially I modified `psexe.ld` to use `0x80100000`, but it seemed like multiple messed up versions worked just as well, so I tried using the unmodified default... and that just worked too.

The biggest problem in the conversion and getting this to run was forgetting to add `.set noreorder` in the converted source.

It's possible the program _is_ overwiting part of the library. This code is small enough, and uses very little of the library that it might get away with overlapping some part of the library.
I'll figure it out later.

The other mystery to solve is why an original PSX EXE as compiled on the Amiga I had as a backup doesn't run as well as the new compiled version in the emulator.
This newly compiled version matches how I remember it running on the real hardware. The original EXE doesn't show the moving blocks correcyly -- they just glitch.

## Build and run

Because this code requires the `libps.exe` Yaroze library to be loaded in memory, the standard `cargo build run` to compile and run in Mednafen _won't_ work.

To build the PSX EXE:

    cargo psx build


Then we need to create a standalone executable using [Yarexe](https://github.com/gwald/Yarexe):

    yarexe death.sio -v

which will generate a new (larger) PSX executable `psx.exe`. We can now run this in the emulator using:

    mednafen psx.exe


## Orginal files
`archive/` contains the original files as taken from my A1200.

