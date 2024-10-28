.686P
.MODEL FLAT, STDCALL
.STACK 4096 ;размер стека

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

	;task2
	avgAge byte ?
	
	;task 3
	summSalary dd ?

	;task3
	t3result real8 ?

	;task 4
	seventhWorker byte 30 dup(?),0

.CODE ;сегмент кода
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

	printf("Задание 1\nКоличество мужчин: %d\nКоличество женщин: %d\n", [menCount], [womenCount]);
	
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
	printf("Задание 2\nСредний возраст: %d\n", [avgAge])


	FINIT
	printf("Задание 3\n")

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
	printf("Суммарная зарплата %d\n", [summSalary])
	
	fild summSalary
    fild count
	fdiv
	fst t3result

	printf("Средняя зарплата %.1f\n", [t3result])

	printf("Задание 4\nФИО 7-ого сотрудника: ")
	
	mov ecx, 0;
	lea esi,Workers.id
	L4:
		mov al, [esi]

		cmp al, 7
		jz Found
		add esi, SIZEOF(worker)

		inc ecx;
		cmp ecx, count;
		JL L4;
	jmp NotFound

		Found:
		lea esi,Workers.fio
		mov eax, SIZEOF(worker)
		mul cx
		add esi, eax

		mov ecx, 0;
		L5:
			mov al, [esi]
			lea edx, seventhWorker
			add edx, ecx
			mov [edx], al
			add esi, 1
			inc ecx;
			cmp ecx, 30;
			JL L5;
		printf("%s", addr seventhWorker)
		NotFound:

	RET

	FileHandleError:
		printf ("Файл невозможно открыть!");
		invoke ExitProcess,0

	FileReadError:
		printf ("Файл невозможно прочитать");
		invoke ExitProcess,0

	AlocError:
		printf ("Невозможно выделить память под структуру содержащую более %d сотрудников", maxStructAlocSize);
		invoke ExitProcess,0

	END START