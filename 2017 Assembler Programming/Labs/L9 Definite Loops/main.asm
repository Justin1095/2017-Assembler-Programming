TITLE L09 - Definite Loops

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to use a definitine loop.
; Method: The program will accept the parameters of an 
;	arithmetic sequence and calculate the specified term.
;	The Irvine looping directives may not be used.

INCLUDE Irvine32.inc
.data
first		SDWORD ? ; first of pair of values
second		SDWORD ? ; second of pair of values
; Note: seeds 0,1 produce the Fibanocci Sequence
number		DWORD ?	; value to test
prompt0		BYTE "Enter number number of sequence to generate (0 to terminate):",0dh,0ah,0
prompt1		BYTE "Enter first seed:",0dh,0ah,0
prompt2		BYTE "Enter second seed:",0dh,0ah,0
message	BYTE "The number is ",0

.code
main PROC
next:
	mov edx,OFFSET prompt0	; address of message for term to generate
	call WriteString		; write message
	call ReadDec			; read number
	cmp eax,0				; test if done series of numbers
	je quit					; exit if done
	mov number,eax			; save term number
	mov edx,OFFSET prompt1	; address of message for seeds
	call WriteString		; write message
	call ReadInt			; read number
	mov first,eax			; save first seed
	mov edx,OFFSET prompt2	; address of message for seeds
	call WriteString		; write message
	call ReadInt			; read number
	mov second,eax			; save second seed
	mov ecx,number			; load counter
	cmp ecx,1				; test for 1st term in sequence
	je end_for					; exit if 1st term
	mov eax,first			; load first seed
	cmp ecx,0				; text if 0th term in sequence
	je end_for					; exit if 0th term
	dec ecx					; adjust counter to skip 1st term
;*** Create a counted loop for the instructions between the labels for_loop and end_for
for_loop:
	mov eax,first			; load first of pair
	mov ebx,second			; load second of pair
	add eax,ebx				; add pair
	mov first,ebx			; set new first
	mov second,eax			; set new second
	LOOP for_loop
end_for:
	mov edx,OFFSET message	; address of result message
	call WriteString		; write message
	mov eax,second			; load number generated
	call WriteInt			; write number
	call CrLf				; output end of line
	jmp next				; repeat for another number

quit:
	call WaitMsg
	exit
main ENDP
END main
