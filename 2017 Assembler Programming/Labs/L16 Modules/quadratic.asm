TITLE L16 - Modules
;  Justin Seda
; 91863 
INCLUDE Irvine32.inc
.data
four	REAL4 4.0
.code
	PUBLIC quadratic
quadratic	PROC USES ebx, FLAG:DWORD, A$:PTR REAL8, B$:PTR REAL8, C$:PTR REAL8, RESULT:PTR REAL8
; calculation of the roots of a parabola
; Receives from stack
;	flag = type of root (0=positive, 1=negative) [integer, value parameter]
;	a0, b0, c0 = parabola parameters [REAL reference parameters]
; Returns
;	Specified root [REAL8 reference parameter]
PARAMS	= 3*TYPE DWORD ; number of temporaries plus return address
NPARAMS = 5
	pushfd
	; compute radical
	mov ebx,b$				; load address of parameter
	fld REAL8 PTR [ebx]		; load b
	fmul REAL8 PTR [ebx]	; multiply for b^2
	fld four				; load for 4ac
	mov ebx,a$				; load address of parameter
	fmul REAL8 PTR [ebx]
	mov ebx,c$				; load address of parameter
	fmul REAL8 PTR [ebx]
	fsub					; compute b^2-4ac
	fsqrt
	; compute root
	mov ebx,b$				; load address of parameter
	fld REAL8 PTR [ebx]		; load b
	fchs					; convert to -b
	mov eax,flag			; load flag
	cmp eax,0
	jne negative			; if not zero compute negative root
postive:
	fadd
	jmp divide
negative:
	fsubr
divide:
	mov ebx,a$				; load address of parameter
	fld REAL8 PTR [ebx]		; compute 2b
	fadd REAL8 PTR [ebx]
	fdiv
	mov ebx,RESULT			; load address of real part of complex result
	fstp REAL8 PTR [ebx]	; store real part
	popfd					; restore flags
	ret NPARAMS*TYPE SDWORD	; return and pop parameters
quadratic	ENDP
END