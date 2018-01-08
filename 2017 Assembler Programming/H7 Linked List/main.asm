TITLE NAME Homework 7 Linked List

; Justin Seda 
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: 
; Description:This program demonstrate the ability to manipulate linked lists.


INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data

process	STRUCT
	output		DWORD	?	;process output
	point		DWORD	?	;pointer to next process in list
process	ENDS

menu	BYTE "i - Insert",0dh,0ah	;insert
		BYTE "d - Delete",0dh,0ah	;delete
		BYTE "f - Front",0dh,0ah	;front
		BYTE "p - Print",0dh,0ah	;print
		BYTE "q - Quit",0dh,0ah,0	;quit

heapHandle	DWORD	0	;heap identifier
data		DWORD	?	;head of linked list
present		DWORD	?	; pointer to current

.code

new				PROTO POINTER:PTR NODE					;creates it
print_info		PROTO BEGIN:DWORD						;prints it 
insert_info		PROTO BEGIN:PTR NODE, POINTER:DWORD		;inserts itr
delete_info		PROTO BEGIN:PTR NODE, POINTER:PTR NODE	;delete it
print_node		PROTO POINTER:DWORD						;gets the front


main PROC

	INVOKE GetProcessHeap	

	.IF eax==NULL		;test for error
		call WriteWindowsMsg	;display error message
		jmp over		;ends on error
	.ENDIF

	mov heapHandle,eax	; mov eax into heapHandle

	.REPEAT
		mov edx,OFFSET menu	; print menu 
		call WriteString
		call ReadChar
		call WriteChar
		call CrLf

		.IF al=='i'			;if user plugged in i
			INVOKE new, OFFSET present
			INVOKE print_node, present
			INVOKE insert_info, OFFSET data, present 

		.ELSEIF al=='d'		;if user plugged in d
			INVOKE delete_info, OFFSET data, OFFSET present
			INVOKE print_node, present

		.ELSEIF al=='p'		;if user plugged in p
			INVOKE print_info, data

		.ELSEIF al=='f'		;if user plugged in f
			INVOKE print_node,present

		.ELSEIF al=='q'		;if user plugges in q
		.ENDIF
	.UNTIL al=='q'

over: call WaitMsg	
	exit
main ENDP


new	PROC USES eax ebx ecx edx, POINTER:PTR NODE		;creates

PARAMS = 1

	INVOKE HeapAlloc, heapHandle, HEAP_ZERO_MEMORY, SIZEOF process
					
	.IF eax == NULL		;test for error
		mWrite "Could not allocate node"  ;error message
		mov ebx,null	;return null pointer 

	.ELSE
		mov ebx,eax
		call Random32		; create random output

		mov ecx,500		; reduce number in size
		mov edx,1
		div ecx
		mov (PROCESS PTR[ebx]).output,edx	; store output

	.ENDIF
	mov edx,POINTER		; load address of pointer variable
	mov [edx],ebx	; save address of process node

	ret PARAMS*TYPE DWORD	; return and pop parameters

new	ENDP


delete_info	PROC BEGIN:PTR NODE, POINTER:PTR NODE

PARAMS = 2
	mov eax,BEGIN		;load address of head 
	mov ecx,POINTER		;load address of deleted node pointer
	mov edx,[eax]		;load pointer to first node

	.IF edx==null
		mov ebx,null	; set pointer to next node to null

	.ELSE
		mov ebx,(PROCESS PTR[edx]).point	; point to next node
	.ENDIF

	mov [eax],ebx	; set new head 
	mov [ecx],edx	; return null for first node 

	ret PARAMS*TYPE DWORD	

delete_info	ENDP


print_info	PROC USES eax ebx, BEGIN:DWORD	; print the list 
PARAMS = 1
	
	mov ebx, BEGIN

	.WHILE ebx != NULL
	INVOKE print_node, ebx
	mov ebx,(process PTR[ebx]).point
	.ENDW

	ret PARAMS*TYPE DWORD	

print_info	ENDP


insert_info	PROC USES eax ebx ecx edx, BEGIN:PTR NODE, POINTER:DWORD

PARAMS = 2

	mov ecx,null	; track last node
	mov ebx,BEGIN	; load address of head 
	mov ebx,[ebx]	; load pointer to first node
	mov edx,POINTER	; load pointer to new node

	mov eax,(PROCESS PTR[edx]).output 

	.WHILE ebx!=null
		cmp (PROCESS PTR[ebx]).output,eax

		.IF !SIGN?
			mov ecx,ebx ; track last node visited
			mov ebx, (PROCESS PTR[ebx]).point	; move to next node in list

		.ELSE
			mov ebx,null	
								
		.ENDIF
	.ENDW

	.IF ecx==null
		mov ebx,BEGIN		;load address to head 
		mov eax,[ebx]		;load pointer to rest
		mov (PROCESS PTR[edx]).point,eax	;set new node to point 
		mov [ebx],edx	;point queue to new node

	.ELSE
		mov eax,(PROCESS PTR[ecx]).point	;load pointer to remainder 
		mov (PROCESS PTR[edx]).point,eax	; set new node to point 
		mov (PROCESS PTR[ecx]).point,edx	; point last node to new node
	.ENDIF

	ret PARAMS*TYPE DWORD	

insert_info	ENDP


print_node PROC USES eax ebx, POINTER:DWORD 

PARAMS = 1
	mov ebx,POINTER

	.IF ebx!=null
		mWrite "Output ->"
		mov eax, (PROCESS PTR[ebx]).output
		call WriteDec
		call CrLf

	.ENDIF

	ret PARAMS*TYPE DWORD	; return and pop parameters

print_node ENDP

END main