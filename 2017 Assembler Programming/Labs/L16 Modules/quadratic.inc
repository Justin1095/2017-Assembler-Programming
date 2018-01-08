;  Justin Seda
; 91863 
quadratic	PROTO factor :DWORD, A$:PTR REAL8, B$:PTR REAL8, C$:PTR REAL8, RESULT:PTR REAL8
; calculation of the roots of a parabola
; Receives from stack
;	flag = type of root (0=positive, 1=negative) [integer, value parameter]
;	a0, b0, c0 = parabola parameters [REAL reference parameters]
; Returns
;	Specified root [REAL8 reference parameter]