/* AT32F403ACGU7 */
/* Example: WeAct AT32 BlackPill v1.0 */
MEMORY
{
  /* NOTE: 1 K = 1 KiBi = 1024 bytes */
  /* NOTE: The chip has two banks of 512 flash, placed together */
  /* I have defined them as 1M region. */
  /* However, the chip can be made to boot from either of the banks, */
  /* so it should make sense to use them separately */
  /* NOTE: 256K of flash is aliased at 0x00000000 */
  FLASH : ORIGIN = 0x08000000, LENGTH = 1M
  /* While datasheet describes RAM as 96K+128K, memory map defines it as one contiguous region */
  RAM : ORIGIN = 0x20000000, LENGTH = 224K
}

ENTRY(Reset);

EXTERN(RESET_VECTOR);

SECTIONS
{
    .vector_table ORIGIN(FLASH) :
    {
        /* First entry: initial Stack Pointer value */
        LONG(ORIGIN(RAM) + LENGTH(RAM));

        /* Second entry: reset vector */
        KEEP(*(.vector_table.reset_vector));
    } > FLASH
    .text :
    {
        *(.text .text.*);
    } > FLASH

}
