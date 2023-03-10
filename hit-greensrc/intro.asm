# Another simple asm intro source by Silpheed of HITMEN
            .set noreorder
            #org 0x80010000
.global __start
__start:
            li $sp, 0x801fff00
            li $k1, 0x1f800000            # set to hardware base

            li $a0, 0x08000009
            jal InitGPU                 # initialise the GPU
            nop

            la $a0, image                # transfer image data to VRAM
            li $a1, 320
            li $a2, 0x820090
            li $a3, 9360
            jal MEM2VRAM_IO
            nop

            la $a0, clut                 # transfer clut data to VRAM
            li $a1, 0x1000140
            li $a2, 0x10100
            li $a3, 128
            jal MEM2VRAM_IO
            nop

            jal InitPads                # init pads, also the wait vsync routine
            nop

            la $a0, module
            jal HM_Init                 # init the mod player
            nop


# Main parts of the intro:

# Part 1 - draw the lines across the top and bottom of the screen

            li $s0, 0
            li $s1, 320
part1:
            sh $s0, line1                # update line positions
            sh $s1, line2

            jal WaitIdle                # wait for GPU to finish processing
            nop

            jal WaitVSync               # wait for vertical retrace period
            nop

            la $a0, list
            jal SendList                # send display list to GPU
            nop

            slt $s2,$s0,320
            addiu $s1,-4
            bnez $s2, part1              # loop until lines finished
            addiu $s0,4


# Part 2 - move logo down from top of screen

            li $s1, 0xffffffae            # (-82)
part2:
            sh $s1, lpos1+2              # update sprite positions
            sh $s1, lpos2+2              # 2 sprites needed (logo is more than 256 pixels wide)

            jal WaitIdle
            nop

            jal WaitVSync
            nop

            la $a0, list
            jal SendList
            nop

            slt $s2,$s1,32
            bnez $s2, part2
            addiu $s1,2


# Part 3 - the main part... do the text writer and play the music

            li $s0, 0                    # page number
            li $s4, 0                    # delay counter

resetpage:   sll $s1,$s0,2
            la $s2, pages
            addu $s2,$s1
            lw $s1, ($s2)                 # read page address

            li $s2, 0                    # char number
            la $s3, prim3                # first char in display list

part3:
            jal HM_Poll                 # call mod player
            nop

            slt $t0, $s2, 288
            bnez $t0, skipreset          # dont reset until all chars updated
            nop

            slt $t0, $s4, 300             # wait for 300 frames before continuing
            bnez $t0, skipupdate
            addiu $s4,1

            li $s4, 0                    # reset counter
            addiu $s0,1                  # goto next page
            andi $s0,3

            li $t0, 0                    # clear all chars
            li $t1, 82
            li $t4, 0
            la $t3, prim3

clearpage:   sb $t0, 12($t3)
            sb $t1, 13($t3)

            addiu $t3, 16
            addiu $t4, 1
            slt $t5, $t4, 288
            bnez $t5, clearpage
            nop

            jal WaitVSync
            nop

            b resetpage
            nop

skipreset:   addu $t0, $s1, $s2             # address of current char
            lb $t1, ($t0)                 # read it
            nop
            addiu $t1,-32

            srl $t0, $t1, 4
            sll $t0, 3                   # $t0 = y offset of char in tpage
            andi $t1, 15
            sll $t1, 3
            addiu $t0, 82                # $t1 = x offset of char in tpage

            sb $t0, 13($s3)               # update sprite in display list
            sb $t1, 12($s3)

            addiu $s3,16                 # move to next sprite
            addiu $s2,1                  # next char

skipupdate:
            jal WaitIdle
            nop

            jal WaitVSync
            nop

            la $a0, list
            jal SendList
            nop

            j part3                     # loop forever
            nop



.include "silph.inc"                    # some useful routines

image: .incbin "gfx.raw"                 # the raw image data for the logo and chars
clut: .incbin "gfx.clt"                  # clut info for above

.align 4
list: .include "list.inc"                # the display list

pages: .word page1, page2, page3, page4     # the pages to display

page1:
    .ascii "------------------------"
    .ascii "   HITMEN Presents...   "
    .ascii "                        "
    .ascii "     The GREENtro!      "
    .ascii "                        "
    .ascii "   Hmm... I think this  "
    .ascii "  business of calling   "
    .ascii "  every release XXXXtro "
    .ascii "   is getting silly...  "
    .ascii "      dont you? :)      "
    .ascii "                        "
    .ascii "------------------------"

page2:
    .ascii "                        "
    .ascii "     INTRO CREDITS:     "
    .ascii "                        "
    .ascii "                        "
    .ascii "CODING..........Silpheed"
    .ascii "                        "
    .ascii "LOGO..............Gunhed"
    .ascii "                        "
    .ascii "MUSIC............Unknown"
    .ascii "                        "
    .ascii "                        "
    .ascii "                        "

page3:
    .ascii "                        "
    .ascii "Greets fly out to...    "
    .ascii "(in no particular order)"
    .ascii "                        "
    .ascii "BlackBag Napalm Creature"
    .ascii "Roncler Gang K-Comm Acon"
    .ascii "   Birdhouse Projects   "
    .ascii "   Vision Thing Fab-4   "
    .ascii "                        "
    .ascii "Special greets to Nagra "
    .ascii "     and Dodger...      "
    .ascii "                        "

page4:
    .ascii "                        "
    .ascii "                        "
    .ascii " Now go take a look at  "
    .ascii " the source for this    "
    .ascii " little thing and get   "
    .ascii "  coding!!              "
    .ascii "                        "
    .ascii "                        "
    .ascii "     - Silpheed         "
    .ascii "                        "
    .ascii "                        "
    .ascii "HITMEN - Ruling in 1998!"

module: .incbin "thesong.hit"

.align 4
.include "hitmod.inc"



