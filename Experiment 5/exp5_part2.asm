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

Reset		mov.w	#letters, R4

Display		mov.b	0(R4), P1OUT
			call	#Delay
			add 	#1d, R4
			cmp		#endOfLetters, R4
			jeq		Reset
			jmp		Display

Delay		mov.w	#0Ah, R14
L2			mov.w	#07A00h, R15
L1			dec.w	R15
			jnz		L1
			dec.w	R14
			jnz		L2
			ret

			.data
letters		.byte 01110111b, 00111001b, 01110110b, 00110000b, 00111000b, 00111000b, 01111001b, 00111110b, 01101101b
endOfLetters

                                            

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
            
