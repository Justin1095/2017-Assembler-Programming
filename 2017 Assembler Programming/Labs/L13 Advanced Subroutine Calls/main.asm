TITLE L13 - Advanced Subroutine Calls

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Assignment: Call a function subroutine f(a,b,x,y)
; Description: The program is calculating an apprximation of a derivative using the forward difference method. This method requires calling the 
;  function at two places f(x) and f(x+h). It then calculates the slope of a line between these places (f(x+h)-f(x))/h. Replace the two comments with
;  the instructions to call the subroutine. Notice the slight changes in parameters between the two calls.

INCLUDE Irvine32.inc
;*** Create a PROTO statement for f here
f	PROTO A$:PTR REAL8, B$:PTR REAL8, X$:PTR REAL8, Y$:PTR REAL8
.data
a0			REAL8 3.0	; function parameter
b0			REAL8 -1.5	; function parameter
x0			REAL8 ?		; first x coordinate
y0			REAL8 ?		; first x coordinate
x1			REAL8 ?		; first x coordinate
y1			REAL8 ?		; first x coordinate
slope		REAL8 ?		; slope of the function.
h			REAL8 1.0E-10 ; approximation interval
dump		REAL8 ?		; dump for printing
prompt		BYTE "Enter the x coordinate",0dh,0ah,0
message		BYTE "Derivative: ",0

.code
main PROC
	finit
	mov edx,OFFSET prompt ; prompt for parameters
	call WriteString
	call ReadFloat		; Read x
	fst x0				; save the first x coordinate
	fadd h				; calculate the second x coordinate
	fstp x1				; save the second x coordinate
; *** invoke the subroutine here for the first y coordinate
; ***	f(0,a0,b0,x0,y0)
INVOKE f, OFFSET a0, OFFSET b0, OFFSET x0, OFFSET y0

; *** invoke the subroutine here for the first y coordinate
; ***	f(0,a0,b0,x1,y1)
INVOKE f, OFFSET a0, OFFSET b0, OFFSET x1, OFFSET y1

	fld y1				; calculate slope
	fsub y0
	fdiv h
	fst slope
	mov edx,OFFSET message ; print message
	call WriteString
	fld slope			; print derivative approximation
	call WriteFloat
	fstp dump
	call CrLf
	call WaitMsg	; hold display window open
	exit
main ENDP
.data
four	REAL4 4.0
.code
f	PROC USES ebx, A$:PTR REAL8, B$:PTR REAL8, X$:PTR REAL8, Y$:PTR REAL8
; computes a function y=f(a,b,x)
;	f(a,b,x)=sin(a*x)+cos(b*x)
; Receives from stack
;	a,b = parameters
;	x = x coordinate
;	y = y coordinate
NPARAMS = 2
	push ebx			; save all working registers and flags
	pushfd
	; compute sin(a*x)
	mov ebx,a$		; load address of parameter
	fld REAL8 PTR [ebx]	; load a
	mov ebx,x$		; load address of parameter
	fld REAL8 PTR [ebx]	; load x
	fmul				; compute a*x
	fsin				; calculate sin(a*x)
	; compute cos(b*x)
	mov ebx,b$		; load address of parameter
	fld REAL8 PTR [ebx]	; load b
	mov ebx,x$		; load address of parameter
	fld REAL8 PTR [ebx]	; load x
	fmul				; compute b*x
	fcos				; calculate cos(b*x)
	fadd				; calculate function
	mov ebx,y$		; load address of real part of complex result
	fstp REAL8 PTR [ebx]	; store y
	popfd				; restore flags
	pop ebx
	ret NPARAMS*TYPE SDWORD	; return and pop parameters
f	ENDP
END main