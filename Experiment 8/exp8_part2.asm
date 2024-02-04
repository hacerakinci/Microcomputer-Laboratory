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


Setup	mov.b #0ffh, &P1DIR
		mov.b #0ffh, &P2DIR
		mov.b #00000000b, &P2SEL
		mov.b #00000000b, &P2SEL2
		clr.b &P1OUT
		clr.b &P2OUT
		clr	R8


                        ;implementation of the flow chart in the experiment document.
InitLCD                	mov &Delay100ms, R15 ;Wait 100ms
                        call #Delay

                        mov.b #00110000b, &P1OUT ;Send 0011
                        call #TrigEn
                        mov &Delay4ms, R15 ;Wait 4ms
                        call #Delay

                        call #TrigEn ;Send 0011
                        mov &Delay100us, R15 ;Wait 100us
                        call #Delay

                        call #TrigEn ;Send 0011
                        mov &Delay100us, R15 ;Wait 100us
                        call #Delay

                        mov.b #00100000b, &P1OUT ;Send 0010
                        call #TrigEn
                        mov &Delay100us, R15 ;Wait 100us
                        call #Delay

                        ;LCD is now in 4-bit mode, which means we will send our commands nibble by nibble.

                        mov.b #00100000b, &P1OUT ;Send 0010 1000
                        call #TrigEn
                        mov.b #10000000b, &P1OUT
                        call #TrigEn

                        mov &Delay100us, R15 ;Wait 53us+
                        call #Delay

                        mov.b #00000000b, &P1OUT ;Send 0000 1000
                        call #TrigEn
                        mov.b #10000000b, &P1OUT
                        call #TrigEn

                        mov &Delay100us, R15 ;Wait 53us+
                        call #Delay

                        mov.b #00000000b, &P1OUT ;Send 0000 0001
                        call #TrigEn
                        mov.b #00010000b, &P1OUT
                        call #TrigEn

                        mov &Delay4ms, R15 ;Wait 3ms+
                        call #Delay

                        mov.b #00000000b, &P1OUT ;Send 0000 0110
                        call #TrigEn
                        mov.b #01100000b, &P1OUT
                        call #TrigEn
                        mov &Delay100us, R15
                        call #Delay



MainLoop
    			clr R13
    			mov.b #00001111b, R13
    			call #SendCMD
    			mov &Delay50us, R15
    			call #Delay


Main		mov.b #00000001b, R13
			call #SendCMD
			mov &Delay2ms, R15
			call #Delay
			mov.w	&s , R8 ;R8 = R
			mov.w 	&q , R4
			mov.w	&p , R5
			call	#Multiply
			mov.w	  R6, R7 ;R7 = MOD
			mov.w  #0d, R11
			mov.w  #0d, R12
			mov.b	R8, R5
			clr R14
			mov #numbers, R10
			add	R8, R10
			mov.b 0(R10), R14
			call #SendData
			mov &Delay50us, R15
			call #Delay



timer_INT	mov.w	#0000001000010000b, TA0CTL
			mov.w	#10480000d, TA0CCR0
			mov.w	#0000000000010000b, TA0CCTL0
			clr		&TAIFG
			eint

BlumBlumShub
				mov.w		R8,R4
				mov.w	R8,R5
				call	#Multiply
				mov.w	R6,R5
				mov.w	R7,R4
				call	#Mod
				mov.w	R5,R8

Convertion		mov.b	#0d,R11
				mov.b	#0d,R12
Hundreds		cmp     #100d, R5
				jl	Tens
				sub	#100,R5
				inc.b    R11
				jmp 	Hundreds

Tens			cmp     #10d, R5
	        	jl	Loop
	        	sub.b   #10d, R5
	        	inc.b	R12
	        	jmp		Tens



Loop
			mov.b #00000001b, R13
			call #SendCMD
			mov &Delay2ms, R15
			call #Delay
			clr R14
			mov #numbers, R10
			add	R11, R10
			mov.b 0(R10), R14
			call #SendData
			mov &Delay50us, R15
			call #Delay
			mov #numbers, R10
			add	R12, R10
			mov.b 0(R10), R14
			call #SendData
			mov &Delay50us, R15
			call #Delay
			mov #numbers, R10
			add	R5, R10
			mov.b 0(R10), R14
			call #SendData
			mov &Delay50us, R15
			call #Delay
			ret



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

TrigEn		bis.b #01000000b, &P2OUT
			bic.b #01000000b, &P2OUT
			ret

SendCMD		mov.b R13, &P1OUT
			call #TrigEn
			rla R13
			rla R13
			rla R13
			rla R13
			mov.b R13, &P1OUT
			call #TrigEn
			ret


SendData	bis.b #10000000b, &P2OUT
			mov.b R14, &P1OUT
			call #TrigEn
			rla R14
			rla R14
			rla R14
			rla R14
			mov.b R14, &P1OUT
			call #TrigEn
			bic.b #10000000b, &P2OUT
			ret



Delay		dec.w R15
			jnz Delay
			ret


TISR	dint
		call #BlumBlumShub
		clr		&TAIFG
		eint
		reti





Delay50us	.word	011h
Delay100us	.word 	022h
Delay2ms	.word 	0250h
Delay4ms	.word 	0510h
Delay100ms	.word	07A10h




                                            
	.data

numbers	.byte	"0", "1", "2", "3","4", "5", "6","7", "8", "9"

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

            .sect	".int09"
			.short	TISR
            
