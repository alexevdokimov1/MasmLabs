[BITS 16]	                       
[ORG 0x7C00]	                   

MOV SI, str1
CALL draw_string
RET

draw_string:	                    
MOV AL, [SI] 
INC SI
CALL print
OR AL, AL
JNZ draw_string
RET   

print:
MOV AH, 0x0E
MOV BH, 0x00
MOV BL, 0x14
INT 0x10
RET		                           

str1	db	'RSREU', 0xD, 0xA, 0

TIMES 510 - ($ - $$) db 0	       
DW 0xAA55	