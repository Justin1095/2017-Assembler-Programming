TITLE NAME Homework 2

; Justin Seda
; 91863
; CPSC 232 Introduction to Assembler Programming
; Prof. James W. Emert
; Assignment: Indefinite Loops
; Description: This program is suppose to output the square root.


INCLUDE Irvine32.inc
.data
; PLACE DATA DIRECTIVES HERE
x		SDWORD ?		;input from user
u		SWORD ?			;variable equal to the user's input
l		SWORD 1			;l equal 1
m		SWORD 0			;m equal 0
two		SWORD 2			; 2
i		SDWORD 0		;variable
begin BYTE "Hello, this program finds the square root of the number you input, please enter a number that you would like to find",0dh,0ah,0			;begin is the prompt for the user to input a number
messageE BYTE "If you would like to leave the program, enter a zero or a negative number",0dh,0ah,0			;messageE is the prompt to the user if they wants to end the program
output BYTE "The square root of your number is: ",0			;outputs the square root of the user's input
outputTwo BYTE "Thank you for using this program, Bye!",0dh,0ah,0		;outputs a thank you meesage
.code
main PROC

; PLACE SOURCE CODE HERE
mov edx,OFFSET begin		;prompts the beginning message
call WriteString 
loop_until_negative:
mov edx, OFFSET messageE		;prompts messageE
call WriteString  
call ReadDec				;reads user's input 
mov u, ax					;saves user's input to u
mov x, eax					;saves user's input to x
cmp ax, l					;compares u to 1

jl over_program			;ends the program
jg while_loop		;goes into the loop if l is less than u


while_loop:
mov ax, u		;moves the u into ax
cmp l, ax		;compares the u to l

jle cal_loop		;calculate the information 
jge over_loop		;ends the loop

cal_loop:
mov eax, 0		;moves 0 into eax 
mov edx, 0		;moves 0 into edx
mov ecx, 0		;moves 0 into ecx

mov ax, u		;moves the u into ax
add ax, l		;adds 1 to u
mov cx, two		;moves 2 into cx
idiv  ecx		;divides by 2 

mov m, ax		;moves the results of ax into m
imul m		;multiply m by itself

mov i, eax		;moves eax into i
mov i + 2, edx		;moves edx into i + 2
mov  eax, i			;moves i into eax
mov edx, 0		;moves 0 into edx
cmp eax, x		; compares x to eax

je equal_branch			; if x and eax are equal then they go into this branch
jg greatThan_loop		; if eax is greater than x then they go into this loop
jl lessThan_loop		; if eax is less than x then they go into this loop


equal_branch:		;equal branch
mov edx,OFFSET output		;outputs the output message
call WriteString
mov ax, m		;moves ax into m 
call WriteDec	;displays the result
call CrLf
mov m,0
mov l,1
jmp loop_until_negative


greatThan_loop:			;greater than loop
mov ax, m		;moves m into ax 
sub eax, 1		;subtracts 1
mov u, ax		;moves ax into u

jmp while_loop		;jumps back to the while loop


lessThan_loop:		;less than loop
mov ax, m		;moves m into ax 
add eax, 1		;adds 1
mov l, ax		;moves ax into l

jmp while_loop		;jumps back to the while loop


over_loop:		;ends the whole loop
mov edx, OFFSET output		;outputs the output message 
call WriteString
mov ax, u		;moves ax into m 
call WriteDec	;displays the result
call CrLf
mov m,0
mov l,1
jmp loop_until_negative

over_program:
mov edx, OFFSET outputTwo		;outputs the second output message
call WriteString
call WaitMsg
exit

main ENDP
; PLACE ADDITIONAL PROCEDURES HERE
END main