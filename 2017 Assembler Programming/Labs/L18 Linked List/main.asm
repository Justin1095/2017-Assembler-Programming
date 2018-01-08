TITLE L18 - Linked List

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to use linked lists.
; Method: Simulate the operation of a priority list. 

INCLUDE Irvine32.inc
INCLUDE Macros.inc
.data
process	STRUCT
	id			DWORD ?	; process number
	priority	DWORD ?	; process priority
	link		DWORD ? ; pointer to next process in list
process	ENDS

menu	BYTE "c - Create a process",0dh,0ah
		BYTE "d - Delete",0dh,0ah
		BYTE "p - Print",0dh,0ah
		BYTE "q - Quit",0dh,0ah,0
heapHandle	DWORD 0 ; heap identifier
queue	DWORD	? ;	head of linked list
current	DWORD	?	; pointer to current
id_label	BYTE "ID:",0

.code
create	PROTO pointer:PTR NODE
print	PROTO head:DWORD
insert	PROTO head:PTR NODE, pointer:DWORD
delete	PROTO head:PTR NODE, pointer:PTR NODE
print_node PROTO pointer:DWORD
main PROC
	INVOKE GetProcessHeap	; get access to heap
	.IF eax==NULL		; test for error
		call WriteWindowsMsg ; display standard error message
		jmp done		; terminate on error
	.ENDIF
	mov heapHandle,eax	; save heap identifier
	.REPEAT
		mov edx,OFFSET menu	; print menu of operations
		call WriteString
		call ReadChar
		call WriteChar
		call CrLf
		.IF al=='c'
			INVOKE create, OFFSET current
			INVOKE print_node, current
			INVOKE insert, OFFSET queue, current 
		.ELSEIF al=='d'
			INVOKE delete, OFFSET queue, OFFSET current
			INVOKE print_node, current
		.ELSEIF al=='p'
			INVOKE print, queue
		.ELSEIF al=='q'
		.ENDIF
	.UNTIL al=='q'
done: call WaitMsg	; hold display window open
	exit
main ENDP
create	PROC uses eax ebx ecx edx, pointer:PTR NODE
; create a node
; Receives from stack
;	pointer = pointer to new node
NPARAMS = 1
	INVOKE HeapAlloc, heapHandle, 	HEAP_ZERO_MEMORY, SIZEOF process
					; allocate node
	.IF eax==NULL		; test for error
		mWrite "Could not allocate node" ; display custom error message
		mov ebx,null ; return null pointer for node not created
	.ELSE
		mov ebx,eax
		call Random32		; create random id
		mov ecx,1000		; reduce number in size
		mov edx,0
		div ecx
		mov (PROCESS PTR[ebx]).id,edx	; store id in node
		call Random32		; create random priority
		mov ecx,100		; reduce number in size
		mov edx,0
		div ecx
		mov (PROCESS PTR[ebx]).priority,edx	; store priority
	.ENDIF
	mov edx,pointer		; load address of pointer variable
	mov [edx],ebx	; save address of process node
	ret NPARAMS*TYPE DWORD	; return and pop parameters
create	ENDP
print	PROC uses eax ebx, head:DWORD
; print a list
; Receives from stack
;	head = pointer to first node in list
NPARAMS = 1
;*** print list using print_node subroutine
	
	mov ebx, head
	.WHILE ebx != NULL
	INVOKE print_node, ebx
	mov ebx,(process PTR[ebx]).link
	.ENDW

	ret NPARAMS*TYPE DWORD	; return and pop parameters
print	ENDP
print_node PROC uses eax ebx, pointer:DWORD
; Print a node
; Receives from stack
;	pointer=pointer to node to print
NPARAMS = 1
	mov ebx,pointer
	.IF ebx!=null
		mWrite "ID:"
		mov eax, (PROCESS PTR[ebx]).id
		call WriteDec
		mWrite " Priority:"
		mov eax, (PROCESS PTR[ebx]).priority
		call WriteDec
		call CrLf
	.ENDIF
	ret
	ret NPARAMS*TYPE DWORD	; return and pop parameters
print_node ENDP
insert	PROC uses eax ebx ecx edx, head:PTR NODE, pointer:DWORD
; print a list
; Receives from stack
;	head = pointer to first node in list
NPARAMS = 2
	mov ecx,null	; track last node
	mov ebx,head	; load address of head of queue
	mov ebx,[ebx]	; load pointer to first node
	mov edx,pointer	; load pointer to new node
	mov eax,(PROCESS PTR[edx]).priority ; load new priority
	.WHILE ebx!=null
		cmp (PROCESS PTR[ebx]).priority,eax
		.IF !SIGN?
			mov ecx,ebx ; track last node visited
			mov ebx, (PROCESS PTR[ebx]).link	; move to next node in list
		.ELSE
			mov ebx,null						; found insertion point
		.ENDIF
	.ENDW
	.IF ecx==null
		mov ebx,head	; load address to head of queue
		mov eax,[ebx]		; load pointer to rest of queue
		mov (PROCESS PTR[edx]).link,eax	; set new node to point to entire queue
		mov [ebx],edx	; point queue to new node
	.ELSE
		mov eax,(PROCESS PTR[ecx]).link ; load pointer to remainder of queue
		mov (PROCESS PTR[edx]).link,eax	; set new node to point to entire queue
		mov (PROCESS PTR[ecx]).link,edx	; point last node to new node
	.ENDIF
	ret NPARAMS*TYPE DWORD	; return and pop parameters
insert	ENDP
delete	PROC head:PTR NODE, pointer:PTR NODE
; deletes head of a list and returns
; Receives from stack
;	head = address of head of queue
;	pointer = address of pointer to deleted node
NPARAMS = 2
	mov eax,head	; load address of head of queue
	mov ecx,pointer	; load address of deleted node pointer
	mov edx,[eax]	; load pointer to first node
	.IF edx==null
		mov ebx,null	; set pointer to next node to null
	.ELSE
		mov ebx,(PROCESS PTR[edx]).link	; point to next node in queue
	.ENDIF
	mov [eax],ebx	; set new head of queue
	mov [ecx],edx	; return null for first node in queue
	ret NPARAMS*TYPE DWORD	; return and pop parameters
delete	ENDP
END main