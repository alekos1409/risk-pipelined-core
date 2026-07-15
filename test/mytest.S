.section .text
.global _start

_start:
    addi x1, x0, 5
    addi x2, x0, 10

    .option push
.option arch, +m

    mul  x3, x1, x2

    .option pop
    j    _start
