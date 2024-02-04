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

init_INT	bis.b	#040h, &P2IE
			and.b	#0BFh, &P2SEL
			and.b 	#0BFh, &P2SEL2
			bis.b	#040h, &P2IES
			clr		&P2IFG
			eint

ResetCounter
			mov.b	#0d, R5	;push counter
			mov.w	#numbers, R4
			jmp		Display

Reset		mov.w	#numbers, R4

Display		mov.b	0(R4), P1OUT
			call	#Delay
			add		#1d, R4
			cmp 	#5d, R5
			jeq		ResetCounter
			cmp		#endOfNumbers, R4
			jeq		Reset
			bit.b	#00000001, R5
			jne		Pause
			jmp		Display

Delay		mov.w	#0Ah, R14
L2			mov.w	#07A00h, R15
L1			dec.w	R15
			jnz		L1
			dec.w	R14
			jnz		L2
			ret

Pause		bit.b	#00000001, R5
			jeq		Display
			jmp		Pause

ISR			dint
			add		#1d, R5
			clr		&P2IFG
			eint
			reti


			.data

numbers		.byte	00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b,  01111111b,  01101111b
endOfNumbers

                                            

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
            
