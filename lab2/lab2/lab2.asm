/*
 * lab2.asm
 * 
 * This is a very simple demo program made for the course DA215A at
 * Malmö University. The purpose of this program is:
 *	-	To test if a program can be transferred to the ATmega32U4
 *		microcontroller.
 *	-	To provide a base for further programming in "Laboration 1".
 *
 * After a successful transfer of the program, while the program is
 * running, the embedded LED on the Arduino board should be turned on.
 * The LED is connected to the D13 pin (PORTC, bit 7).
 *
 * Author:	Judy Sibai, Zainab Alfredji
 *
 * Date:	2021-12-02
 */ 
 
;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	.EQU RESET		= 0x0000
	.EQU PM_START	= 0x0056
	.DEF TEMP 		= R16
	.DEF RVAL		= R24
	.EQU NO_KEY		= 0x0F
	.DEF NO_PRESS	= R25

	

;==============================================================================
; Start of program
;==============================================================================
	.CSEG
	.ORG RESET
	RJMP init

	.ORG PM_START
	.INCLUDE "delay.inc"
	.INCLUDE "lcd.inc"

;==============================================================================
; Basic initializations of stack pointer, I/O pins, etc.
;==============================================================================
init:
	; Set stack pointer to point at the end of RAM.
	LDI TEMP, LOW(RAMEND)	; TEMP = LOW (RAMEND)
	OUT SPL, TEMP
	LDI TEMP, HIGH(RAMEND)	; TEMP = HIGH (RAMEND)
	OUT SPH, TEMP
	; Initialize pins
	CALL init_pins
	CALL lcd_init
	; Jump to main part of program
	RJMP main

;==============================================================================
; Initialize I/O pins
;==============================================================================
init_pins:	
	/*LDI TEMP, 0b10000000
	OUT DDRC, TEMP

	RET*/

	LDI TEMP, 0x00		; TEMP = 0x00
	OUT DDRE, TEMP		;ingångar
	OUT PORTE, TEMP
	

	LDI TEMP, 0xFF		; TEMP = 0xFF
	OUT DDRC, TEMP		;utgångar
	OUT DDRF, TEMP
	OUT DDRB, TEMP
	OUT DDRD, TEMP


	RET

;==============================================================================
; Read keyboard
;==============================================================================
	

read_keyboard:
	LDI R18, 0	; reset counter
scan_key:
	MOV R19, R18		; R19 => R18
	LSL R19
	LSL R19
	LSL R19
	LSL R19
	OUT PORTB, R19		; set column and row
	
	PUSH R19			;istället för NOP
	LDI R24, 10
	RCALL delay_ms
	POP R19

	SBIC PINE, 6		; PINE.6 = 0
	RJMP return_key_val
	INC R18
	CPI R18, 12
	BRNE scan_key
	LDI R18, NO_KEY		; no key was pressed!
return_key_val:
	MOV RVAL, R18		; RVAL 0 => R18
	RET
	
;==============================================================================
; Main part of program
;==============================================================================
main:		
	

	/*
	LDI R24, 'H'
	RCALL lcd_write_chr
	LDI R24, 'E'
	RCALL lcd_write_chr
	LDI R24, 'L'
	RCALL lcd_write_chr
	LDI R24, 'L'
	RCALL lcd_write_chr
	LDI R24, 'O'
	RCALL lcd_write_chr
	LDI R24, '!'
	RCALL lcd_write_chr
loop:
	RJMP loop*/


	LCD_WRITE_CHAR 'K'		;text till LCD
	LCD_WRITE_CHAR 'E'
	LCD_WRITE_CHAR 'Y'
	LCD_WRITE_CHAR ':'

	/*LDI R24, 0XC6
	RCALL lcd_write_instr
	LCD_WRITE_CHAR 'W'
	LCD_WRITE_CHAR 'O'
	LCD_WRITE_CHAR 'R'
	LCD_WRITE_CHAR 'L'
	LCD_WRITE_CHAR 'D'*/

	LDI R24, 0XC0
	LDI R24, 0X0C
	RCALL lcd_write_instr

read_key:
	CALL read_keyboard		;skriva siffror från tangentbord
	CP NO_PRESS, RVAL
	BREQ read_key
	MOV NO_PRESS, RVAL
	CPI RVAL, NO_KEY
	BREQ read_key
	CPI RVAL, 10
	BRGE AB
	SUBI RVAL, -48

write:
	RCALL lcd_write_chr		;få ut bokstäverna A och B
	RJMP read_key
	AB:
	SUBI RVAL, -55
	JMP write




	loop:
	RJMP loop







