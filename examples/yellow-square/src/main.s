// Simple draw one primative example.
.global __start
__start:
    li $sp, 0x801fff00
    li $k1, 0x1f800000  // set to hardware base

    li $a0, 0x08000009  // GP1(08h) Display mode = 320x240, PAL
    //li $a0, 0x0800000a  // GP1(08h) Display mode = 512x240, PAL
    jal InitGPU         // initialise the GPU
    nop

    //la $a0, purple_field
    la $a0, square
    jal SendList        // send display list to GPU
    nop


main_loop:
    nop
    j main_loop


.include "src/silph.inc" // some useful routines, by Silpheed/HITMEN, taken from Greentro asm intro.


.data
purple_field:
    .byte 0xFF, 0xFF, 0xFF, 0x3
    .word 0x027f003f  // GP0(02h) Fill Rectangle in VRAM
    .word 0x0         // Top left corner
    .word 0x00f00140  // y= 240, x= 320

square:
    .byte 0xFF, 0xFF, 0xFF, 0x5
    .word 0x2800ffff  // GP0(28h) - Monochrome four-point polygon, opaque (Yellow)
    .word 0x00200020
    .word 0x00200060
    .word 0x00600020
    .word 0x00600060

