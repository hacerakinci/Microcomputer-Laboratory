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
result		.bss	resultArray	,5
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

Setup		mov		#array, r5
			mov 	#resultArray, r10

Mainloop	mov.b	@r5, r6
			inc		r5
			call	#func1
			mov.b	r6, 0(r10)
			inc		r10
			cmp		#lastElement, r5
			jlo		Mainloop
			jmp		finish

func1		dec.b	r6
			mov.b	r6, r7
			call	#func2
			mov.b	r7, r6
			ret

func2		xor.b	#0FFh, r7
			ret

;Integer array,
array	.byte	1, 0, 127, 55
lastElement

finish		nop

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
            
