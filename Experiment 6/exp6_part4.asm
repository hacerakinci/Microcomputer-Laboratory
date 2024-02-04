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

                                            
timer_INT		mov.w	#0000001000010000b, TA0CTL
				mov.w	#10486d, TA0CCR0
				mov.w	#0000000000010000b, TA0CCTL0
				clr	&TAIFG
				eint

init_INT		bis.b	#007h, &P2IE
			and.b	#0BFh, &P2SEL
			and.b 	#0BFh, &P2SEL2

			bis.b	#040h, &P2IES
			clr	&P2IFG
			eint


Setup_int 		mov.b #0d, R10 ; csecond
				mov.b #0d, R11 ; second
				mov.b	#11111111b, &P1DIR
				mov.b	#00000000b, &P1OUT
				mov.b	#00001111b, &P2DIR
            	mov.b   #0d, R12
            	mov.b   #0d, R13

Convertion    	cmp     #00001010b, R10
            	jl	Convertion2
            	sub.b   #00001010b, R10
            	inc.b	R12
            	jmp	Convertion
Convertion2    	cmp     #00001010b, R11
            	jl		Display1
            	sub.b   #00001010b, R11
            	inc.b	R13
            	jmp		Convertion2

Display1		clr		P1OUT
				clr		P2OUT
				mov.b	#00000001b, R6
				mov.w	#numbers, R7
				add		R12, R7
				mov.b	0(R7), P1OUT
				mov.b	R6, P2OUT

Display2		clr		P1OUT
				clr		P2OUT
				rla		R6
				mov.w	#numbers, R7
				add		R10, R7
				mov.b	0(R7), P1OUT
				mov.b	R6, P2OUT

Display3		clr		P1OUT
				clr		P2OUT
				rla		R6
				mov.w	#numbers, R7
				add		R13, R7
				mov.b	0(R7), P1OUT
				mov.b	R6, P2OUT

Display4		clr		P1OUT
				clr		P2OUT
				rla		R6
				mov.w	#numbers, R7
				add		R11, R7
				mov.b	0(R7), P1OUT
				mov.b	R6, P2OUT
				jmp 	Display1


ISR			dint
			cmp	#00000001, &P2IN
			jeq	start_T
			cmp	#00000010, &P2IN
			jeq	stop_T
			cmp	#00000100, &P2IN
			jeq	reset_T
start_T			mov 	#9999d, &TA0CCR0
			jmp	end_ISR
stop_T			mov 	#0d, &TA0CCR0
			jmp end_ISR
reset_T		mov #0d,R10
			mov #0d,R11
end_ISR		clr	&P2IFG
			eint
			reti



TISR		dint
			add #1d, R10
			cmp #99d, R10
			jl TISRend
addSec		add #1d, R11
			mov #0d, R10
			cmp #99d, R11
			jl TISRend
resetSec	mov #0d, R11
TISRend		clr		&TAIFG
			eint
			Reti


numbers		.byte	00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b,  01111111b,  01101111b
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
            .sect	".int09"
			.short	TISR
			.sect	".int03"
            .short	ISR
            
