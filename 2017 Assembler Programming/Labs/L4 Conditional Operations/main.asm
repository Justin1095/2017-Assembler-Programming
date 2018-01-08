TITLE L04 - Conditional Operations

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to control the execution of the program with conditinal branching.
; Method: Enter the user's age and print a message telling the user if they are eligible to vote.
;	Voters must be at least 18 years old.
;

INCLUDE Irvine32.inc
.data 
age		DWORD 0		; value to test
prompt	BYTE "Please enter your age",0dh,0ah,0
yes		BYTE "You are old enough to vote.",0dh,0ah,0
no		BYTE "Sorry, you are not old enough to vote.",0dh,0ah,0
.code
main PROC
	mov edx,OFFSET prompt	; address of message
	call WriteString		; write prompt
	call ReadDec			; read number
	mov age,eax			; save value
;*** create the IF-THEN-ELSE to load the address of the message to print
	cmp age, 18
	jb else_branch 
	mov edx, OFFSET yes
	jmp end_if
else_branch:
	mov edx,OFFSET no
end_if:
	call WriteString		; write eligability message
	call WaitMsg
	exit
main ENDP
END main
