TITLE L03 - Subroutine Calls & IO

;Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to call Irvine routines and perform I/O.
; Method: Prompt for the user's height. Enter the height and print a message containing the height.
;
;	The text and number of the message must be displayed on the same line.
;	All values must be unsigned integers.
;	The Irvine routine CRLF may not be used.


INCLUDE Irvine32.inc
.data
;*** Declare an unsigned, integer variable for the value
;*** Declare the prompt and message parts

height DWORD 0													;Declare an unsigned integers
message BYTE "Enter your height in inches: ", 0dh, 0ah, 0		;The prompt  
lEnd BYTE 0dh, 0ah, 0											;Ends the line
inputHeight BYTE "Your height is: ", 0							;Output message
.code

main PROC
	;*** print the prompt for the user's height in inches
	;*** read user's height and store it in a variable
	;*** print first part of message
	;*** print user's height
	;*** optionally you may print additional text
	;*** print end of line
	;*** NOTE: DumpRegs is not permitted in this program.

		mov edx, OFFSET message     ;ask for user's height in inches
		call WriteString
		call ReadDec				;read height and store it
		mov height, eax	
		mov edx, OFFSET InputHeight	
		call WriteString			;print first part of output message		
		call WriteDec				;print user's height
		mov edx, OFFSET lEnd		;Ends the line

		call WaitMsg			   ; wait for user to read results
		exit
	main ENDP
	END main