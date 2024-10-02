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

DEBUG = 1

.DATA ;������� ������������������ ������
	FileName DB "data\w_512.dat",0 ;����� ����� ��������� ������ ���� � �����

.DATA? ;������� �� ������������������ ������
	hFile HANDLE ?
	hMemory DWORD ?
	pMemory DWORD ?
	hMemory2 DWORD ?
	pMemory2 DWORD ?
	dwBytesRead dd ?
	dwFileSize dd ?
	count dword ?

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

	INVOKE GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, 20048; �������� 2048
	mov hMemory2, eax
	invoke GlobalLock, hMemory2
	mov pMemory2, eax ; ���������� ��������� �� ������

	printf("Written from file\n");

	mov ecx, 1024;
	mov count, 0;

	L1:
		mov eax,pMemory; //��������� �� ������ � �������
		xor ebx, ebx; //������� ebx
		mov ebx, [eax+ecx]; //���������� �� ������ �� ������
		mov edx, ebx; // ����������� �������� � edx
		and edx, 1; //��������
		JZ skip; �� �������� �������������(������)
			
			push ecx;
			push ebx;
			if DEBUG
				printf("%d: %d\n", [count], ebx);
			endif
			pop ebx;
			pop ecx;

			mov edx, count;
			mov eax, pMemory2;
			mov [eax+edx*4], ebx; //������ � ������ � ������ � ���������
			inc count;
		skip:
	loop L1

	printf ("Count of odd numbers: %d\n", [count]);

	mov ecx, 0;

	L2:
		mov eax, pMemory2;
		mov ebx, [eax+ecx*4];
		push ecx;
		if DEBUG
			printf ("%d: %d\n", ecx, ebx);
		endif
		pop ecx;

		
		inc ecx;
		cmp ecx, count;
		JL L2;
		

	invoke GlobalUnlock, pMemory2
	invoke GlobalFree, hMemory2

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