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

worker struc
	id dw ?
	fio db 30 dup (?)
	gender db ?
	age db ?
	standing db ?
	salary dd ?
	birthdate db 8 dup(?)
worker ends

.CONST
	maxStructAlocSize EQU 20

.DATA
	FileName DB "data\base.dat",0
	Workers worker maxStructAlocSize dup(<>);

	;task 1
	menCount dd 0
	womenCount dd 0;

.DATA?
	hFile HANDLE ?
	hMemory DWORD ?
	pMemory DWORD ?
	dwBytesRead dd ?
	dwFileSize dd ?
	count dd ?;
	
	;task 3
	summSalary dd ?

	;task2
	avgAge byte ?

	;task3
	t3result real8 ?

.CODE ;������� ����
	START:
	
	invoke SetConsoleCP, 1251
	invoke SetConsoleOutputCP, 1251

	invoke CreateFile, addr FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
	mov hFile, eax
	cmp hFile, INVALID_HANDLE_VALUE
	jz FileHandleError
	invoke GetFileSize, hFile, NULL
	mov dwFileSize, eax
	INVOKE GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, dwFileSize
	mov hMemory, eax
	invoke GlobalLock, hMemory
	mov pMemory, eax
	INVOKE ReadFile, hFile, pMemory, 2048, addr dwBytesRead, NULL
	or eax, eax
	jz FileReadError

	xor ebx, ebx;
	xor eax, eax;
	mov ax, word ptr dwBytesRead
	mov bl, SIZEOF(worker)
	idiv bl;
	mov count, eax;

	cmp count, maxStructAlocSize
	jg AlocError

	mov ecx, dwBytesRead
	mov esi, pMemory
	lea edi, Workers
	rep movsb;

	invoke GlobalUnlock, pMemory
	invoke GlobalFree, hMemory
	invoke CloseHandle, hFile

	mov ecx, 0;
	lea esi,Workers.gender
	L1:

		push ecx;
		push esi;
		mov al, byte ptr [esi]

		cmp al, 'm'
		jnz notMan;
		add menCount, 1;

		notMan:
		cmp al, 'w'
		jnz notWoman;
		add womenCount, 1;

		notWoman:
		pop esi;
		add esi, SIZEOF(worker)
		pop ecx;

		inc ecx;
		cmp ecx, count;
		JL L1;

	printf("������� 1\n���������� ������: %d\n���������� ������: %d\n", [menCount], [womenCount]);
	
	mov ecx, 0;
	lea esi,Workers.age
	xor ebx, ebx;
	L2:

		push ecx;
		push esi;
		xor eax, eax;
		mov al, byte ptr [esi]

		add bx, ax;

		pop esi;
		add esi, SIZEOF(worker)
		pop ecx;

		inc ecx;
		cmp ecx, count;
		JL L2;

	xor eax, eax
	mov ax, bx
	mov ebx, count
	idiv bl
	mov avgAge, al
	printf("������� 2\n������� �������: %d\n", [avgAge])


	FINIT
	printf("������� 3\n")

	mov ecx, 0;
	lea esi,Workers.salary
	xor ebx, ebx;
	L3:

		push ecx;
		push esi;
		mov eax, dword ptr [esi]

		add ebx, eax;

		pop esi;
		add esi, SIZEOF(worker)
		pop ecx;

		inc ecx;
		cmp ecx, count;
		JL L3;

	mov summSalary, ebx;
	printf("��������� �������� %d\n", [summSalary])
	
	fild summSalary
    fild count
	fdiv
	fst t3result

	printf("������� �������� %.1f\n", [t3result])

	printf("������� 4\n��� 7��� ����������: ")
	
	mov ecx, 0;
	L4:
		push ecx;
			lea esi,Workers[6*sizeof(worker)].fio[ecx]
			mov al, byte ptr [esi]
			printf("%c", al)
		pop ecx;
		
		inc ecx;
		cmp ecx, 30;
		JL L4;

	RET

	FileHandleError:
		printf ("���� ���������� �������!");
		invoke ExitProcess,0

	FileReadError:
		printf ("���� ���������� ���������");
		invoke ExitProcess,0

	AlocError:
		printf ("���������� �������� ������ ��� ��������� ���������� ����� %d �����������", maxStructAlocSize);
		invoke ExitProcess,0

	END START