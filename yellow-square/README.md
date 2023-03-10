# Yellow Square

Inspired by [Lameguy64](http://lameguy64.net/)'s graphics tutorial (in C) http://lameguy64.net/tutorials/pstutorials/chapter1/2-graphics.html
, part of [Lameguy64's PlayStation Programming Series](http://lameguy64.net/tutorials/pstutorials/).

This small example tries to get a similar result using MIPS asm by drawing a simple graphics primative (yellow square) on a purple background. The colours and positioning are trying to match Lameguy64's example, but this example does not have double buffering.

Uses Silpheed/[HITMEN](http://hitmen.c02.at/index.html)'s `silph.inc` PSX helpful asm routines, taken from the classic [Greentro intro source](http://hitmen.c02.at/html/psx_sources.html),
and converted (by me) from [spASM](http://www.psxdev.net/forum/viewtopic.php?t=150) syntax to a more standard style which is compatible with GNU `as` and MARS MIPS assembly.

Build:

    cargo psx build


Build and run using Mednafen emulator:

    cargo psx run
