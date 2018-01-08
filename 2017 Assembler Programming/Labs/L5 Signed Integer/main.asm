TITLE L05 - Signed Integer

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to make a decision on signed integers.
; Method: Enter the temperature and print a message classifying the temperature.
;
;	The program is able to print one of three possible messages.
;	Correct use of signed conditional branch instructions.
;	Correctly adjust for different value sizes.

INCLUDE Irvine32.inc
.data 
reference	SWORD -273		; value to test against
;*** Do NOT change the declaration of "reference". "reference" MUST be an SWORD.
value		SDWORD 0	; value to test
prompt		BYTE "Enter an integer temperature",0dh,0ah,0
above		BYTE "Your temperature is above the absolute zero",0dh,0ah,0
equal		BYTE "Your temperature is equal to the absolute zero",0dh,0ah,0
below		BYTE "Your temperature is below the absolute zero",0dh,0ah,0

.code
main PROC
	mov edx,OFFSET prompt	; address of message
	call WriteString		; write prompt
	call ReadInt			; read temperature
	mov value,eax			; save value
;*** load signed reference value and convert to 32 bits
	movsx eax, reference	
	cmp eax,value			; compare against value

	jl above_branch			;jumps to above branch
	jg below_branch			;jumps to below branch
	mov edx, OFFSET equal	;prints equal message if it's not one of the two branches above
	jmp end_if

above_branch:				;above branch
	mov edx, OFFSET above	;prints above message
	jmp end_if

below_branch:				;below branch
	mov edx, OFFSET below	;prints below message
	jmp end_if
end_if:

;*** create a conditional structure to load message address
	call WriteString		; write eligability message
	call WaitMsg
	exit
main ENDP
END main
