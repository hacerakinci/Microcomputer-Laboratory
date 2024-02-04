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

Setup		mov.b #0ffh, &P1DIR
			mov.b #0ffh, &P2DIR
			mov.b #00000000b, &P2SEL
			mov.b #00000000b, &P2SEL2
			clr.b &P1OUT
			clr.b &P2OUT


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

                        ;initialization is over. Now we will start sending data to our LCD display


MainLoop
				clr	R9
				clr R8
    			clr R5
    			mov.b #00001100b, R5
    			call #SendCMD
    			mov &Delay50us, R15
    			call #Delay
    			mov.b #00000010b, R5
    			call #SendCMD
    			mov &Delay50us, R15


    			mov #string, R7

Loop
   				clr R6
   				mov.b #00000001b, R5
				mov &Delay2ms, R15
    			mov.b @R7, R6
    			mov.b R9, R10
    			call #shift
    			call #SendData
    			mov &Delay100ms, R15
    			call #Delay
    			mov &Delay100ms, R15
    			call #Delay
    			mov &Delay100ms, R15
    			call #Delay
    			mov &Delay100ms, R15
    			call #Delay
    			mov &Delay100ms, R15
    			call #Delay

    			inc.b R9
				mov.b #00000001b, R5
				call #SendCMD
				mov &Delay100ms, R15
				call #Delay
				mov &Delay100ms, R15
				call #Delay
    			cmp	#16d, R9
    			jeq	Fin
    			cmp #0b, R8
    			jeq	YeniSatir
    			jmp	Satir

shift		cmp	#0d, R10
			jeq	return
			mov	#00010100b, R5 ;mov.b #00000111b, R5	;mov	#00010100b, R5 veya mov	#00011100b, R5
			call #SendCMD
			mov &Delay50us, R15
			call #Delay
			dec	R10
			jmp	shift

return		ret

YeniSatir  	clr R5
			mov.b #11000000b, R5
			call #SendCMD
			mov &Delay50us, R15
			call #Delay
			mov.b	#1b, R8
			jmp Loop

Satir  		clr R5
			mov.b #10000000b, R5
			call #SendCMD
			mov &Delay50us, R15
			call #Delay
			;mov	#00010100b, R5
			;call #SendCMD
			;mov &Delay50us, R15
			;call #Delay
			mov.b	#0b,	R8
			jmp Loop

Fin			jmp MainLoop





TrigEn		bis.b #01000000b, &P2OUT
			bic.b #01000000b, &P2OUT
			ret

SendCMD		mov.b R5, &P1OUT
			call #TrigEn
			rla R5
			rla R5
			rla R5
			rla R5
			mov.b R5, &P1OUT
			call #TrigEn
			ret

SendData	bis.b #10000000b, &P2OUT
			mov.b R6, &P1OUT
			call #TrigEn
			rla R6
			rla R6
			rla R6
			rla R6
			mov.b R6, &P1OUT
			call #TrigEn
			bic.b #10000000b, &P2OUT
			ret

Delay		dec.w R15
			jnz Delay
			ret




			.data
string		.byte "*" ;string to be written to the LCD


Delay50us	.word	011h
Delay100us	.word 	022h
Delay2ms	.word 	0250h
Delay4ms	.word 	0510h
Delay100ms	.word	07A10h


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
            
