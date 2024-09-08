.option rvc
.section .boot, "ax", @progbits
.global _start

_start:
        lui     sp, 0x20004
        call    main
        mv      gp, a0
        li      a7, 93
        nop
        nop
        nop
        nop
        ecall
