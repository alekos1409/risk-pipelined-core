.section .text
.global _start

_start:
    addi x1, x0, 5
    addi x2, x0, 10

    .option push
.option arch, +m

    mul  x3, x1, x2

    .option pop
    sw x4 , 0(x3)
    lw x5 , 0(x4)
    j    _start
