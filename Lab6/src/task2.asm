[BITS 16]	                       
[ORG 0x7C00]	                   
global _start

section .text
var1 dd	0x1234ABCD

_start:

	mov al, 'H'
	call Print
	mov al, 'E'
	call Print
	mov al, 'X'
	call Print

	mov ecx, 9
	PrintSpace:
	mov al, ' '
	call Print
	loop PrintSpace

	mov al, 'O'
	call Print
	mov al, 'C'
	call Print
	mov al, 'T'
	call Print

	mov ecx, 9
	PrintSpace2:
	mov al, ' '
	call Print
	loop PrintSpace2

	mov al, 'B'
	call Print
	mov al, 'I'
	call Print
	mov al, 'N'
	call Print

	mov al, 0xA
	call Print
	mov al, 0xD
	call Print

	mov ecx, 10

OutMem:

	mov edi,  dword [ecx]
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

		mov al, ' '
		call Print
		mov al, ' '
		call Print
		mov al, ' '
		call Print
		mov al, ' '
		call Print
		
	mov edi, dword [ecx]
	push 255
	push_oct_char:
		mov ebx, edi
		and ebx, 7
		push bx
		shr edi, 3
		jnz	push_oct_char
	
		pop_oct_char:
		pop ax
		cmp ax, 255
		je finish_oct
		call PrintHex
		jmp pop_oct_char
		finish_oct:

	mov al, 0xA
	call Print
	mov al, 0xD
	call Print
	loop OutMem
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