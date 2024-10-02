.686P
.MODEL FLAT, STDCALL
.STACK 4096
option casemap:none
include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
.DATA
	initSignedByte BYTE 10;
	signedByte BYTE ?;
	initUnsignedWord WORD 6500;
	unsignedWord WORD ?;
	initSigned32Word SDWORD 12345678;
	signed32Word SDWORD ?;
	string BYTE "Это слово ",0;
	empString BYTE 11 DUP(0);
	initRealValue REAL4 -2.2;
	realValue REAL4 ?;
	string2 BYTE "Строка с переносом", 0Dh, 0Ah, 0;
	empstring2 BYTE 21 DUP(0);

	dialogueHead BYTE "Проверка",0;
.CODE
START:
	mov al, initSignedByte;
	mov signedByte, al;

	mov ax, initUnsignedWord;
	mov unsignedWord, ax;

	mov eax, initSigned32Word;
	mov signed32Word, eax;

	mov ecx, SIZEOF string - 1; //заносим в ecx размер строки
	mov esi, OFFSET string; //заносим адрес источника
	mov edi, OFFSET empString; //заносим адрес назначения
	rep movsb; //повторяем ecx раз побайтовое копирование

	mov ecx, SIZEOF string2 - 1;
	mov esi, OFFSET string2;
	mov edi, OFFSET empstring2;
	rep movsb;

	mov eax, initRealValue;
	mov realValue, eax;

	invoke MessageBox,NULL,addr dialogueHead, addr empString, MB_OK;

	invoke MessageBox,NULL,addr dialogueHead, addr empstring2, MB_OK;
	
RET
END START
