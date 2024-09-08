SECTIONS
{
  . = 0x00000000;
  .text : {
    *(.boot);
    *(.text);
    *(.text.*);
  }
  .data : {
    . = ALIGN(4);
    *(.rodata);
    *(.rodata.*);
    . = ALIGN(4);
    __sdata_start = .;
    . = ALIGN(4);
    *(.sdata);
    *(.sdata.*);
    . = ALIGN(4);
    __sdata_end = .;
    __data_start = .;
    . = ALIGN(4);
    *(.data);
    *(.data.*);
    . = ALIGN(4);
    __data_end = .;
  }
  .got : {
    . = ALIGN(4);
    *(.got);
    . = ALIGN(4);
  }
  .bss (NOLOAD): {
    . = ALIGN(4);
    __bss_start = .;
    *(.bss*);
    *(.sbss*);
    . = ALIGN(4);
    __bss_end = .;

    *(.ubss*);
    . = ALIGN(4);
  }

  /DISCARD/ : {
      *(.panic_info*);
      *(.eh_frame*);
  }
}
