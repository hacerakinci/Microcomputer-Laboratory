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
setup		mov.w	#1d, R8 ;iteration
			mov.w	#arr, R12 ;array
			mov.b	#0d, R10 ;count
			mov.w	#0d, R13
			mov.w	#arr2, R14 ;array2

mainloop1	mov.w	R8, R6
			mov.w	#3d, R7
			jmp		modulo

mainloop2	mov.w	R8, R6
			mov.w	#4d, R7
			jmp		modulo

check		cmp		#0d, R6
			jeq		load
			cmp		#4d, R7
			jeq		iterate
			jmp		mainloop2

load		mov.w	R8, 0(R12)
			inc		R10
			cmp		#50d, R10
			jeq		reverse
			add		#2d, R12
			jmp		iterate

iterate		inc		R8
			jmp		mainloop1

modulo		sub		R7, R6
			cmp		R7, R6
			jge		modulo
			jl		check

reverse		mov.w	0(R12), R11
			mov.w	R11, 0(R14)
			inc		R13
			cmp 	#50d, R13
			jeq 	end
			sub		#2d, R12
			add		#2d, R14
			jmp		reverse

end			jmp		end

		.data
arr		.space	100

		.data
arr2 	.space 100
                                            

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
            
