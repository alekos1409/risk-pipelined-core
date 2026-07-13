.section .text
.global start

start:
    addi x1, x0, 1
    addi x2, x0, -2
    sub  x3, x1, x2
    sw   x3, 0(x21)
    sw   x5, 0(x4)
    j    start
