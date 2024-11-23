[BITS 16]	                       
[ORG 0x7C00]	                   
global _start

section .text
var1 dd	0x1234ABCD

_start:

mov al, 'E'
call Print
mov al, 'A'
call Print
mov al, 'X'
call Print
mov al, '('
call Print
mov al, 'h'
call Print
mov al, 'e'
call Print
mov al, 'x'
call Print
mov al, ')'
call Print
mov al, '='
call Print

mov edi,  dword [var1]
push 255
push_hex_char:
	mov ebx, edi
	and ebx, 15
	push bx
	shr edi, 4
	jnz	push_hex_char
	
pop_hex_char:
	pop ax;
	cmp ax, 255
	je finish_hex
	call PrintHex
	jmp pop_hex_char
	finish_hex:

mov al, 0xA
call Print
mov al, 0xD
call Print

mov al, 'E'
call Print
mov al, 'D'
call Print
mov al, 'I'
call Print
mov al, '('
call Print
mov al, 'o'
call Print
mov al, 'c'
call Print
mov al, 't'
call Print
mov al, ')'
call Print
mov al, '='
call Print

mov edi, dword [var1]
push 255
push_oct_char:
	mov ebx, edi
	and ebx, 7
	push bx
	shr edi, 3
	jnz	push_oct_char
	
pop_oct_char:
	pop ax;
	cmp ax, 255
	je finish_oct
	call PrintHex
	jmp pop_oct_char
	finish_oct:

ret

Print:
	MOV AH, 0x0E                   
	MOV BH, 0x00                   
	MOV BL, 0x14   
	INT 0x10	
	RET

PrintHex:
	cmp al, 10
	jl NotHex
	add al, 7
	NotHex:
	add al, 48
	MOV AH, 0x0E                   
	MOV BH, 0x00                   
	MOV BL, 0x14   
	INT 0x10	
	RET

PrintOct:
	add al, 48
	MOV AH, 0x0E                   
	MOV BH, 0x00           
	MOV BL, 0x14
	INT 0x10	
	RET


TIMES 510 - ($ - $$) db 0	       
DW 0xAA55