TITLE NAME Homework 3

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Assignment: Floating Point
; Description: This program is suppose to prompt the user to enter the millivolts from a K type thermocouple and find it's result.


INCLUDE Irvine32.inc
.data
; PLACE DATA DIRECTIVES HERE
input REAL8		?			;user's input
result REAL8	?			;gets the answer
acceptable REAL8 20.644		;making sure that the input doesn't go above 20.644

;used for horner’s rule
a10 REAL8	0.000000E+00		;a10
a9 REAL8   -1.052755E-08		;a9
a8 REAL8	1.057734E-06		;a8
a7 REAL8   -4.413030E-05		;a7
a6 REAL8	9.804036E-04		;a6
a5 REAL8   -1.228034E-02		;a5
a4 REAL8	8.315270E-02		;a4
a3 REAL8   -2.503131E-01		;a3
a2 REAL8	7.860106E-02		;a2
a1 REAL8	2.508355E+01		;a1
a0 REAL8	0.000000E+00		;a0

intro BYTE "Hello, please enter the millivolts from a K type thermocouple: ",0dh,0ah,0					;introduces user to the program and ask for the millivolts from a K type thermocouple
output BYTE "Your result is: ", 0																		;outputs the results of user's input 
space BYTE " ", 0dh,0ah,0																				;add a space between the output message and endProgram message
endProgram BYTE "If you would like to end the program, enter a negative number in the prompt below" ,0dh,0ah,0	;tells user to input a negative number to end the program
.code
main PROC

; PLACE SOURCE CODE HERE
repeatLoop:
	mov edx,OFFSET intro		;displays the intro message
	call WriteString 
	call ReadFloat		;read in user's input 

	fst input		;copies input on the top of the stack
	fld acceptable		;loads in 20.644 
	FCOMP		;compares input to acceptable
	FNSTSW ax
	SAHF
	jb program_end		;if it's invalid, then it ends the program
	ja loopOne			;if it's valid, goes into the loop

loopOne:
	fldz
	FCOMP		;compares again
	FNSTSW ax
	SAHF
	jb loopSec		;goes to next loop
	ja program_end	;ends program

loopSec:
;uses horner’s rule to get the answer of what the user input


	fld a10		;loads a10
	fmul		;multiply a10
	fld a9		;loads a9
	fadd		;adds a9
	fld input	;loads the input
	fmul		;multiply input	 
	fld a8		;loads a8
	fadd		;adds a8

	fld input	;loads the input
	fmul		;multiply input
	fld a7		;loads a7
	fadd		;adds a7
	fld input	;loads the input
	fmul		;multiply input
	fld a6		;loads a6
	fadd		;adds a6

	fld input	;loads the input
	fmul		;multiply input
	fld a5		;loads a5
	fadd		;adds a5
	fld input	;loads the input
	fmul		;multiply input
	fld a4		;loads a4
	fadd		;adds a4

	fld input	;loads the input
	fmul		;multiply input
	fld a3		;loads a3
	fadd		;adds a3
	fld input	;loads the input
	fmul		;multiply input
	fld a2		;loads a2
	fadd		;adds a2

	fld input	;loads the input
	fmul		;multiply input
	fld a1		;loads a1
	fadd		;adds a1

	fld input	;loads the input
	fmul		;multiply input
	fst result	;stores answer in results


	mov edx, OFFSET output		;displays the output message
	call WriteString
	call WriteFloat		;displays the result
	mov edx, OFFSET space		;adds the space inbetween the sentences
	call WriteString
	mov edx, OFFSET endProgram		;display the endProgram message, tell the user how to end the program
	call WriteString
	call crlf
	jmp repeatLoop	;jumps back to the beginning 

program_end:		;ends the program
	call WaitMsg
	exit

main ENDP
; PLACE ADDITIONAL PROCEDURES HERE
END main