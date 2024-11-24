[BITS 16]	                       
[ORG 0x7C00]	                   
global _start

section .text

_start:

	mov si, hex
	call PrintString

	mov si, oct
	call PrintString

	mov si, bin
	call PrintString

	mov si, nextLine
	call PrintString

	mov ecx, 10

OutMem:

	mov edi,  dword [ecx]
	push 0xFF
	push_hex_char:
		mov ebx, edi
		and ebx, 0xF
		push bx
		shr edi, 4
		jnz	push_hex_char
	
	pop_hex_char:
		pop ax;
		cmp ax, 0xFF
		je finish_hex
		call PrintHex
		jmp pop_hex_char
		finish_hex:

	mov si, fourSpace
	call PrintString
		
	mov edi, dword [ecx]
	push 0xFF
	push_oct_char:
		mov ebx, edi
		and ebx, 7
		push bx
		shr edi, 3
		jnz	push_oct_char
	
	pop_oct_char:
		pop ax
		cmp ax, 0xFF
		je finish_oct
		call PrintOct
		jmp pop_oct_char
		finish_oct:

	mov si, fourSpace
	call PrintString

	mov edi, dword [ecx]
	push 0xFF
	push_bin_char:
		mov ebx, edi
		and ebx, 1
		push bx
		shr edi, 1
		jnz	push_bin_char
	
	pop_bin_char:
		pop ax
		cmp ax, 0xFF
		je finish_bin
		call PrintOct
		jmp pop_bin_char
		finish_bin:

	mov si, nextLine
	call PrintString

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

PrintString:	                    
	MOV AL, [SI]
	INC SI
	CALL Print
	OR AL, AL
	JNZ PrintString
RET

hex db ' HEX', 9 DUP(' '), 0
oct db 'OCT', 12 DUP(' '), 0
bin db 'BIN', 9 DUP(' '), 0
fourSpace db 4 DUP(' '), 0
nextLine db 0xA, 0xD, 0

TIMES 510 - ($ - $$) db 0	       
DW 0xAA55