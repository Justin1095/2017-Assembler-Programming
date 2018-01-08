TITLE L14 - Arrays 

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to use an array.
; Method: Compute the sum of a list of numbers

INCLUDE Irvine32.inc
.data
list REAL8 100 DUP(?) ; array of numbers
len DWORD 0 ; number of numbers in array
nextPrompt BYTE "Enter next number to add to array (zero to terminate)",0
sumMessage BYTE "Sum: ",0

.code
main PROC
finit ; initialize floating point processor
; demonstrate accessing array by offset to value
	xor edi,edi ; clear for index of first number
.REPEAT
	mov edx,OFFSET nextPrompt ; load address of prompt
	call WriteString ; print prompt
	call CrLf
	call ReadFloat ; read number
	fldz
	fcomip st(0),st(1) ; check for termination
	je doneLoad ; terminate load
	fstp list[edi] ; store number in list
	add edi,TYPE REAL8 ; point to next number in array
	.UNTIL edi==LENGTHOF list
doneLoad:
	mov eax,edi ; convert offset to number of items in list
	xor edx,edx
	mov ebx,TYPE REAL8
	div ebx
	mov len,eax ; save length of array
; compute the sum of the values
	mov ecx,len ; load count of items
	xor edi,edi
	fldz 
sumRepeat:
	fadd list[edi]
	add edi, TYPE REAL8 
	loop sumRepeat ; repeat for rest of array
	mov edx,OFFSET sumMessage ; print a message showing sum
	call WriteString
	call WriteFloat ; print number
	call CrLf ; terminate line
	call WaitMsg
exit
main ENDP
END main

