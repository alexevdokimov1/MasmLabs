[BITS 16]	                       
[ORG 0x7C00]	                   
global _start

section .text

_start:

	mov si, intro
	call PrintString

	mov eax, 0
	mov ebx, 0
	call ReadSymbol
	sub al, 48
	and ax, 0x0F
	mov bl, 10
	mul bl 
	mov bx, ax

	call ReadSymbol
	sub al, 48
	and ax, 0x0F
	add bx, ax 

	cmp bx, 1
	jne skipJan
		mov si, jan
		call PrintString
		jmp _start
	skipJan:

	cmp bx, 2
	jne skipFeb
		mov si, feb
		call PrintString
		jmp _start
	skipFeb:

	cmp bx, 3
	jne skipMar
		mov si, mar
		call PrintString
		jmp _start
	skipMar:

	cmp bx, 4
	jne skipApr
		mov si, apr
		call PrintString
		jmp _start
	skipApr:

	cmp bx, 5
	jne skipMay
		mov si, may
		call PrintString
		jmp _start
	skipMay:

	cmp bx, 6
	jne skipJun
		mov si, jun
		call PrintString
		jmp _start
	skipJun:

	cmp bx, 7
	jne skipJul
		mov si, jul
		call PrintString
		jmp _start
	skipJul:

	cmp bx, 8
	jne skipAug
		mov si, aug
		call PrintString
		jmp _start
	skipAug:

	cmp bx, 9
	jne skipSep
		mov si, sep
		call PrintString
		jmp _start
	skipSep:

	cmp bx, 10
	jne skipOct
		mov si, oct
		call PrintString
		jmp _start
	skipOct:

	cmp bx, 11
	jne skipNov
		mov si, nov
		call PrintString
		jmp _start
	skipNov:

	cmp bx, 12
	jne skipDec
		mov si, decem
		call PrintString
		jmp _start
	skipDec:

	mov si, error
	call PrintString

	jmp _start

ret

Print:
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

ReadSymbol:
	MOV AH, 0x00
	INT 0x16
	RET

intro db 'Enter month number (including zero)', 0xA, 0xD, 0
error db 3 dup('!'),'Wrong month number. Try again',3 dup('!'), 0xA, 0xD, 0

jan db 'January', 0xA, 0xD, 0
feb db 'February', 0xA, 0xD, 0
mar db 'March', 0xA, 0xD, 0
apr db 'April', 0xA, 0xD, 0
may db 'May', 0xA, 0xD, 0
jun db 'June', 0xA, 0xD, 0
jul db 'July', 0xA, 0xD, 0
aug db 'August', 0xA, 0xD, 0
sep db 'September', 0xA, 0xD, 0
oct db 'October', 0xA, 0xD, 0
nov db 'November', 0xA, 0xD, 0
decem db 'December', 0xA, 0xD, 0

nextLine db 0xA, 0xD, 0

TIMES 510 - ($ - $$) db 0	       
DW 0xAA55