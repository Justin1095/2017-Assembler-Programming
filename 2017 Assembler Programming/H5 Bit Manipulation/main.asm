TITLE NAME Homework 5, Bit Manipulation

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming 
; Prof. James W. Emert
; Assignment: Homework 5 
; Description: This program demonstrate the ability to manipulate bits and use high level subroutine interfacing.



INCLUDE Irvine32.inc

.data
; PLACE DATA DIRECTIVES HERE
result	DWORD		?

line	BYTE	"Computer",0,0,0,0
intro	BYTE	"Hello! This program demonstrate the ability to manipulate bits and use high level subroutine interfacing." ,0dh,0ah,0	
.code
main PROC

	mov edx,OFFSET intro		;displays the intro message
	call WriteString 
	call CrLf

	push OFFSET line	;push line
	push OFFSET result	;push result
	push SIZEOF line	;push the size of result
	call CRC			;calls CRC

	mov eax,result		;moves result in eax
	call WriteHex		;call WriteHex				
	call CrLf
 
	mov edi,OFFSET line + 8 ; moves line + 8 into edi
	mov edx,4				;moves 4 into edx
	mov eax,result			;moves results into eax
	shl eax,2				;moves 2 into eax


loopStart:			;create the first loop
	rol eax,8		; rol eax and 8
	stosb
	dec edx			; dec edx
	cmp edx,1		;compare 1 and edx
	jge loopStart	;jumps to loopStart if greater than or equal to

Two:				;create second loop
	push OFFSET line	;repeat the same process like we did in the beginning
	push OFFSET result	
	push SIZEOF line	
	call CRC

	mov eax,result
	call WriteHex							
	call CrLf

	mov ebx,OFFSET line		;move line into ebx
	mov eax,DWORD PTR[ebx]	;move DWORD PTR[ebx] into eax
	btc eax,0				;move 0 into eax
	mov edi,OFFSET line		;move line into edi
	stosb

	push OFFSET line		;push line
	push OFFSET result		;push result
	push SIZEOF line		;push the size of result
	call CRC				;call CRC

	mov eax,result		;move result into eax
	call WriteHex		;call WriteHex					
	call CrLf

	mov ebx,OFFSET line		;move line into ebx
	mov eax,DWORD PTR[ebx]	;move DWORD PTR[ebx] into eax
	mov ecx,29				;move 29 into ecx
	mov edx,1				;mov 1 into edx

Three:			;create thrid loop
	btc eax,edx		;btc eax and edx
	inc edx
	loop Three	;loop to the three

Four:					;create fourth loop
	mov edi,OFFSET line		;move line into edi
	stosd

	push OFFSET line		;repeat the same process like we did in the beginning	
	push OFFSET result
	push SIZEOF line
	call CRC

	mov eax,result
	call WriteHex							
	call CrLf

call WaitMsg
exit

main ENDP



.data 
.code
CRC PROC

	;create params and nparams
	PARAMS = 3
	NPARAMS = 6 * TYPE DWORD 

	;create lineLength, result$ and l$ aka line$
	result$ = NPARAMS + 1 * TYPE DWORD
	l$ = NPARAMS + 2 * TYPE DWORD 
	lineLength = NPARAMS + 0 * TYPE DWORD 

	;push eax, ebx, ecx, edx
	push eax 
	push ebx
	push ecx
	push edx
	pushfd
	cld
	
	mov eax,0			;move 0 into eax
	mov esi,l$[esp]		;move l$[esp] into esi
	mov ecx,1			;move 1 into ecx
	lodsb

	mov edx,0			;move 0 into edx
	mov ecx, DWORD PTR lineLength[esp]  ;move DWORD PTR lineLength[esp] into ecx

Five:		;create loop Five
		mov ebx,ecx	;move ecx
		cmp ebx,1	;move 1 into ebx
		je Eight	;jump to loop eight	

		mov ecx,8	;move 8 into ecx

Six:		
		shl al,1
		rcl edx,1
		bt edx,30
		jc Sev  ;jump to loop 7

		loop Six;loop to 6

		jmp loopEl	;jump to loop 11

Sev:		;create loop 7
		xor edx,6030B9C7h
		loop Six ;loop to 6

		jmp loopEl	;jump to 11

Eight:		;create loop 8
		mov ecx,6	;move 6 into ecx

Nine:	;create loop 9
		shl al,1
		rcl edx,1
		bt edx,30
		jc Ten		;jump to loop 10

		loop Nine	;loop to 9

		jmp loopTw		;jump to 12	

Ten:	;create loop 10
		xor edx,6030B9C7h
		loop Nine	;loop to 9

		jmp loopTw	;jump to 12

loopEl:		;create loop 11
		cld 
		mov eax,0	;move 0 into eax
		mov ecx,1	;move 1 into ecx
		lodsb

		mov ecx,ebx		;move ebx. ecx
		loop Five	;loop to 5

loopTw:	;create loop 12
		mov ebx, DWORD PTR result$[esp]	;move DWORD PTR result$[esp] into ebx
		mov DWORD PTR [ebx],edx			;move edx into DWORD PTR [ebx]

	popfd
	;pop edx, ecx, ebx, eax
	pop edx
	pop ecx
	pop ebx
	pop eax

ret PARAMS*TYPE DWORD

CRC ENDP

END main