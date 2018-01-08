TITLE L19 - Recursion

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to use recursion.
; Method: Find the Greatest Common Divisor recursively.
;	gcd(a,0)=a
;	gcd(a,b)=gcd(b,a mod b)

INCLUDE Irvine32.inc
include macros.inc
.data
value1	DWORD ?	; first value to test for gcd
value2	DWORD ?	; second value to test for gcd
divsr	DWORD ?	; divisor
gcd	PROTO num1:DWORD, num2:DWORD, divisor:PTR DWORD
.code
main PROC
	.REPEAT
		mWrite "Enter two numbers(0 to stop)"
		call ReadDec
		cmp eax,0
		je done ; quit if number negative
		mov value1,eax
		call ReadDec
		cmp eax,0
		je done ; quit if number negative
		mov value2,eax
		INVOKE gcd, value1, value2, OFFSET divsr
		mWrite "Divisor:"
		mov eax,divsr	; print index of number
		call WriteDec
		call CrLf
	.UNTIL SIGN?
done: call WaitMsg	; hold display window open
	exit
main ENDP
gcd	PROC uses eax ebx ecx edx, num1:DWORD, num2:DWORD, divisor:PTR DWORD
; calculate the greatest common denominator of a pair of numbers
; Receives from stack
;	num1, num2 = numbers to test
; Returns:
;	divisor=greatest common divisor
NPARAMS = 3
;*** calculate gcd
mov ebx, divisor
mov eax, num1
.IF num2 == 0
mov DWORD PTR [ebx], eax
.ELSE
xor edx, edx
mov eax, num1
div num2
mov DWORD PTR [ebx], edx 
INVOKE gcd, num2, edx, divisor
.ENDIF
	ret NPARAMS*TYPE DWORD	; return and pop parameters
gcd	ENDP
END main