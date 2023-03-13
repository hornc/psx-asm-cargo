#!/bin/sh

# Copy and convert my original idiosyncratic Amiga toolchain MIPS assembly:

echo Copying original archive/Death_pic.asm to death_pic.s
cp archive/Death_pic.asm death_pic.s

sed -i 's/#\$/0x/g
        s/;/#/
        s/\$!//g
        s/#!//g
        s/\$/0x/g
        ' *.s

#  Conversions:
# hex values
# comments
# clean label refs $! prefix
# clean lavel refs #! prefix
# more hex values

# Register conversions (prepend $, r0 -> $r0)
sed -i "s/\b\(ra\|gp\|fp\|sp\|zero\|[akstv][0-9]\)\b/\$\1/g" *.s

START=".set noreorder\n.global __start\n__start:"

# Set up __start:
sed -i "s/^start:/$START/" *.s

# These two are probably specific to this specific source:
# fix / replace one custom load address:
sed -i 's/addiu $a0,$a0,dbquit-0x80100000/la $a0,dbquit/' death_pic.s

# replace incorrect / overloaded? directive:
sed -i 's/^.text/.asciiz/' death_pic.s
