/*
 * Generate a VGA signal using a PIC32 microcontroller.
 *
 * Copyright (C) 2017 Paul Boddie <paul@boddie.org.uk>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "mips.h"
#include "pic32.h"
#include "vga.h"

/* Disable JTAG functionality on pins. */

.section .devcfg0, "a"
.word 0xfffffffb	/* DEVCFG0<2> = JTAGEN = 0 */

/*
Set the oscillator to be the FRC oscillator with PLL, with peripheral clock
divided by 2, and FRCDIV+PLL selected.

The watchdog timer (FWDTEN) is also disabled.

The secondary oscillator pin (FSOSCEN) is disabled to avoid pin conflicts with
RPB4.
*/

.section .devcfg1, "a"
.word 0xff7fdfd9	/* DEVCFG1<23> = FWDTEN = 0; DEVCFG1<13:12> = FPBDIV<1:0> = 1;
			DEVCFG1<5> = FSOSCEN = 0; DEVCFG1<2:0> = FNOSC<2:0> = 001 */

/*
Set the FRC oscillator PLL function with an input division of 4, an output
division of 2, a multiplication of 24, yielding a multiplication of 3.

The FRC is apparently at 16MHz and this produces a system clock of 48MHz.
*/

.section .devcfg2, "a"
.word 0xfff9fffb	/* DEVCFG2<18:16> = FPLLODIV<2:0> = 001;
			DEVCFG2<6:4> = FPLLMUL<2:0> = 111;
			DEVCFG2<2:0> = FPLLIDIV<2:0> = 011 */

.text
.globl _start
.extern init_framebuffer
.extern init_framebuffer_with_pattern
.extern screendata
.extern blit_string
.extern message0
.extern message1

.macro load_affected
	lw $v0, -4($k0)
	lw $v1, -8($k0)
	lw $s0, -12($k0)
	lw $s1, -16($k0)
	lw $s2, -20($k0)
	lw $s3, -24($k0)
	lw $t8, -28($k0)
	lw $ra, -32($k0)
	lw $sp, -36($k0)
	lw $gp, -40($k0)
.endm

.macro load_state
	lw $s0, -44($k0)
	lw $s1, -48($k0)
	lw $s2, -52($k0)
	lw $s3, -56($k0)
	lw $gp, -60($k0)
.endm

.macro save_affected
	sw $v0, -4($k0)
	sw $v1, -8($k0)
	sw $s0, -12($k0)
	sw $s1, -16($k0)
	sw $s2, -20($k0)
	sw $s3, -24($k0)
	sw $t8, -28($k0)
	sw $ra, -32($k0)
	sw $sp, -36($k0)
	sw $gp, -40($k0)
.endm

.macro save_state
	sw $s0, -44($k0)
	sw $s1, -48($k0)
	sw $s2, -52($k0)
	sw $s3, -56($k0)
	sw $gp, -60($k0)
.endm

_start:
	/*
	Configure RAM.
	See: http://microchipdeveloper.com/32bit:mx-arch-exceptions-processor-initialization
	*/

	la $v0, BMXCON
	lw $v1, 0($v0)

	/* Set zero wait states for address setup. */

	li $t8, ~(1 << 6)	/* BMXCON<6> = BMXWSDRM = 0 */
	and $v1, $v1, $t8

	/* Set bus arbitration mode. */

	li $t8, ~0b111		/* BMXCON<2:0> = BMXARB<2:0> = 0 */
	ori $t8, $t8, 0b010	/* BMXCON<2:0> = BMXARB<2:0> = 2 */
	and $v1, $v1, $t8
	sw $v1, 0($v0)

	/* Enable caching. */

	mfc0 $v1, CP0_CONFIG
	li $t8, ~CONFIG_K0
	and $v1, $v1, $t8
	ori $v1, $v1, CONFIG_K0_CACHABLE_NONCOHERENT
	mtc0 $v1, CP0_CONFIG
	nop

	/* Get the RAM size. */

	la $v0, BMXDRMSZ
	lw $t0, 0($v0)

	/* Initialise the stack pointer. */

	li $v1, KSEG0_BASE
	addu $sp, $t0, $v1	/* sp = KSEG0_BASE + RAM size */

	/* Initialise the globals pointer. */

	lui $gp, %hi(_GLOBAL_OFFSET_TABLE_)
	ori $gp, $gp, %lo(_GLOBAL_OFFSET_TABLE_)

	/* Set pins for output. */

	jal init_pins
	nop

	la $t0, PORTA
	li $t1, (1 << 3)	/* PORTA<3> = RA3 */
	sw $t1, CLR($t0)

	jal init_io_pins
	nop

	/* Initialise the status register. */

	jal init_interrupts
	nop

	/* Initialise framebuffer. */

	la $a0, screendata
	jal init_framebuffer
	nop

	sync

	/* Initialise timer. */

	jal init_timer2
	nop

	/* Initialise DMA. */

	jal init_dma
	nop

	/* Initialise OC1 and OC2. */

	jal init_oc
	nop

	/* Initialise UART for debugging. */

	jal init_uart
	nop

	/* Initialise the display state. */

	li $s0, 0		/* line counter */
	la $s1, vbp_active	/* current event */
	li $s2, SCREEN_BASE	/* line address */
	li $s3, SCREEN_BASE	/* screen address */

	/* Save the state for retrieval in the interrupt handler. */

	li $k0, IRQ_STACK_LIMIT
	save_state

	/* Enable interrupts and loop. */

	jal enable_interrupts
	nop

	jal handle_error_level
	nop

	/* Main program. */

	li $a1, (3 << 24)	/* counter ~= 50000000 */
	li $a2, 0xffffff	/* test counter at every 1/4 of range */
	move $t2, $zero		/* picture to show */

	/* Monitoring loop. */
loop:
	addiu $a1, $a1, -1	/* counter -= 1 */
	and $t1, $a2, $a1
	bnez $t1, loop
	nop

	la $t0, PORTA
	li $t1, (1 << 3)	/* PORTA<3> = RA3 */
	sw $t1, INV($t0)

	la $v0, U1TXREG
	li $v1, '.'
	sw $v1, 0($v0)

	bnez $a1, loop		/* until counter == 0 */
	nop

	bnez $t2, _picture1
	nop

	/* Show picture 0. */

	la $a0, screendata
	jal init_framebuffer
	nop

	la $a0, message0
	li $a1, SCREEN_BASE_KSEG0
	jal blit_string
	nop

	li $t2, 1
	j _next
	nop

_picture1:
	/* Show picture 1. */

	jal init_framebuffer_with_pattern
	nop

	la $a0, message1
	li $a1, SCREEN_BASE_KSEG0
	jal blit_string
	nop

	move $t2, $zero

_next:
	li $a1, (3 << 24)	/* counter ~= 50000000 */
	li $a2, 0xffffff	/* test counter at every 1/4 of range */
	j loop
	nop



init_pins:
	/* DEVCFG0<2> needs setting to 0 before the program is run. */

	la $v0, CFGCON
	li $v1, (1 << 3)	/* CFGCON<3> = JTAGEN = 0 */
	sw $v1, CLR($v0)

init_outputs:
	/* Remove analogue features from pins. */

	la $v0, ANSELA
	sw $zero, 0($v0)	/* ANSELA = 0 */
	la $v0, ANSELB
	sw $zero, 0($v0)	/* ANSELB = 0 */

	la $v0, TRISA
	sw $zero, 0($v0)
	la $v0, TRISB
	sw $zero, 0($v0)

	la $v0, PORTA
	sw $zero, 0($v0)
	la $v0, PORTB
	sw $zero, 0($v0)

	jr $ra
	nop



/*
Timer initialisation.

Timer2 is used to drive the output compare and DMA peripherals.
*/

init_timer2:

	/* Initialise Timer2 for sync pulses. */

	la $v0, T2CON
	sw $zero, 0($v0)	/* T2CON = 0 */
	nop

	la $v0, TMR2
	sw $zero, 0($v0)	/* TMR2 = 0 */

	la $v0, PR2
	li $v1, HFREQ_LIMIT
	sw $v1, 0($v0)		/* PR2 = HFREQ_LIMIT */

	/* Start timer. */

	la $v0, T2CON
	li $v1, (1 << 15)
	sw $v1, SET($v0)	/* ON = 1 */

	jr $ra
	nop



/*
Output compare initialisation.

Timer2 will be used to trigger two events using OC1: one initiating the hsync
pulse, and one terminating the pulse. The pulse should appear after the line
data has been transferred using DMA, but this is achieved by just choosing
suitable start and end values.

Using OC2, Timer2 triggers a level shifting event and OC2 is reconfigured to
reverse the level at a later point. In this way, the vsync pulse is generated
and is synchronised to the display lines.

The OC1 interrupt is used to update the state machine handling the display,
also invoking the address update routine at the end of each visible display
line, changing the source address of the DMA channel.
*/

init_oc:
	/* Disable OC1 interrupts. */

	li $v1, (1 << 7)

	la $v0, IEC0
	sw $v1, CLR($v0)	/* IEC0<7> = OC1IE = 0 */
	la $v0, IFS0
	sw $v1, CLR($v0)	/* IFS0<7> = OC1IF = 0 */

	/* Initialise OC1. */

	la $v0, OC1CON
	li $v1, 0b101		/* OC1CON<2:0> = OCM<2:0> = 101 (dual compare, continuous pulse) */
	sw $v1, 0($v0)

	/* Pulse start and end. */

	la $v0, OC1R
	li $v1, HSYNC_END	/* HSYNC_START for positive polarity */
	sw $v1, 0($v0)

	la $v0, OC1RS
	li $v1, HSYNC_START	/* HSYNC_END for positive polarity */
	sw $v1, 0($v0)

	/* Enable interrupt for address updating. */

	la $v0, IPC1
	li $v1, (0b11111 << 16)
	sw $v1, SET($v0)	/* OC1IP = 7; OC1IS = 3 */

	la $v0, IEC0
	li $v1, (1 << 7)
	sw $v1, SET($v0)	/* IEC0<7> = OC1IE = 1 */

	/* OC1 is enabled. */

	la $v0, OC1CON
	li $v1, (1 << 15)
	sw $v1, SET($v0)

	/* Disable OC2 interrupts. */

	li $v1, (1 << 12)

	la $v0, IEC0
	sw $v1, CLR($v0)	/* IEC0<12> = OC2IE = 0 */
	la $v0, IFS0
	sw $v1, CLR($v0)	/* IFS0<12> = OC2IF = 0 */

	/* Initialise OC2. */

	la $v0, OC2CON
	li $v1, 0b010		/* OC2CON<2:0> = OCM<2:0> = 010 (single compare, output driven low) */
	sw $v1, 0($v0)

	/* Set pulse position. */

	la $v0, OC2R
	sw $zero, 0($v0)

	/* Enable OC2 later. */

	jr $ra
	nop

init_io_pins:
	/* Unlock the configuration register bits. */

	la $v0, SYSKEY
	sw $zero, 0($v0)
	li $v1, 0xAA996655
	sw $v1, 0($v0)
	li $v1, 0x556699AA
	sw $v1, 0($v0)

	la $v0, CFGCON
	lw $t8, 0($v0)
	li $v1, (1 << 13)	/* IOLOCK = 0 */
	sw $v1, CLR($v0)

	/* Map OC1 to RPA0. */

	la $v0, RPA0R
	li $v1, 0b0101		/* RPA0R<3:0> = 0101 (OC1) */
	sw $v1, 0($v0)

	/* Map OC2 to RPA1. */

	la $v0, RPA1R
	li $v1, 0b0101		/* RPA1R<3:0> = 0101 (OC2) */
	sw $v1, 0($v0)

	/* Map U1TX to RPB15. */

	la $v0, RPB15R
	li $v1, 0b0001		/* RPB15R<3:0> = 0001 (U1TX) */
	sw $v1, 0($v0)

	la $v0, CFGCON
	sw $t8, 0($v0)

	/* Lock the oscillator control register again. */

	la $v0, SYSKEY
	li $v1, 0x33333333
	sw $v1, 0($v0)

	jr $ra
	nop



/*
Direct Memory Access initialisation.

Write 160 pixels to PORTB for the line data. This is initiated by a timer
interrupt.
*/

init_dma:
	/* Disable DMA interrupts. */

	li $v1, (3 << 28)

	la $v0, IEC1
	sw $v1, CLR($v0)	/* IEC1<29:28> = DMA1IE, DMA0IE = 0 */

	/* Clear DMA interrupt flags. */

	la $v0, IFS1
	sw $v1, CLR($v0)	/* IFS1<29:28> = DMA1IF, DMA0IF = 0 */

	/* Enable DMA. */

	la $v0, DMACON
	li $v1, (1 << 15)
	sw $v1, SET($v0)

	/*
	Initialise a line channel.
	The line channel will be channel 0 (x = 0).

	Specify a priority of 3:
	DCHxCON<1:0> = CHPRI<1:0> = 3

	Auto-enable the channel:
	DCHxCON<4> = CHAEN = 1
	*/

	la $v0, DCH0CON
	li $v1, 0b10011
	sw $v1, 0($v0)

	/*
	Initialise a level reset channel.
	The reset channel will be channel 1 (x = 1).

	Specify a priority of 3:
	DCHxCON<1:0> = CHPRI<1:0> = 3

	Chain the channel to channel 0:
	DCHxCON<5> = CHCHN = 1
	*/

	la $v0, DCH1CON
	li $v1, 0b100011
	sw $v1, 0($v0)

	/*
	Initiate channel transfers when the initiating interrupt condition
	occurs:
	DCHxECON<15:8> = CHSIRQ<7:0> = timer 2 interrupt
	DCHxECON<4> = SIRQEN = 1
	*/

	la $v0, DCH0ECON
	li $v1, (9 << 8) | (1 << 4)
	sw $v1, 0($v0)

	/*
	Initiate reset channel transfer when channel 0 is finished:
	DCHxECON<15:8> = CHSIRQ<7:0> = channel 0 interrupt
	DCHxECON<4> = SIRQEN = 1
	*/

	la $v0, DCH1ECON
	li $v1, (60 << 8) | (1 << 4)
	sw $v1, 0($v0)

	/*
	The line channel has a cell size of the number bytes in a line:
	DCHxCSIZ<15:0> = CHCSIZ<15:0> = LINE_LENGTH
	*/

	la $v0, DCH0CSIZ
	li $v1, LINE_LENGTH
	sw $v1, 0($v0)

	/*
	The reset channel has a cell size of a single zero byte:
	DCHxCSIZ<15:0> = CHCSIZ<15:0> = 1
	*/

	la $v0, DCH1CSIZ
	li $v1, 1
	sw $v1, 0($v0)

	/*
	The source has a size identical to the cell size:
	DCHxSSIZ<15:0> = CHSSIZ<15:0> = LINE_LENGTH or 1
	*/

	la $v0, DCH0SSIZ
	li $v1, LINE_LENGTH
	sw $v1, 0($v0)

	la $v0, DCH1SSIZ
	li $v1, 1
	sw $v1, 0($v0)

	/*
	The source address is the physical address of the line data:
	DCHxSSA = physical(line data address)
	*/

	la $v0, DCH0SSA
	li $v1, SCREEN_BASE
	sw $v1, 0($v0)

	/*
	For the reset channel, a single byte of zero is transferred:
	DCHxSSA = physical(zero data address)
	*/

	la $v0, DCH1SSA
	la $v1, zerodata
	li $t8, KSEG0_BASE
	subu $v1, $v1, $t8
	sw $v1, 0($v0)

	/*
	The destination has a size of 1 byte:
	DCHxDSIZ<15:0> = CHDSIZ<15:0> = 1
	*/

	li $v1, 1

	la $v0, DCH0DSIZ
	sw $v1, 0($v0)

	la $v0, DCH1DSIZ
	sw $v1, 0($v0)

	/*
	The destination address is the physical address of PORTB:
	DCHxDSA = physical(PORTB)
	*/

	li $v1, PORTB
	li $t8, KSEG1_BASE
	subu $v1, $v1, $t8

	la $v0, DCH0DSA
	sw $v1, 0($v0)

	la $v0, DCH1DSA
	sw $v1, 0($v0)

	/* Enable interrupt for channel chaining. */

	la $v0, DCH0INT
	li $v1, (1 << 19)	/* CHBCIE = 1 */
	sw $v1, 0($v0)

	la $v0, IPC10
	li $v1, 0b11111		/* DMA0IP, DMA0IS = 0 */
	sw $v1, CLR($v0)
	li $v1, 0b10011		/* DMA0IP = 4, DMA0IS = 3 */
	sw $v1, SET($v0)

	la $v0, IEC1
	li $v1, (1 << 28)	/* IEC1<28> = DMA0IE = 1 */
	sw $v1, SET($v0)

	/* Enable line channel later. */

	jr $ra
	nop

zerodata:
.word 0



/*
UART initialisation.

Initialise UART transmission at 115200 baud. This is sensitive to the peripheral
clock frequency.
*/

init_uart:
        /* Initialise UART. */

	la $v0, U1BRG
	li $v1, 12			/* U1BRG<15:0> = BRG = (FPB / (16 * baudrate)) - 1 = (24000000 / (16 * 115200)) - 1 = 12 */
	sw $v1, 0($v0)

	la $v0, U1MODE
	li $v1, (1 << 15)		/* U1MODE<15> = ON = 0 */
	sw $v1, CLR($v0)

	/* Start UART. */

	la $v0, U1STA
	li $v1, (1 << 10)		/* U1STA<10> = UTXEN = 1 */
	sw $v1, SET($v0)

	la $v0, U1MODE
	li $v1, (1 << 15)		/* U1MODE<15> = ON = 1 */
	sw $v1, SET($v0)

	jr $ra
	nop



/* Utilities. */

handle_error_level:
	mfc0 $t3, CP0_STATUS
	li $t4, ~(STATUS_ERL | STATUS_EXL)
	and $t3, $t3, $t4
	mtc0 $t3, CP0_STATUS
	jr $ra
	nop

enable_interrupts:
	mfc0 $t3, CP0_STATUS
	li $t4, ~STATUS_IRQ	/* Clear interrupt priority bits. */
	and $t3, $t3, $t4
	ori $t3, $t3, (3 << STATUS_IRQ_SHIFT)
	li $t4, ~STATUS_BEV	/* CP0_STATUS &= ~STATUS_BEV (use non-bootloader vectors) */
	and $t3, $t3, $t4
	ori $t3, $t3, STATUS_IE
	mtc0 $t3, CP0_STATUS
	jr $ra
	nop

init_interrupts:
	mfc0 $t3, CP0_DEBUG
	li $t4, ~DEBUG_DM
	and $t3, $t3, $t4
	mtc0 $t3, CP0_DEBUG

	mfc0 $t3, CP0_STATUS
	li $t4, STATUS_BEV	/* BEV = 1 or EBASE cannot be set */
	or $t3, $t3, $t4
	mtc0 $t3, CP0_STATUS

	la $t3, exception_handler
	mtc0 $t3, CP0_EBASE	/* EBASE = exception_handler */

	li $t3, 0x20		/* Must be non-zero or the CPU gets upset */
	mtc0 $t3, CP0_INTCTL

	li $t3, CAUSE_IV	/* IV = 1 (use EBASE+0x200 for interrupts) */
	mtc0 $t3, CP0_CAUSE

	jr $ra
	nop



/* Exception servicing. */

.section .flash, "a"

/* TLB error servicing. */

tlb_handler:
	j exception_handler
	nop



/* General exception servicing. */

.org 0x180

exception_handler:
	j exc_handler
	nop



/* Interrupt servicing. */

.org 0x200

interrupt_handler:

	/*
	Save affected registers, restoring IRQ state and switching to the IRQ
	stack.
	*/

	li $k0, IRQ_STACK_LIMIT
	save_affected
	load_state
	li $sp, IRQ_STACK_TOP

	/* Check for the output compare interrupt condition. */

	la $v0, IFS0
	lw $v1, 0($v0)
	andi $v1, $v1, (1 << 7)	/* OC1IF */
	beqz $v1, irq_dma
	nop

irq_handle:
	/* Clear the interrupt condition. */

	sw $v1, CLR($v0)

	/* Increment the line counter. */

	addiu $s0, $s0, 1

	/* Jump to the event handler. */

	jalr $s1
	nop

irq_dma:
	/* Clear the DMA channel completion condition. */

	la $v0, IFS1
	lw $v1, 0($v0)
	li $t8, (1 << 28)
	and $v1, $v1, $t8
	beqz $v1, irq_exit
	nop

	sw $v1, CLR($v0)	/* IFS1<28> = DMA0IF = 0 */

	la $v0, DCH0INT
	lw $v1, 0($v0)
	andi $v1, $v1, (1 << 3)
	beqz $v1, irq_exit
	nop

	sw $v1, CLR($v0)	/* CHBCIF = 0 */

irq_exit:
	/*
	Save IRQ state and restore the affected registers, switching back to the
	original stack.
	*/

	li $k0, IRQ_STACK_LIMIT
	save_state
	load_affected

	eret
	nop



/* Event routines. */

/* The vertical back porch. */

vbp_active:
	/* Test for visible region. */

	sltiu $v0, $s0, VISIBLE_START
	bnez $v0, _vbp_active_ret
	nop

	/* Start the visible region. */

	la $s1, visible_active

	/* Reset the line address. */

	move $s2, $s3

	/* Update the source address. */

	la $v0, DCH0SSA
	sw $s2, 0($v0)

	/* Enable the line channel for timer event transfer initiation. */

	la $v0, DCH0CON
	li $v1, (1 << 7)
	sw $v1, SET($v0)

_vbp_active_ret:
	jr $ra
	nop



/* The visible region. */

visible_active:
	/* Test for front porch. */

	sltiu $v0, $s0, VFP_START
	bnez $v0, visible_update_address
	nop

	/* Start the front porch region. */

	la $s1, vfp_active

	/* Disable the line channel. */

	la $v0, DCH0CON
	li $v1, (1 << 7)
	sw $v1, CLR($v0)

_visible_active_ret:
	jr $ra
	nop



/* DMA update routine. */

visible_update_address:

	/*
	Update the line data address if the line counter (referring to the
	next line) is even.
	*/

	andi $t8, $s0, 1
	bnez $t8, _visible_update_ret
	nop

	/* Reference the next line and update the DMA source address. */

	addiu $s2, $s2, LINE_LENGTH

	/* Test for wraparound. */

	li $t8, (SCREEN_BASE + SCREEN_SIZE)
	sltu $t8, $s2, $t8
	bnez $t8, _visible_dma_update
	nop

	/* Reset the source address. */

	li $s2, SCREEN_BASE

_visible_dma_update:

	/* Update the source address. */

	la $v0, DCH0SSA
	sw $s2, 0($v0)

_visible_update_ret:
	jr $ra
	nop



/* Within the vertical front porch. */

vfp_active:
	/* Test for vsync. */

	sltiu $v0, $s0, VSYNC_START
	bnez $v0, _vfp_active_ret
	nop

	/* Start the vsync. */

	la $s1, vsync_active

	/* Bring vsync low when the next line starts. */

	la $v0, OC2CON
	li $v1, 0b010 | (1 << 15)	/* OC2CON<2:0> = OCM<2:0> = 010 (single compare, output driven low) */
	sw $v1, 0($v0)

_vfp_active_ret:
	jr $ra
	nop



/* The vsync period. */

vsync_active:
	/* Test for front porch. */

	sltiu $v0, $s0, VSYNC_END
	bnez $v0, _vsync_active_ret
	nop

	/* Start the back porch. */

	move $s0, $zero
	la $s1, vbp_active

	/* Bring vsync high when the next line starts. */

	la $v0, OC2CON
	li $v1, 0b001 | (1 << 15)	/* OC2CON<2:0> = OCM<2:0> = 001 (single compare, output driven high) */
	sw $v1, 0($v0)

_vsync_active_ret:
	jr $ra
	nop



/* Exception handler. */

exc_handler:
	mfc0 $t7, CP0_ERROREPC
	nop
	la $ra, exc_handler_end

exc_write_word:
	li $t8, 32
        la $v0, U1TXREG
exc_loop:
	addiu $t8, $t8, -4
	srlv $v1, $t7, $t8	/* $v1 = $t7 >> $t8 */
	andi $v1, $v1, 0xF
	addiu $t9, $v1, -10	/* $t9 >= 10? */
	bgez $t9, exc_alpha
	nop
exc_digit:
	addiu $v1, $v1, 48	/* convert to digit: '0' */
	j exc_write
	nop
exc_alpha:
	addiu $v1, $v1, 55	/* convert to alpha: 'A' - 10 */
exc_write:
        sw $v1, 0($v0)
	bnez $t8, exc_loop
	nop
exc_loop_end:
	li $v1, ' '
        sw $v1, 0($v0)

exc_handler_end:
	jr $ra
	nop
