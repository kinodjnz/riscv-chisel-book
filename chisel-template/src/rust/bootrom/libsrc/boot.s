.option rvc
.section .boot, "ax", @progbits
.global _start

_start:
	lui	sp, %hi(ramend)
	jump	__start_rust, t0
