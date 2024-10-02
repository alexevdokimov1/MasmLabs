.686P
.MODEL FLAT, STDCALL
.STACK 4096 ;������ �����
option casemap:none
include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
includelib c:\masm32\lib\user32.lib
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\kernel32.lib
include c:\masm32\include\masm32rt.inc

.DATA ;������� ������������������ ������
	FileName DB "data\w_512.dat",0 ;����� ����� ��������� ������ ���� � �����

.DATA? ;������� �� ������������������ ������
	hFile HANDLE ?
	hMemory DWORD ?
	pMemory DWORD ?
	hMemory2 DWORD ?
	pMemory2 DWORD ?
	dwBytesRead dd ?
	HW DD ?
	dwFileSize dd ?

.CODE ;������� ����
	START: ;����� ������ ���������
	invoke CreateFile, addr FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL; ��������� ���� ��� ������ ����� API �������
	mov hFile, eax ;���������� ������ �����
	cmp hFile, INVALID_HANDLE_VALUE ;��������� �� ������ ����� �� ����������
	jz ErrorMsg
	invoke GetFileSize, hFile, NULL ;���������� ������ �����
	mov dwFileSize, eax; ��������� ������ ����� � ����������
	INVOKE GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, dwFileSize; �������� ������ ������� ������� dwFileSize
	mov hMemory, eax
	invoke GlobalLock, hMemory
	mov pMemory, eax ; ���������� ��������� �� ������
	;������ ������ �� ����� �������� 2048 ����
	INVOKE ReadFile, hFile, pMemory, 2048, addr dwBytesRead, NULL ;������ ������ ������ ���� �� ����� ������� �����
	; ���������� ����������� ���� ����� ���������� � dwBytesRead
	or eax, eax ; ��������� �� ������ ������
	jz ErrorMsg; ���� ����� �������� 0, �� ������
	mov eax, pMemory;������ ���������

	xor ebx,ebx
	mov bx, [eax]
	printf ("Start bit: %d\n", ebx);
	SHL bx, 1
	printf ("Moved bit: %d\n", ebx);

	mov eax, pMemory;������ ���������
	xor ebx,ebx
	mov ebx, [eax]
	printf ("Start word: %d\n", ebx);
	SHR ebx, 3
	printf ("Moved word: %d\n", ebx);

	invoke GlobalUnlock, pMemory
	invoke GlobalFree, hMemory


	INVOKE CloseHandle, hFile
	jmp End_code
	ErrorMsg:
		printf ("File don't open!");
		invoke ExitProcess,0
	End_code:
	RET
	END START