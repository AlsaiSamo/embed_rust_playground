/* AT32F403ACGU7 */
/* Example: WeAct AT32 BlackPill v1.0 */
MEMORY
{
  /* NOTE: 1 K = 1 KiBi = 1024 bytes */
  /* NOTE: The chip has two banks of 256K flash, placed together */
  /* I have defined them as one 512K region. */
  /* NOTE: 16K of flash is aliased at 0x00000000 */
  FLASH : ORIGIN = 0x08000000, LENGTH = 512K
  RAM : ORIGIN = 0x20000000, LENGTH = 96K
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
