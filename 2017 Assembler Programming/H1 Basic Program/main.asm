TITLE NAME Homework 1

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming 
; Prof. James W. Emert
; Assignment: Basic Program
; Description: This program is suppose to output the volume of a cylinder for the user's radius and height.


INCLUDE Irvine32.inc
.data
; PLACE DATA DIRECTIVES HERE
height WORD 0
rad BYTE 0		;radius
prod DWORD 0	;product of radius times radius time height
rem DWORD 0		;remainder
messageR BYTE "This program finds the volume of a cylinder, please input the radius: ", 0dh, 0ah, 0		 ;messageR is the prompt for radius 
messageH BYTE "Please input the height: ", 0dh, 0ah, 0		 ;messageH is the prompt for height
outputV BYTE "The volume of the user's cylinder is: ", 0dh, 0ah, 0	 ;outputs the volume of the cylinder
outputR BYTE " with a remainder of ", 0						 ;outputs the remainder
RemNum BYTE "/7 ", 0dh, 0ah, 0							 ;outputs divided by seven for the remainder
.code
main PROC

; PLACE SOURCE CODE HERE
	mov edx,OFFSET messageR		;prompts radius message
	call WriteString
	call ReadDec
	mov rad, al		;save the radius value
	mul rad
	mov rad, al		; times radius by radius

	mov edx, OFFSET messageH	;prompts height message
	call WriteString
	call ReadDec
	mov height, dx		; save the height value
	mul rad 

	mov WORD PTR prod, dx		;gets height
	mov WORD PTR prod, ax		;gets the radius, puts both into the product
	mov prod, eax
	mov eax, prod
	mov edx, 22
	mul edx			;times the product by 22
	mov prod, eax

	mov ecx, 7
	div ecx		;divides by 7
	mov rem, edx

	mov edx, OFFSET outputV;		;outputs the volume of the cylinder
	call WriteString
	call WriteDec
	mov edx, OFFSET outputR ;		;outputs the remainder
	call WriteString
	mov eax, rem					;displays the remainder
	call WriteDec
	mov edx, OFFSET RemNum	;outputs divided by seven
	call WriteString
	call WaitMsg
	exit
main ENDP
; PLACE ADDITIONAL PROCEDURES HERE
END main