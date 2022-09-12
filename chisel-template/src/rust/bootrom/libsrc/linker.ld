OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY
{
    imem(rx)  : ORIGIN = 0x08000000, LENGTH = 2048
    dmem(rwx) : ORIGIN = 0x20000000, LENGTH = 268435456 
}

SECTIONS
{
  .isr_vector : {
      . = ALIGN(4);
      KEEP(*(.isr_vector))
      . = ALIGN(4);
  } >imem
  .text : { 
      . = ALIGN(4);
      *(.boot) 
      *(.text) 
      . = ALIGN(4);
  } >imem
  .rodata : { 
      . = ALIGN(4);
      *(.rodata) 
      . = ALIGN(4);
  } >imem
  .sdata : { 
      __sdata_start = .;
      . = ALIGN(4);
      *(.sdata) 
      . = ALIGN(4);
      __sdata_end = .;
  } >imem
  .data : {
      __data_start = .;
      . = ALIGN(4);
      *(.data)
      . = ALIGN(4);
      __data_end = .;
  } >dmem AT>imem
  .bss : { 
      . = ALIGN(4);
      __bss_start = .;
      *(.bss*) 
      *(.sbss*);
      . = ALIGN(4);
      __bss_end = .;
  } >dmem
  PROVIDE(stack_bottom = .);
  PROVIDE(_end = .);
  PROVIDE(end = .);
  PROVIDE(ramend = ORIGIN(dmem) + LENGTH(dmem));
}
