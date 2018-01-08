TITLE L06 - Indefinite Loops

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to repeat operations and to
;	manipulate characters.
; Method: Enter the parameters of a line,
;	Enter the x coordinate and calculate the height of the line.
;	Repeat the calculation as needed.
;
; 	The Irvine looping directives may not be used.
;	Correct use of character values.

INCLUDE Irvine32.inc
.data

y			SDWORD ?	; result of calculation
m			SDWORD ?	; slope of line
x			SDWORD ?	; x coordinate
b			SDWORD ?	; y intercept
mprompt		BYTE "Enter the slope of the line",0dh,0ah,0
bprompt		BYTE "Enter the intercept of the line",0dh,0ah,0
xprompt		BYTE "Enter the x coordinate",0dh,0ah,0
error		BYTE "Overflow, calculation aborted",0dh,0ah,0
result		BYTE "Y=",0
continue	BYTE "Repeat for another coordinate? (y/n)",0dh,0ah,0
.code
main PROC
;	Enter slope
	mov edx,OFFSET mprompt		; address of prompt
	call WriteString			; write prompt
	call ReadInt				; read number
	mov m,eax					; save value
;	Enter intercept
	mov edx,OFFSET bprompt		; address of prompt
	call WriteString			; write prompt
	call ReadInt				; read number
	mov b,eax					; save value
    mov al, 'y'
;*** Initialize the loop by loading a character into AL (Do NOT read)

;*** Create a WHILE-DO loop based on the character in AL
while_loop:						
    cmp al, 'y'
	jne end_loop

;	Enter coordinate
	mov edx,OFFSET xprompt		; address of coordinate prompt
	call WriteString			; write prompt
	call ReadInt				; read number
	mov x,eax					; save value
	imul m						; multiply by slope of line

    jno else_branch				; test for overflow
	mov edx,OFFSET error		; address of error message
	call WriteString			; write message
	jmp end_if					; skip other branchmn

else_branch:					; continue calculation
	add eax,b					; add intercept
	mov y,eax					; save result
	mov edx,OFFSET result		; address of result message
	call WriteString			; write message
	mov eax,y					; reload result
	call WriteInt				; write result
	call CrLf					; terminate line
end_if:							; target of branch
	mov	edx,OFFSET continue		; address of prompt message
	call WriteString			; write message
	call readChar               ;*** Read the next character
	jmp while_loop
end_loop:
;*** Terminate the WHILE-DO loop

	call WaitMsg
	exit
main ENDP
END main
