TITLE L12 - Bit Manipulation

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to use bit manipulation instructions.
; Method: The program is a postfix expression calculator. The student will add bit manipulation
;	instructions to the calculator.

INCLUDE Irvine32.inc
.data
message	BYTE "HEX POSTFIX CALCULATOR",0dh,0ah
		BYTE "  ~ Negate",0dh,0ah
		BYTE "  + Add",0dh,0ah
		BYTE "  - Subtract",0dh,0ah
		BYTE "  * Multiply",0dh,0ah
		BYTE "  / Divide",0dh,0ah
		BYTE "  ! Not",0dh,0ah
		BYTE "  & And",0dh,0ah
		BYTE "  | Or",0dh,0ah
		BYTE "  % Xor",0dh,0ah
		BYTE "All operands must be in lower case and adjacent operands should be seperated by a space.",0dh,0ah
		BYTE "A null (empty) line terminates the program.",0dh,0ah,0
prompt	BYTE "Enter postfix expression:",0dh, 0ah, 0
error	BYTE "Invalid expression.",0dh, 0ah, 0
done	BYTE TRUE		; Flag for done repeating
operand	BYTE FALSE		; Flag for operand on top of stack
digit	DWORD 16		; value of position
count	BYTE 0			; operands on stack

.code
main PROC
	mov edx,OFFSET message		; load address of message
	call WriteString			; write message
	.REPEAT
		mov done,TRUE				; set flat to quit
		mov count,0					; set empty stack
		mov operand,FALSE			; no value to start
		mov edx,OFFSET prompt		; load address of message
		call WriteString			; write message
		call ReadChar
		and eax,0ffh				; clear extraneous bits
		.WHILE al!=0dh
			call WriteChar			; echo character
			mov done,FALSE			; clear quit flag
			.IF al>='0' && al<='9'
				sub al,'0'			; convert to binary
				xor ebx,ebx			; clear regisgter
				mov bl,al			; save digit value
				.IF operand==TRUE
					pop eax			; load current operand value
					mul digit			; shift value
				.ELSE
					inc count		; increase number of operands on stack
					xor eax,eax		; clear register
				.ENDIF
				add eax,ebx			; add digit
				push eax			; save new operand value
				mov operand,TRUE	; flag beginning of operand
			.ELSEIF al>='a' && al<='f'
				sub al,'a'			; convert to binary
				add al,10
				xor ebx,ebx			; clear regisgter
				mov bl,al			; save digit value
				.IF operand==TRUE
					pop eax			; load current operand value
					mul digit			; shift value
				.ELSE
					inc count		; increase number of operands on stack
					xor eax,eax		; clear register
				.ENDIF
				add eax,ebx			; add digit
				push eax			; save new operand value
				mov operand,TRUE	; flag beginning of operand
			.ELSEIF al>='A' && al<='F'
				sub al,'A'			; convert to binary
				add al,10
				xor ebx,ebx			; clear regisgter
				mov bl,al			; save digit value
				.IF operand==TRUE
					pop eax			; load current operand value
					mul digit			; shift value
				.ELSE
					inc count		; increase number of operands on stack
					xor eax,eax		; clear register
				.ENDIF
				add eax,ebx			; add digit
				push eax			; save new operand value
				mov operand,TRUE	; flag beginning of operand
			.ELSEIF al=='~' ; Negate
				mov operand,FALSE	; flag end of operand
				pop eax
				neg eax				; perform operation
				push eax			; push result on stack
			.ELSEIF al=='+' ; Add
				mov operand,FALSE	; flag end of operand
				pop ebx				; load operands
				pop eax
				add eax,ebx			; perform operation
				push eax			; push result on stack
				dec count			; decrease number of operands on stack
			.ELSEIF al=='-' ; Subtract
				mov operand,FALSE	; flag end of operand
				pop ebx				; load operands
				pop eax
				sub eax,ebx			; perform operation
				push eax			; push result on stack
				dec count			; decrease number of operands on stack
			.ELSEIF al=='*' ; Multiply
				mov operand,FALSE	; flag end of operand
				pop ebx				; load operands
				pop eax
				mul ebx				; perform operation
				push eax			; push result on stack
				dec count			; decrease number of operands on stack
			.ELSEIF al=='/' ; Divide
				mov operand,FALSE	; flag end of operand
				pop ebx				; load operands
				pop eax
				.IF eax<0
					mov edx,-1		; extend sign
				.ELSE	
					mov edx,0		; extend sign
				.ENDIF
				div ebx				; perform operation
				push eax			; push result on stack
				dec count			; decrease number of operands on stack


			.ELSEIF al=='!' ; Not
				mov operand,FALSE	; flag end of operand
				pop eax
				not eax				; perform operation
				push eax			; push result on stack
; *** Implement the NOT operator (Hint: look at the NEGATE operator)

			.ELSEIF al=='|' ; Or
				mov operand,FALSE	; flag end of operand
				pop ebx				; load operands
				pop eax
				or eax,ebx			; perform operation
				push eax			; push result on stack
				dec count			; decrease number of operands on stack
; *** Implement the OR operator (Hint: look ath the ADDITION operator)

			.ELSEIF al=='&' ; And
				mov operand,FALSE	; flag end of operand
				pop ebx				; load operands
				pop eax
				and eax,ebx			; perform operation
				push eax			; push result on stack
				dec count
; *** Implement the And operator

			.ELSEIF al=='%' ; Exclusive OR
				mov operand,FALSE	; flag end of operand
				pop ebx				; load operands
				pop eax
				xor eax,ebx			; perform operation
				push eax			; push result on stack
				dec count
; *** Implement the Exclusive OR operator
			.ELSE
				mov operand,FALSE	; flag end of operand
			.ENDIF
			call ReadChar			; get next expression character
		.ENDW	
		call CrLf
		.IF count==1
			mov al,'='				; print separator
			call WriteChar
			pop eax					; print result
			call WriteHex
			call CrLf
		.ELSEIF count==0
		.ELSE
			mov edx,OFFSET error	; print error message
			call WriteString
		.ENDIF
;		call ReadChar				; get next character of expression		
	.UNTIL done==TRUE
	exit
main ENDP
END main
