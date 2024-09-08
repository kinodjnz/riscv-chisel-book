.option rvc
.section .boot, "ax", @progbits
.global memset

memset:
        andi    a1, a1, 255
        orc8    a1, a1
        andi    a3, a2, -8
        add     a3, a0, a3
        andi    a2, a2, 7
        beqz    a3, 2f
1:
        sw      a1, 0(a0)
        sw      a1, 4(a0)
        addi    a0, a0, 8
        bne     a0, a3, 1b
2:
        beq     a0, a2, 3f
        sb      a1, 0(a0)
        addi    a0, a0, 1
        bne     a0, a2, 2b
3:
        ret
