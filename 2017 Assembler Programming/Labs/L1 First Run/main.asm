TITLE L01 - First Run

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to manipulate 4 unsigned integers
;
; Method: Write a program to add/subtract a series of values.
;	Included both addition and subtraction instructions.
;	The number of MOV, ADD and SUB instructions must be exactly 4.
;	All values must be unsigned integers.
;	The result must be a positive, unsigned number.
;	One of the values must be greater than 16 bits.
;	Immediate addressing is required for all values.
;	The result must be in the EAX register.

INCLUDE Irvine32.inc
.data

.code
main PROC
	mov eax, 10000
	add eax, 65000
	add eax, 3200
	sub eax, 20000
	call DumpRegs
	call WaitMsg
	exit
main ENDP
END main
