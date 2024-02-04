;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer
			mov.b	#0d, P2SEL


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------

Setup		mov.b	#11111111b, &P1DIR
			mov.b	#00000000b, &P1OUT
			mov.b	#00001111b, &P2DIR
			mov.b	#00000001b, &P2OUT
			mov.b	#mode, R6
			mov.b	#001h, (R6)
			mov.b	#0d, R7

init_INT	bis.b	#040h, &P2IE
			and.b	#0BFh, &P2SEL
			and.b 	#0BFh, &P2SEL2

			bis.b	#040h, &P2IES
			clr		&P2IFG
			eint

Reset		mov.w	#letters, R4
			mov.w	#numbers, R5

ResetForChange
			mov.w	#letters, R4
			mov.w	#numbers, R5
			mov.b	#0d, R7
			jmp 	Control

Control		cmp		#004h, (R6)
			jeq 	resetMode
			cmp		#1d, R7
			jeq		ResetForChange
			cmp		#001h, (R6)
			jeq		Display1
			cmp		#002h, (R6)
			jeq		Display2
			cmp		#003h, (R6)
			jeq		Display3
			jmp		Control

Display1	mov.b	0(R4), P1OUT
			call	#Delay
			add		#1d, R4
			cmp		#endOfLetters, R4
			jeq		Reset
			jmp		Control

Display2	mov.b	0(R5), P1OUT
			call	#Delay
			add		#1d, R5
			cmp		#endOfNumbers, R5
			jeq		Reset
			jmp		Control

Display3	mov.b	0(R5), P1OUT
			call	#Delay
			add		#1d, R5
			mov.b	0(R4), P1OUT
			call	#Delay
			add		#1d, R4
			cmp		#endOfLetters, R4
			jeq		Reset
			jmp		Control

Delay		mov.w	#0Ah, R14
L2			mov.w	#07A00h, R15
L1			dec.w	R15
			jnz		L1
			dec.w	R14
			jnz		L2
			ret

ISR			dint
			add		#1d, (R6)
			inc.b	R7
			clr		&P2IFG
			eint
			reti


resetMode	mov.b	#001h, (R6)
			jmp 	Control

			.data

numbers		.byte	00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b,  01111111b,  01101111b
endOfNumbers

letters		.byte	01110111b, 00111001b, 01110110b, 00110000b, 00111000b, 00111000b, 01111001b, 00111110b, 01101101b
endOfLetters

mode		.space	1
                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            .sect	".int03"
            .short	ISR
            
