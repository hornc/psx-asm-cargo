; Okay, show Death pic.s

start=80100000

start:

; sp = off 0 = addr to return to CIP
;	   4 = addr to return from sub routine	
;	   8 = y offs 100 / 0

sw ra,$0(sp)
lui t0,#$0
sw t0,$8(sp)	; y offset for display buffer switching
li t0,#$0
sw t0,$c(sp)	; backcolour
li t0,#$0
sw t0,$10(sp)   ; back ground change delay counter

jal $!gfxset
nop

; load an image to the frame buffer
lui a0,#$8012		; a0 : clut loc
lui a2,#$0		; y
addiu a2,a2,#$280	; x
jal $!loadimage
addiu a1,a0,#$214	; a1 : image loc


;-------------<Main Loop>---------------------
loop:

jal $!waitgpu
nop
lw a3,$c(sp)
jal $!drawprim   ; fill in the background with a 4 point grad. poly
nop

jal $!padcheck
nop

jal $!dofaces
nop

jal $!waitgpu
nop

jal $!ankh
nop

jal $!drawscreen
nop

jal $!loop              ; Do main loop.
nop

;=======================<end>===========================

;------------------- do faces -------------
dofaces:
sw ra,$4(sp)
nop
jal $!waitgpu
nop

li a0,#$280	; source
li a1,#$d6	; dest (screen coord)
lui a2,#$100	; h & w
jal $!moveimage
addiu a2,a2,#$d4


lw t0,$10(sp)		; background counter
li t1,#$b0
sub t1,t1,t0
bltz t1,$!truncwin
nop
li t1,#$0	; if h should be 50

truncwin:
addiu a2,t1,#$50		; if h should be less than 50
sll a2,a2,#$10		; move h to hi word of a2
sll t0,t0,#$10
addiu t1,t0,#$30	; t1 = window x and y offset

add a0,a0,t1
addiu a0,a0,#$e0
add a1,a1,t1

jal $!moveimage
addiu a2,a2,#$46


; third moving area

li t0,#$30	; undo + 30 offs
sub t0,zero,t0
lw t1,$10(sp)
li t2,#$f0
sll t1,t1,#$1	; mult by 2
sub t1,t2,t1
sll t1,t1,#$10
add t0,t0,t1	; undoing value (-ve) to be added to source and dest
add a0,a0,t0
add a1,a1,t0
lui a2,#$30
jal $!moveimage
addiu a2,a2,#$a0

lw ra,$4(sp)
nop
jr ra
nop

;------------------ ankh -----------------
ankh:
; monocrome 3 point polys
sw ra,$4(sp)
nop

lui t0,#$1f80
addiu t0,t0,#$1810		; addr of GPU_Data

lui a0,#$3200		; code for grad 3pt poly with trans
lui t1,#$0080		; trans
addiu t1,t1,#$7777	; colour
add a0,a0,t1

sw a0,$0(t0)	; 1

lui a0,#$70
addiu a0,a0,#$30
sw a0,$0(t0)	; 2

lui a0,#$0080
addiu a0,a0,#$3333
sw a0,$0(t0)	; 3

lui a0,#$70
addiu a0,a0,#$60
sw a0,$0(t0)	; 4

lui a0,#$0080
addiu a0,a0,#$1234
sw a0,$0(t0)	; 5

lui a0,#$20
addiu a0,a0,#$48
sw a0,$0(t0)	; 6

lw ra,$4(sp)
nop
jr ra
nop

;------------<load TIM image to abs addr in frame buffer with 8 bit CLUT (direct from mem!)>-------

loadimage:
li t0,#$10
sub sp,sp,t0
sw ra,$0(sp)		; store link addr and shift sp back by $10

; args: a0 = clut location
;	a1 = image location (bnum)
;	a2 = x & y to load image to
; return vals: v0 = x & y
;		v1 = h & w

add v0,zero,a0		; return x&y loc
sw a0,$4(sp)

lui t0,#$1f80
addiu t0,t0,#$1810		; addr of GPU_Data

lui a0,#$0100		; Reset command buffer
sw a0,$4(t0)		; to gp1

lui a0,#$a000
sw a0,$0(t0)		; send image to frame buffer command = $a000

sw a2,$0(t0)	; a2 is th x and y coords to load the image to

lhu a0,$8(a1)	; load width in 16 bit units (2xpixel)
lhu t3,$a(a1)	; load height in pixels
sll a0,a0,#$1	; mult width by 2 to give width in pixels (8 bit units)
sll t3,t3,#$10	; shift height to upper hword
add a0,a0,t3	; add h and w

add v1,zero,a0	; return h & w of image
sw a0,$0(t0)

lw a2,$0(a1)		; image bnum
li t3,#$0c
sub a2,a2,t3		; a2 points to start of last word of image data to send.

li t1,#$0		; pixel counter
addiu a1,a1,#$8 	; decr. image start by 2 to make up for initial incr

sendimageloop:

; a1 : constant start pos of image
; t1 : counter, incr by 2 bytes every time two pixels are drawn
; t0 : constant GPU addr
; t2 : var, pos of fisrt byte in current group of 2 image pixels
; a2 : length of pixel data in bytes 

addiu t1,t1,#$2		; incr counter by 2 (start pos (a1) is -2 out)
add t2,a1,t1		; position of current 2 byte/pixel hw 
lbu a0,$0(t2)		; load pixel 1 data

lw t3,$4(sp)		; load clut pos

sll a0,a0,#$1		; mult by two coz this counts hw,s (in the clut) rather than bytes
add t3,t3,a0		; pos of 16 bit color

lhu a0,$14(t3)		; 16 bit colour value of pixel one
lbu a3,$1(t2)		; load clut value of 2nd pixel
sll a0,a0,#$10		; move this p1's col.val word to hi pos

sll a3,a3,#$1		; mult p2's clut x2 to conv to half word count rather than bytes

lw t3,$4(sp)		; load clut start pos 
nop
add t3,t3,a3		; pos of 16 bit color

lhu a3,$14(t3)		; 16 bit colour value
nop

add a0,a0,a3		; combine the 2 pixel's data

sw a0,$0(t0)            ; send to gpu
nop

sub t3,a2,t1		; sub counter from target
bgtz t3,$!sendimageloop       ; if result grt th. 0 (not done), loop, else all done
nop

lw ra,$0(sp)
addiu sp,sp,#$10
jr ra
nop

;----------------- move image from frame buffer on to screen----------------
; in this prog the y offset is stored in $8(sp)
; this does not trash a0-a2.

moveimage:
lui t0,#$1f80
addiu t0,t0,#$1810		; addr of GPU_Data
lui t1,#$8000			; move image in fb command
sw t1,$0(t0)
lw t1,$8(sp)		 ; buffer y offset
sw a0,$0(t0)		 ; a0 = source co
add t1,a1,t1		 ; add buffer offset
sw t1,$0(t0)		 ; t1 = a1 + offs = dest co
sw a2,$0(t0)		 ; a2 = h & w of transfer

jr ra
nop


;--------- draw prim --------
drawprim:
;try to draw a polygon using the GPU
sw ra,$4(sp)

lui t0,#$1f80
addiu t0,t0,#$1810		; addr of GPU_Data


lui t3,#$3800		; grad 4poly

add t3,t3,a3 		; some colour (?)
sw t3,$0(t0)		; 1st packet (col and type)
nop

sw zero,$0(t0)		; 2nd packet
addiu a3,a3,#$0022
sw a3,$0(t0)		; col

li a0,#$280

sw a0,$0(t0)		; 3rd packet
addiu a3,a3,#$5500
sw a3,$0(t0)		; col

lui a0,#$100

sw a0,$0(t0)		; 4th packet
addiu a3,a3,#$3400
sw a3,$0(t0)	; col

lui a0,#$100
addiu a0,a0,#$280

sw a0,$0(t0)   ; 5th packet
nop

lw t0,$10(sp)
li t1,#$ff		; t1 counter max, then incr colour
bne t0,t1,$!dpaddone
nop
li t0,#$0
sw t0,$10(sp)		; reset counter
nop
lw a3,$c(sp)		; load b color and add one
addiu a3,a3,#$1
lui t1,#$00ff
addiu t1,t1,#$ffff
and a3,a3,t1
nop
sw a3,$c(sp)
nop
dpaddone:
addiu t0,t0,#$1		; incr counter by one
sw t0,$10(sp)
nop

lw ra,$4(sp)
nop
jr ra
nop



;-----------<Pad check>-------------
padcheck:

sw ra,$4(sp)

; check for start + select press on controller 1 for return to CIP
lui a0,#$8005
lbu t0,$eaee(a0)   ; a0 = pointer to 2nd high byte of pad buffer one
li t1,#$f6		; start + select, rough way of doing it.
bne t0,t1,$!noquit	; if no start+sel, return to program, else to CIP.
nop
jal $!waitgpu		; make sure gpu is not busy when quiting.
nop

lui a0,#$8010			; debug text
addiu a0,a0,#!dbquit-$80100000
jal $!debuginfo
nop


lw ra,$0(sp)		  ; Loads ra with CIP addr.
nop
jr ra
nop
noquit:
lw ra,$4(sp)
nop
jr ra
nop


;------------------<GFX routines>---------------------

gfxset:
sw ra,$4(sp)

; set up display things
lui gp,#$801e		; set global pointer to something
jal $8003d72c           ; SetVideoMode to PAL
li a0,#$1
li a0,#$280		; x res
li a1,#$100		; y res
li a2,#$4
li a3,#$0
jal $80020f3c   ; GsInitGraph
sw zero,$10(sp)
li a0,#$0
li a1,#$0
li a2,#$0
jal $80021de0  ; GsDefDispBuff
li a3,#$100

lw ra,$4(sp)
nop
jr ra
nop

;-------------------

drawscreen:
sw ra,$4(sp)
			; Draw screen, flip disp. buffer etc.
li a0,#$0
li a1,#$0
jal $8002264c		; GsClearOt
addiu a2,gp,#$afe0
jal $8002814c		; DrawSync
li a0,#$0
jal $80021920		; GsSwapDispBuff
li a0,#$0
li a1,#$0
li a2,#$0
lui a3,#$8008
jal $80021400		; GsSortClear
addiu a3,a3,#$2984
jal $80022628		; GsDrawOt
li a0,#$0

lw t0,$8(sp)   ; flip y offset [$8(sp)] between 100 and 0
lui t1,#$100
sub t0,t1,t0
sw t0,$8(sp)
nop

lw ra,$4(sp)
nop
jr ra
nop

;-------------<wait GPU>----------
waitgpu:
lui t0,#$1f80
lw t1,$1814(t0) 		; gpu control/status
lui t2,#$0c00			; was #$0c00
and t2,t1,t2
nop
beqz t2,$!waitgpu
nop
jr ra
nop

;----------------<debug and text messages>--------

debuginfo:
li t0,#$14	; subtract 14 from sp as printf seems to trash values on stack $00-$0c
sub sp,sp,t0
sw ra,$10(sp)	; store return location

li t2,#$00a0
jalr ra,t2	; jump to t2 and link-> ra
li t1,#$003f

lw ra,$10(sp)		; load initial link pos,
addiu sp,sp,#$14	; correct sp to previous position
jr ra
nop

dbquit:
.text "TIME TO QUIT MONKIES...."




