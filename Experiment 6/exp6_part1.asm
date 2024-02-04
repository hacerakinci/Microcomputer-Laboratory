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

Start       mov.w	#numbers, R4
           	mov.b	#00000001b, R5

Mainloop    clr		P1OUT
			clr		P2OUT
			mov.b	0(R4), P1OUT
			mov.b	R5, P2OUT
        	add 	#1d, R4
        	cmp	#endOfNumbers, R4
			jeq	Start
           	rla	R5
			jmp	Mainloop

			.data
numbers		.byte	00111111b, 00000110b, 01011011b, 01001111b
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
            
