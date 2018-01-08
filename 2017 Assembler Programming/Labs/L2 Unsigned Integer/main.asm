TITLE L02 - Unsigned Integer

; Justin Seda
; YOUR SECTION
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to perform calculations using unsigned integers,
;	ignoring the possibility of overflow.
;
; Method: Compute the area of a trapezoid producing a 32 bit result.
;	area =(top+bottom)*height/2
;
;	The result must be in the standard registers for division.
;	Store the whole part of the answer in a variable.
;	All values must be unsigned integers.
;	The result must be a positive, unsigned numbers.
;	Direct addressing is required for all shape parameters.
;	Immediate addressing may be used for formula constants.

INCLUDE Irvine32.inc
.data
;*** Declare 32 bit variables for all quantities named in the formula.
top		dword	10		; top of trapezoid 
base	dword	20		; base of trapezoid
height	dword	8		; height of trapezoid


.code
main PROC
	;*** Calculate the area.
	;*** NOTE: Division requires special initialization.
	mov		eax, top	;initialize eax with top
	add		eax, base	;initialize eax with base
	mul		height		;multipuly by height
	mov		ecx, 2		;initiailize ecx with 2
	div		ecx			;divide by 2

	call DumpRegs
	call WaitMsg
	exit
main ENDP
END main
