mem 80100000
00000490

as mjump 80100000


a !mstart+00000000
sw ra,$0(sp)
lui t0,#$0
sw t0,$8(sp)
li t0,#$0
sw t0,$c(sp)
li t0,#$0
sw t0,$10(sp)
jal $!mstart+00000378
nop
lui a0,#$8012
lui a2,#$0
addiu a2,a2,#$280
jal $!mstart+00000190
addiu a1,a0,#$214

a !mstart+00000038
jal $!mstart+00000428
nop
lw a3,$c(sp)
jal $!mstart+00000278
nop
jal $!mstart+00000328
nop
jal $!mstart+0000007C
nop
jal $!mstart+00000428
nop
jal $!mstart+00000120
nop
jal $!mstart+000003C4
nop
jal $!mstart+00000038
nop

a !mstart+0000007C
sw ra,$4(sp)
nop
jal $!mstart+00000428
nop
li a0,#$280
li a1,#$d6
lui a2,#$100
jal $!mstart+0000024C
addiu a2,a2,#$d4
lw t0,$10(sp)
li t1,#$b0
sub t1,t1,t0
bltz t1,$!mstart+000000B8
nop
li t1,#$0

a !mstart+000000B8
addiu a2,t1,#$50
sll a2,a2,#$10
sll t0,t0,#$10
addiu t1,t0,#$30
add a0,a0,t1
addiu a0,a0,#$e0
add a1,a1,t1
jal $!mstart+0000024C
addiu a2,a2,#$46
li t0,#$30
sub t0,zero,t0
lw t1,$10(sp)
li t2,#$f0
sll t1,t1,#$1
sub t1,t2,t1
sll t1,t1,#$10
add t0,t0,t1
add a0,a0,t0
add a1,a1,t0
lui a2,#$30
jal $!mstart+0000024C
addiu a2,a2,#$a0
lw ra,$4(sp)
nop
jr ra
nop

a !mstart+00000120
sw ra,$4(sp)
nop
lui t0,#$1f80
addiu t0,t0,#$1810
lui a0,#$3200
lui t1,#$0080
addiu t1,t1,#$7777
add a0,a0,t1
sw a0,$0(t0)
lui a0,#$70
addiu a0,a0,#$30
sw a0,$0(t0)
lui a0,#$0080
addiu a0,a0,#$3333
sw a0,$0(t0)
lui a0,#$70
addiu a0,a0,#$60
sw a0,$0(t0)
lui a0,#$0080
addiu a0,a0,#$1234
sw a0,$0(t0)
lui a0,#$20
addiu a0,a0,#$48
sw a0,$0(t0)
lw ra,$4(sp)
nop
jr ra
nop

a !mstart+00000190
li t0,#$10
sub sp,sp,t0
sw ra,$0(sp)
sw a0,$4(sp)
lui t0,#$1f80
addiu t0,t0,#$1810
lui a0,#$0100
sw a0,$4(t0)
lui a0,#$a000
sw a0,$0(t0)
sw a2,$0(t0)
lhu a0,$8(a1)
lhu t3,$a(a1)
sll a0,a0,#$1
sll t3,t3,#$10
add a0,a0,t3
sw a0,$0(t0)
lw a2,$0(a1)
li t3,#$0c
sub a2,a2,t3
li t1,#$0
addiu a1,a1,#$8

a !mstart+000001E8
addiu t1,t1,#$2
add t2,a1,t1
lbu a0,$0(t2)
lw t3,$4(sp)
sll a0,a0,#$1
add t3,t3,a0
lhu a0,$14(t3)
lbu a3,$1(t2)
sll a0,a0,#$10
sll a3,a3,#$1
lw t3,$4(sp)
nop
add t3,t3,a3
lhu a3,$14(t3)
nop
add a0,a0,a3
sw a0,$0(t0)
nop
sub t3,a2,t1
bgtz t3,$!mstart+000001E8
nop
lw ra,$0(sp)
addiu sp,sp,#$10
jr ra
nop

a !mstart+0000024C
lui t0,#$1f80
addiu t0,t0,#$1810
lui t1,#$8000
sw t1,$0(t0)
lw t1,$8(sp)
sw a0,$0(t0)
add t1,a1,t1
sw t1,$0(t0)
sw a2,$0(t0)
jr ra
nop

a !mstart+00000278
sw ra,$4(sp)
lui t0,#$1f80
addiu t0,t0,#$1810
lui t3,#$3800
add t3,t3,a3
sw t3,$0(t0)
nop
sw zero,$0(t0)
addiu a3,a3,#$0022
sw a3,$0(t0)
li a0,#$280
sw a0,$0(t0)
addiu a3,a3,#$5500
sw a3,$0(t0)
lui a0,#$100
sw a0,$0(t0)
addiu a3,a3,#$3400
sw a3,$0(t0)
lui a0,#$100
addiu a0,a0,#$280
sw a0,$0(t0)
nop
lw t0,$10(sp)
li t1,#$ff
bne t0,t1,$!mstart+0000030C
nop
li t0,#$0
sw t0,$10(sp)
nop
lw a3,$c(sp)
addiu a3,a3,#$1
lui t1,#$00ff
addiu t1,t1,#$ffff
and a3,a3,t1
nop
sw a3,$c(sp)
nop

a !mstart+0000030C
addiu t0,t0,#$1
sw t0,$10(sp)
nop
lw ra,$4(sp)
nop
jr ra
nop

a !mstart+00000328
sw ra,$4(sp)
lui a0,#$8005
lbu t0,$eaee(a0)
li t1,#$f6
bne t0,t1,$!mstart+00000368
nop
jal $!mstart+00000428
nop
lui a0,#$8010
addiu a0,a0,#!mstart+00000474-$80100000
jal $!mstart+0000044C
nop
lw ra,$0(sp)
nop
jr ra
nop

a !mstart+00000368
lw ra,$4(sp)
nop
jr ra
nop

a !mstart+00000378
sw ra,$4(sp)
lui gp,#$801e
jal $8003d72c
li a0,#$1
li a0,#$280
li a1,#$100
li a2,#$4
li a3,#$0
jal $80020f3c
sw zero,$10(sp)
li a0,#$0
li a1,#$0
li a2,#$0
jal $80021de0
li a3,#$100
lw ra,$4(sp)
nop
jr ra
nop

a !mstart+000003C4
sw ra,$4(sp)
li a0,#$0
li a1,#$0
jal $8002264c
addiu a2,gp,#$afe0
jal $8002814c
li a0,#$0
jal $80021920
li a0,#$0
li a1,#$0
li a2,#$0
lui a3,#$8008
jal $80021400
addiu a3,a3,#$2984
jal $80022628
li a0,#$0
lw t0,$8(sp)
lui t1,#$100
sub t0,t1,t0
sw t0,$8(sp)
nop
lw ra,$4(sp)
nop
jr ra
nop

a !mstart+00000428
lui t0,#$1f80
lw t1,$1814(t0)
lui t2,#$0c00
and t2,t1,t2
nop
beqz t2,$!mstart+00000428
nop
jr ra
nop

a !mstart+0000044C
li t0,#$14
sub sp,sp,t0
sw ra,$10(sp)
li t2,#$00a0
jalr ra,t2
li t1,#$003f
lw ra,$10(sp)
addiu sp,sp,#$14
jr ra
nop

am !mstart+00000474 54 49 4D 45 20 54 4F 20 51 55 49 54 20 4D 4F 4E 4B 49 45 53 2E 2E 2E 2E 00

sps death_pic.exe !mstart !mend !mjump

quit
