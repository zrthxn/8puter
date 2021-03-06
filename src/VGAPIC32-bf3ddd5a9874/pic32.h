#ifndef __PIC32_H__
#define __PIC32_H__

/* See...
 * TABLE 4-1: SFR MEMORYMAP
 * TABLE 11-3: PORTA REGISTER MAP
 * 11.2 CLR, SET and INV Registers
 * PIC32MX1XX/2XX 28/36/44-pin Family Data Sheet
 */

#define OC1CON		0xBF803000
#define OC1R		0xBF803010
#define OC1RS		0xBF803020
#define OC2CON		0xBF803200
#define OC2R		0xBF803210
#define OC2RS		0xBF803220
#define OC3CON		0xBF803400
#define OC3R		0xBF803410
#define OC3RS		0xBF803420

#define T1CON   	0xBF800600
#define TMR1    	0xBF800610
#define PR1     	0xBF800620
#define T2CON   	0xBF800800
#define TMR2    	0xBF800810
#define PR2     	0xBF800820
#define T3CON   	0xBF800A00
#define TMR3    	0xBF800A10
#define PR3     	0xBF800A20

#define U1MODE		0xBF806000
#define U1STA		0xBF806010
#define U1TXREG		0xBF806020
#define U1RXREG		0xBF806030
#define U1BRG		0xBF806040

#define PMCON 		0xBF807000
#define PMMODE		0xBF807010
#define PMADDR		0xBF807020
#define PMDOUT		0xBF807030
#define PMDIN 		0xBF807040
#define PMAEN 		0xBF807050
#define PMSTAT		0xBF807060

#define OSCCON		0xBF80F000
#define REFOCON		0xBF80F020
#define REFOTRIM	0xBF80F030
#define CFGCON		0xBF80F200
#define SYSKEY		0xBF80F230

#define U1RXR		0xBF80FA50

#define RPA0R		0xBF80FB00
#define RPA1R		0xBF80FB04
#define RPA2R		0xBF80FB08
#define RPA3R		0xBF80FB0C
#define RPA4R		0xBF80FB10
#define RPB0R		0xBF80FB2C
#define RPB1R		0xBF80FB30
#define RPB2R		0xBF80FB34
#define RPB3R		0xBF80FB38
#define RPB4R		0xBF80FB3C
#define RPB5R		0xBF80FB40
#define RPB10R		0xBF80FB54
#define RPB15R		0xBF80FB68

#define INTCON		0xBF881000
#define IFS0		0xBF881030
#define IFS1		0xBF881040
#define IEC0		0xBF881060
#define IEC1		0xBF881070
#define IPC1		0xBF8810A0
#define IPC2		0xBF8810B0
#define IPC7		0xBF881100
#define IPC8		0xBF881110
#define IPC10		0xBF881130

#define BMXCON		0xBF882000
#define BMXDKPBA	0xBF882010
#define BMXDUDBA	0xBF882020
#define BMXDUPBA	0xBF882030
#define BMXDRMSZ	0xBF882040

#define DMACON		0xBF883000
#define DCH0CON		0xBF883060
#define DCH0ECON	0xBF883070
#define DCH0INT		0xBF883080
#define DCH0SSA		0xBF883090
#define DCH0DSA		0xBF8830A0
#define DCH0SSIZ	0xBF8830B0
#define DCH0DSIZ	0xBF8830C0
#define DCH0CSIZ	0xBF8830F0
#define DCH1CON		0xBF883120
#define DCH1ECON	0xBF883130
#define DCH1INT		0xBF883140
#define DCH1SSA		0xBF883150
#define DCH1DSA		0xBF883160
#define DCH1SSIZ	0xBF883170
#define DCH1DSIZ	0xBF883180
#define DCH1CSIZ	0xBF8831B0
#define DCH2CON		0xBF8831E0
#define DCH2ECON	0xBF8831F0
#define DCH2INT		0xBF883200
#define DCH2SSA		0xBF883210
#define DCH2DSA		0xBF883220
#define DCH2SSIZ	0xBF883230
#define DCH2DSIZ	0xBF883240
#define DCH2CSIZ	0xBF883270

#define ANSELA		0xBF886000
#define TRISA		0xBF886010
#define PORTA		0xBF886020
#define LATA		0xBF886030
#define ODCA		0xBF886040
#define ANSELB		0xBF886100
#define TRISB		0xBF886110
#define PORTB		0xBF886120
#define LATB		0xBF886130
#define ODCB		0xBF886140

#define CLR 0x4
#define SET 0x8
#define INV 0xC

#endif /* __PIC32_H__ */
