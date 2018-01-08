TITLE L11 - Strings

;Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to use string instructions.
; Method: The program will use two subroutines. 
;	The first will initialize a buffer to a constant value.
;	The second will copy characters from one buffer to another.

INCLUDE Irvine32.inc
.data
value		BYTE 0
buffer1		BYTE 100 DUP(0) ; first buffer
buffer2		BYTE 100 DUP(0) ; second buffer
prompt1		BYTE "Enter character to initialize buffer:",0dh,0ah,0
prompt2		BYTE "Enter string (null to terminate):",0dh,0ah,0
message1	BYTE "Buffer 1:",0dh,0ah,0
message2	BYTE "Buffer 2:",0dh,0ah,0

.code
main PROC
next:
; initialize buffer
	mov edx,OFFSET prompt1	; address of string prompt
	call WriteString		; write message
	call ReadChar			; read initalization character
	mov value,al			; save value
	mov eax,0				; pass init character
	mov al,value
	push eax
	push OFFSET buffer1		; pass address of buffer
	push SIZEOF buffer1		; pass size of buffer
	call init				; initialize buffer
	mov edx,OFFSET message1	; load address first buffer message
	call WriteString		; write message
	mov esi,OFFSET buffer1	; pass address of first buffer
	mov ecx,SIZEOF buffer1	; pass size of first buffer
	mov ebx,TYPE BYTE		; pass size of data
	call DumpMem			; dump buffer contents
; enter string into buffer
	mov edx,OFFSET prompt2	; address of string prompt
	call WriteString		; write message
	mov edx, OFFSET buffer1	; load address of string to read
	mov ecx, SIZEOF buffer1	; size of string
	call ReadString			; read number
	cmp eax,0				; check for null string
	je done					; quit for null string
	mov edx,OFFSET message1	; load address first buffer message
	call WriteString		; write message
	mov esi,OFFSET buffer1	; pass address of first buffer
	mov ecx,SIZEOF buffer1	; pass size of first buffer
	mov ebx,TYPE BYTE		; pass size of data
	call DumpMem			; dump buffer contents
; copy first buffer to second
	push OFFSET buffer2		; pass address of second buffer
	push OFFSET buffer1		; pass address of first buffer
	push SIZEOF buffer1		; pass size of first buffer
	call move				; move data from first buffer to second
	mov esi,OFFSET buffer2	; pass address of first buffer
	mov ecx,SIZEOF buffer2	; pass size of first buffer
	mov ebx,TYPE BYTE		; pass size of data
	call DumpMem			; dump buffer contents
;
	jmp next				; repeat for next pair
done:
	call WaitMsg
	exit
main ENDP
init	PROC
; Initialize a buffer
; Receives from stack
;	len = length of buffer [DWORD value parameter]
;	buf = buffer [BYTE reference parameter]
;	val = value to store in buffer [BYTE value parameter] (occupies full double word on stack)
; Returns: nothing
PARAMS	= (5+1)*TYPE DWORD ; number of temporaries plus return address
NPARAMS = 3
len = PARAMS + 0*TYPE DWORD
buf = PARAMS + 1*TYPE DWORD
val = PARAMS + 2*TYPE DWORD
	pushfd
	push eax
	push ebx
	push ecx
	push edi
;*** Store initialization value into buffer using block string instruction
;*** Don't forget to set direction.
;*** WARNING: The parameters for this instruction and the other one are different.

	cld
	mov ecx, len[esp]
	mov edi, buf[esp]
	mov al, val[esp]
	rep stosb
	 
	pop edi
	pop ecx
	pop ebx
	pop eax
	popfd
	ret NPARAMS*TYPE DWORD	; return and pop parameters
init	ENDP
move	PROC
; Move string from one buffer to another
; Receives from stack
;	len = length of buffer [DWORD value parameter]
;	buf1 = first buffer [BYTE reference parameter]
;	buf2 = second buffer [BYTE reference parameter] (assumed to be equal or longer than buf1)
; Returns: nothing
PARAMS	= (5+1)*TYPE DWORD ; number of temporaries plus return address
NPARAMS = 3
len = PARAMS + 0*TYPE DWORD
buf1 = PARAMS + 1*TYPE DWORD
buf2 = PARAMS + 2*TYPE DWORD
	pushfd
	push ebx
	push ecx
	push esi
	push edi
;*** Copy data from one buffer to the other using a block move instruction.
;*** Don't forget to set direction. 

	cld
	mov ecx, len[esp]
	mov esi, buf1[esp]
	mov edi, buf2[esp]
	rep movsb
	 

	pop edi
	pop esi
	pop ecx
	pop ebx
	popfd
	ret NPARAMS*TYPE DWORD	; return and pop parameters
move	ENDP
END main
