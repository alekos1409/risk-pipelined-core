.section .text
.global _start

_start:
    lui x10, 0x80000
    addi x1, x0, 1
    addi x6 ,x0 , 2
    add x7, x1, x6
     
_check:
    lw x2 , 0x1c(x10)
    lw x3, 0x14(x10)
    lw x4, 0x18(x10)
    bne x1,x2,_check
_add:
    add x5, x3,x4
    sw x5,0x10(x10)
    sw x0,0x1c(x10)
    j    _check
