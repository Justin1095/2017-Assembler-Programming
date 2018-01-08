TITLE L07 - Floating Point

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to perform floating point operations.
; Method: Calculate the area of a triangle using floating point values and operations.
;	area=height*base/2

INCLUDE Irvine32.inc
.data
area		REAL8 ?		; result of calculation
base		REAL8 ?		; base of triangle
height		REAL8 ?		; height of triangle
two			REAL8 2.0		; constant
bprompt	BYTE "Enter the length of the base",0dh,0ah,0
hprompt		BYTE "Enter the height",0dh,0ah,0
result		BYTE "The area of the triangle is ",0

.code
main PROC
	finit					; initialize the floating point stack
	mov edx,OFFSET bprompt	; address of message
	call WriteString		; write base prompt
	call ReadFloat			; read length of base
	fstp base			; save base of figure
	mov edx,OFFSET hprompt	; address of message
	call WriteString		; write height prompt
	call ReadFloat			; read height
	fstp height			; save height of figure
;*** calculate area, storing it in area and leaving it on the top of the stack
	fld height			; load in height
	fmul base			; multiply height by base
	fdiv two			; divide by 2
	fst area			; load the result into area

	mov edx,OFFSET result	; address of message
	call WriteString		; write height prompt
	call WriteFloat
	call CrLf
	call WaitMsg
	exit
main ENDP
END main
