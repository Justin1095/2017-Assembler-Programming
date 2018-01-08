TITLE NAME Homework 6, 1 Dimensional Arrays

; Nov. 2, 2016
; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming 
; Prof. James W. Emert
; Goal: 
; Description: This program demonstrate the ability to manipulate arrays by creating an array list of 100
; floating point numbers and then sorting the array.


INCLUDE Irvine32.inc
arrayGen	PROTO		val:DWORD,		list:DWORD		;goes to arrayGen where it generate an array of 100 random numbers
sortArray	PROTO		val:DWORD,		list:DWORD		;goes to sortArray where it sorts the array
outputNum	PROTO		val:DWORD,		list:DWORD		;goes to outputNum where the numbers were printed to the display
.data
array			REAL4	100		DUP(?)		;the array
welcomeOne		BYTE "Hello user!",0dh,0ah,0		;welcomes the user
welcomeSec		BYTE "This program randomly generates an array and then sorts the array out",0dh,0ah,0		;explains the program
outputArr		BYTE "Here is the randomly generated array: ",0dh,0ah,0		;states the array
outputSort		BYTE "Here is the same array but sorted: ",0dh,0ah,0		;states the sorted array
thx				BYTE "Thank you for using this program!" ,0dh,0ah,0			;end of the program
.code
main PROC

;code
	finit
	mov edx, OFFSET welcomeOne	;welcomes the user
	call WriteString
	mov edx, OFFSET welcomeSec	;explains the program
	call WriteString
	call CrLf

	mov edx, OFFSET outputArr	;states the array
	call WriteString
	INVOKE arrayGen, OFFSET array, SIZEOF array		;invokes arrayGen which generates an array of 100 floating point numbers
	call CrLf
	INVOKE outputNum, OFFSET array, LENGTHOF array	;invokes outputNum which prints out the array
	call CrLf

	mov edx, OFFSET outputSort	;states the sorted array
	call WriteString
	INVOKE sortArray, OFFSET array, SIZEOF array	;invokes sortArray which sorts the array
	call CrLf
	INVOKE outputNum, OFFSET array, LENGTHOF array	;invokes outputNum which will now print out the sorted array
	call CrLf

	mov edx, OFFSET thx			;end of the program 
	call WriteString

	call WaitMsg

	exit
main ENDP


.data
.code
arrayGen PROC USES edx edi, val:DWORD, list:DWORD	;arrayGen, generates an array of 100 random numbers

LOCAL fpnum	:	DWORD		;creates a local dword called num which means floating point number
PARAMS = 2

	mov edx, val	;moves val into eax 
	add list, edx	;adds list to eax
	mov edi, val	;moves val into eax

	call Randomize	;calls the randomize function

	.REPEAT		;repeats until edi equals the length of the list
		call Random32	;calls the random32 function
		mov fpnum, eax	;moves eax into num
		fild fpnum

		fstp REAL4 PTR[edi]		;loading top of slack 
		add edi, TYPE REAL4		;adds edi
	.UNTIL edi==list	;repeats until edi equals the length of the list

	ret PARAMS*TYPE DWORD
arrayGen ENDP		;ends arrayGen


.data
.code
sortArray PROC USES eax ebx ecx edi, val:DWORD, list:DWORD		;sortArray, gets the array that was created before and sorts them in a bubble sort

LOCAL fpnum	:	DWORD	;creates a local dword called fpnum 
	mov eax, val	;moves val into eax					
	add list, eax	;adds list to eax						
	mov edi, val	;moves val into edi
							
	add edi, TYPE REAL4		;adds edi

	.WHILE edi < list		;create a while loop, loops when edi < list				
		mov ebx, edi		;moves edi into ebx		
					
		.WHILE ebx > val	;creates another while loop, loops when ebx > val			
			mov ecx, ebx	;moves ebx into edx				
			sub ecx, TYPE REAL4	;subtracts edx
					
			fld REAL4 PTR[ecx]		;loads it			
			fld REAL4 PTR[ebx]		;loads it			
			fcomip st(0), st(1)				
			fstp fpnum				;loading top of stack into fpnum
								
			jae avoid		;jumps to avoid				
			mov eax, REAL4 PTR[ecx]		;moves it into eax	
			mov fpnum, eax				;moves eax into fpnum
			               
			mov eax, REAL4 PTR[ebx]		;moves it into eax
			mov [ecx], eax				;moves eax into edx

			mov eax, fpnum				;moves fpnum not eax
			mov [ebx], eax				;moves eax into ebx

		avoid:					;the avoid jump
			sub ebx, TYPE REAL4 ;subtract ebx
				
		.ENDW				;ends the second while loop						
		add edi, TYPE REAL4	;adds edi
					
	.ENDW				;ends the first while loop		
					
	ret PARAMS*TYPE DWORD
sortArray ENDP		;ends sortArray


.data
.code
outputNum PROC USES eax ebx esi, val:DWORD, list:DWORD	;outputNum, prints out the array onto the display

LOCAL fpnum	:	DWORD	;creates a local dword called fpnum 
	xor ebx, ebx	;does xor for edx
	mov esi, val	;moves val into esi

	.WHILE ebx < list	;create a while loop, loops when edx < list
		xor eax, eax	;does xor for eax
		fld REAL4 PTR[esi]	;loads it
		call WriteFloat		;outputs the floating point number
		call CrLf
		fstp fpnum		;loading top of stack into fpnum

		inc ebx
		add esi, TYPE REAL4 ;adds eso
	.ENDW			;ends the while loop

	ret PARAMS*TYPE DWORD
outputNum ENDP		;ends outputNum
; PLACE ADDITIONAL PROCEDURES HERE
END main