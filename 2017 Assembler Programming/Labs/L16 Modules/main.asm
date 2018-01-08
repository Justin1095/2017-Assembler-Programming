TITLE L16 - Modules

;  Justin Seda
; 91863 
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Goal: Demonstrate the ability to use modules.
; Method: 
;    1. Edit the file main.asm and create 3 files
;       * quadratic.asm - contains all lines of the subroutine
;           (from second .data to ENDP). At the beginning add a
;           TITLE and INCLUDE for Irvine. At the end of the file
;           add an END. Do not put anything else on the END.
;	    Add a PUBLIC directive after the .code directive.
;       * quadratic.inc - contains the PROTO for the subroutine
;           and the leading comments for the subroutine. 
;       * main.asm - add an INCLUDE for quadratic.inc. Remove
;           all other lines relating to declaring the subroutine.
;	    Also remove the PROTO statement.
;	    The END must include the parameter main.
;     2. Copy project_sample and put the three files into
;       project_sample.
;     3. Open the project and attach quadratic.asm. (main.asm already be attached)
;     4. Compile and run the program.
;     5. Upload all three source files MAIN.ASM, QUADRATIC.INC and QUADRATIC.ASM. Do NOT zip.
; Grading:
;	The program is able to compute the roots of a parabola.
;	The program was divided into modules and functions correctly.

INCLUDE Irvine32.inc
INCLUDE quadratic.inc
.data
a0			REAL8 ?		; parabola parameters
b0			REAL8 ?
c0			REAL8 ?
r1			REAL8 ?		; roots of the parabola
r2			REAL8 ?		; roots of the parabola
prompt		BYTE "Enter the parameters of the parabola separated by spaces",0dh,0ah,0
message		BYTE "Roots: ",0

.code

main PROC
	finit
	mov edx,OFFSET prompt ; prompt for parameters
	call WriteString
	call ReadFloat		; Read a
	fstp a0
	call ReadFloat		; Read b
	fstp b0
	call ReadFloat		; Read c
	fstp c0
	INVOKE quadratic,0,OFFSET a0,OFFSET b0,OFFSET c0,OFFSET r1
	mov edx,OFFSET message ; print message
	call WriteString
	fld r1				; print postive root
	call WriteFloat
	fstp r1
	mov al,','			; print a seperator space
	call WriteChar
	mov al,' '			; print a seperator space
	call WriteChar
	INVOKE quadratic,1,OFFSET a0,OFFSET b0,OFFSET c0,OFFSET r2
	fld r2				; print first root
	call WriteFloat
	fstp r2
	call CrLf
	call WaitMsg	; hold display window open
	exit
main ENDP

END main