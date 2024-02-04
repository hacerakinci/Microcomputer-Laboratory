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



Main		mov		#9d, R4
			push 	R4
			mov		#3d, R5
			push	R5
			call 	#Division
			;call	#Multiply
			mov		#2d, R10
			mov		#3d, R11
			push	R10
			push	R11
			call	#Power

Multiply	pop 	R13; return address
			pop		R5
			pop		R4
			push    R13
			mov 	#0d, R6
L2			cmp     #0d, R5
			jeq     Return
			sub 	#1d, R5
			add	  	R4, R6
			jmp 	L2

Power		pop		R13
			pop     R8
			pop 	R7
			push	R13
			push 	#1d
mul			cmp 	#0, R8
			jeq		Return
			push 	R7
			sub 	#1d, R8
			call 	#Multiply
			jmp 	mul

Division	pop 	R13; return address
			pop		R5
			pop		R4
			push    R13
			mov 	#0d, R6
L1			cmp     R5, R4
			jlo     Return
			sub  	R5, R4
			add     #1d, R6
			jmp 	L1


Return 		ret






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
            
