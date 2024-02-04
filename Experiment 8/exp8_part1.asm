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

init_INT	bis.b	#020h, &P2IE
			and.b	#0BFh, &P2SEL
			and.b 	#0BFh, &P2SEL2

			bis.b	#040h, &P2IES
			clr		&P2IFG
			eint

Main		mov.w	&s , R8 ;R8 = R
			mov.w 	&q , R4
			mov.w	&p , R5
			call	#Multiply
			mov.w	  R6, R7 ;R7 = MOD
			mov.w  #0d, R11
			mov.w  #0d, R12
			mov.b	R8, R5
			jmp	Display3

BlumBlumShub
				mov.w		R8,R4
				mov.w	R8,R5
				call	#Multiply
				mov.w	R6,R5
				mov.w	R7,R4
				call	#Mod
				mov.w	R5,R8
				jmp	Convertion ; R8 display


Mod			cmp	R4, R5
			jl	Return
			sub	R4, R5
			jmp	Mod


Multiply	mov 	#0d, R6

L2			cmp     #0d, R5
			jeq     Return
			sub 	#1d, R5
			add	  R4, R6
			jmp 	L2

Return 		ret

Convertion		mov.b	#0d,R11
				mov.b	#0d,R12
Hundreds		cmp     #100d, R5
				jl	Tens
				sub	#100,R5
				inc.b    R11
				jmp 	Hundreds

Tens			cmp     #10d, R5
	        	jl	Return
	        	sub.b   #10d, R5
	        	inc.b	R12
	        	jmp		Tens



Display3		clr		P1OUT
				clr		P2OUT
				mov.b	#00000010b, R6
				mov.w	#numbers, R13
				add		R11, R13
				mov.b	0(R13), P1OUT
				mov.b	R6, P2OUT

Display2		clr		P1OUT
				clr		P2OUT
				mov.b	#00000100b, R6
				mov.w	#numbers, R13
				add		R12, R13
				mov.b	0(R13), P1OUT
				mov.b	R6, P2OUT


Display1		clr		P1OUT
				clr		P2OUT
				mov.b	#00001000b, R6
				mov.w	#numbers, R13
				add		R5, R13
				mov.b	0(R13), P1OUT
				mov.b	R6, P2OUT
				jmp	Display3

ISR
			dint
			call #BlumBlumShub
			clr		&P2IFG
			eint
			reti


			.data
numbers		.byte	00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b

                                            
	.data
q	.word	11d
p	.word	13d
s	.word	5d

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
            
