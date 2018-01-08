TITLE NAME Homework 4 Definite Loops 

; Justin Seda 
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: 
; Description:This program calculate the integral of the function sin(x) using the trapezoidal rule.


INCLUDE Irvine32.inc
.data
start		REAL8	?		;the starting x coordinate 
final		REAL8	?		;the final  x coordinate 
result		REAL8	?		;the answer of user's input
intro			BYTE "Hello, this program finds the integral of sin(x) by using the trapezoidal rule",0dh,0ah,0		;introduces user to the program and states the use of the program
outputStart		BYTE "Please input the starting x coordinate: ",0dh,0ah,0										;ask for the starting x coordinate
outputEnd		BYTE "Please enter the final x coordinate: ",0dh,0ah,0											;ask for the final x coordinate
outputResult    BYTE "The result is  ", 0															;gives the user the results 
space			BYTE " ", 0dh,0ah,0																	;add a space
.code
main PROC

; PLACE SOURCE CODE HERE
repeatLoop:
	finit						;initialize the floating point stack	
	mov edx,OFFSET intro		;introduces user to the program and states the use of the program
	call WriteString 

	mov edx,OFFSET outputStart		;ask for the starting x coordinate
	call WriteString 
	call ReadFloat		;read number
	fstp start			;loading top of stack into start variable

	mov edx,OFFSET outputEnd		;ask for the ending x coordinate
	call WriteString 
	call ReadFloat		;read number
	fstp final			;Loading top of stack into final variable

	push OFFSET start	; call subroutine
	push OFFSET final	
	push OFFSET result
	call sec_main		;call sec_main Parameter

	mov edx,OFFSET outputResult		;prompts the outputResult
	call WriteString
	fld result			;loads result
	call WriteFloat
	call CrLf

	mov edx,OFFSET space		;adds a space
	call WriteString
	jmp repeatLoop		;jumps to repeatLoop

	call WaitMsg
	exit 
main ENDP


.data
two				REAL8		2.0			;constant
half			REAL8		0.50		;constant
x				REAL8		?			;x coordinate
y				REAL8	    ?			;y coordinate
thousand		REAL8		1000.00		;thousand
actualThousand  DWORD		997			;the real thousand

f				REAL8		?			;function parameter
f1				REAL8		?			;function parameter
f2				REAL8		?			;function parameter

.code
sec_main PROC

PARAMS = 2*TYPE DWORD		
NPARAMS = 3
$result = PARAMS+0
$final = PARAMS+4
$start = PARAMS+8

	pushfd
	mov ebx, DWORD PTR $final [esp]		;load address of parameter
	fld REAL8 PTR [ebx]					;loads final
	mov ebx, DWORD PTR $start [esp]		;load address of parameter
	fld REAL8 PTR [ebx]					;loads start
	fsub								;substract
	fdiv thousand						;divides
	fst y								
	fstp x								;loading top of stack into x variable

	mov ebx, DWORD PTR $start [esp]		;load address of parameter
	fld REAL8 PTR [ebx]					;loads start
	fsin								;calculate sin
	fstp f								;loading top of slack into f

	mov ebx, DWORD PTR $final [esp]		;load address of parameter
	fld REAL8 PTR [ebx]					;loads final
	fld x								;loads x
	fadd								;add
	fsin								;calculate sin
	fstp f1								;loading top of slack into f1

	mov ebx, DWORD PTR $start [esp]		;load address of parameter
	fld REAL8 PTR [ebx]					;loads start
	fld x								;loads x
	fadd								;add
	fsin								;calculate sin
	fld two								;loads two
	fmul								;multiply
	fstp f2								;loading top of slack into f2

	fldz
	mov ecx, actualThousand				

mainLoop:								;the main for loop
	fld y								;loads y
	fld x								;loads x
	fadd								;add
	fst y					

	mov ebx, DWORD PTR $start [esp]		;load address of parameter
	fld REAL8 PTR [ebx]					;loads start
	fadd								;add
	fsin								;calculate sin
	fld two								;loads two
	fmul								;multiply
	fadd								;add
	cmp ecx, 0							;compares
	je loopFinished						; jump to loopFinished
	dec ecx
	jmp mainLoop						;jump to mainLoop

loopFinished:							;the end loop
	fld f								;loads f						
	fadd								;add
	fld f1								;loads f1
	fadd								;add
	fld f2								;loads f2
	fadd								;add
	fld x								;loads x
	fld half							;load half
	fmul								;multiply
	fmul								;multiply
	mov ebx, DWORD PTR $result[esp]		;load address of parameter
	fstp REAL8 PTR [ebx]				;loads result
	popfd								;restore flags
	ret NPARAMS*TYPE SDWORD				;return and pop parameters

sec_main ENDP
; PLACE ADDITIONAL PROCEDURES HERE
END main
