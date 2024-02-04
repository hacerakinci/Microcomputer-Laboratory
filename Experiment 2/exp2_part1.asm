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
;Sevim Eftal Akşehirli - 150190028
;Hacer Yeter Akıncı - 150200007
;Büşra Özdemir - 150200036
;Aslı Yel -150200054


Setup
		bis.b   #00000000b, &P2DIR
		bis.b   #00000000b, &P2IN
        mov.b   #00000000b, R6
        mov.w 	#05000000, R15

MainLoop
		bit.b  #00000001b, &P2IN
		jne Increment
		jmp MainLoop

Increment
		inc R6
		mov.w #05000000, R15
		jmp Debounce

Debounce
		dec.w R15
		jnz Debounce
		jmp MainLoop
                                            

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
            
