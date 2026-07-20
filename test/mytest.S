.section .text
.global _start

_start:
    lui x10, 0x80000
    addi x1, x0, 1
     
_check:
    lw x2 , 0x1c(x10)
    lw x3, 0x14(x10)
    lw x4, 0x18(x10)
    bne x1,x2,_check
_mul:
    .option push
.option arch, +m
    mul  x5, x4, x3
    .option pop
    sw x5,0x10(x10)
    sw x0,0x1c(x10)
    j    _check
