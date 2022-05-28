OUTPUT_ARCH(mips)
ENTRY(_start)

/* See...
 * FIGURE 4-5: MEMORY MAP ON RESET FOR PIC32MX170/270 DEVICES (64 KB RAM, 256 KB FLASH)
 * PIC32MX1XX/2XX 28/36/44-pin Family Data Sheet
 */

MEMORY
{
  kseg1_data_mem       (w!x) : ORIGIN = 0xA0000000, LENGTH = 0x10000
  kseg0_boot_mem       (rx)  : ORIGIN = 0x9FC00000, LENGTH = 0xBF0
  kseg0_program_mem    (rx)  : ORIGIN = 0x9D000000, LENGTH = 0x40000
  physical_boot_mem    (rx)  : ORIGIN = 0x1FC00000, LENGTH = 0xBF0
  physical_program_mem (rx)  : ORIGIN = 0x1D000000, LENGTH = 0x40000
  sfrs                       : ORIGIN = 0xBF800000, LENGTH = 0x100000
  configsfrs                 : ORIGIN = 0xBFC00BF0, LENGTH = 0x10
  config3                    : ORIGIN = 0xBFC00BF0, LENGTH = 0x4
  config2                    : ORIGIN = 0xBFC00BF4, LENGTH = 0x4
  config1                    : ORIGIN = 0xBFC00BF8, LENGTH = 0x4
  config0                    : ORIGIN = 0xBFC00BFC, LENGTH = 0x4
  physical_config3           : ORIGIN = 0x3FC00BF0, LENGTH = 0x4
  physical_config2           : ORIGIN = 0x3FC00BF4, LENGTH = 0x4
  physical_config1           : ORIGIN = 0x3FC00BF8, LENGTH = 0x4
  physical_config0           : ORIGIN = 0x3FC00BFC, LENGTH = 0x4
}

SECTIONS
{
  .text : { *(.text*) } > kseg0_boot_mem AT > physical_boot_mem
  .flash : { *(.flash*) } > kseg0_program_mem AT > physical_program_mem
  .bss  : { *(.bss*)  } > kseg1_data_mem
  .got : {
           _gp = ALIGN(16);
           *(.got*)
         } > kseg0_boot_mem AT > physical_boot_mem
  .devcfg0 : {
	*(.devcfg0)
	} > config0 AT > physical_config0
  .devcfg1 : {
	*(.devcfg1)
	} > config1 AT > physical_config1
  .devcfg2 : {
	*(.devcfg2)
	} > config2 AT > physical_config2
  /DISCARD/ : { *(.reginfo) *(.MIPS.abiflags) }
}
