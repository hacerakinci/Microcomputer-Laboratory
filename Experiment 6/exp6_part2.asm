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

                                            
Setup		bis.b	#11111111b, &P1DIR
			bis.b	#00000000b, &P1OUT
			bis.b	#00001111b, &P2DIR
        	mov.b   #49d, R4
        	mov.b   #0d, R5
			mov.b	#00001000b, R6

Convertion	cmp     #00001010b, R4
        	jl		Display1
        	sub.b   #00001010b, R4
        	inc.b	R5
        	jmp		Convertion

Display1	clr		P1OUT
			clr		P2OUT
			xor.b	#00001100b, R6
			mov.w	#numbers, R7
			add		R5, R7
			mov.b	0(R7), P1OUT
			mov.b	R6, P2OUT

Display2	clr		P1OUT
			clr		P2OUT
			xor.b	#00001100b, R6
			mov.w	#numbers, R7
			add		R4, R7
			mov.b	0(R7), P1OUT
			mov.b	R6, P2OUT
			jmp		Display1

			.data
numbers		.byte	00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b

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
            
