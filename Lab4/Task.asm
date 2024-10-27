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

worker struc ;информация о сотруднике
	id dw ?
	fio db 30 dup (?) ;фамилия, имя, отчество
	gender db ?;пол
	age db ?;возраст
	standing db ?;стаж
	salary dd ?;оклад 
	birthdate db 8 dup(?) ;дата рождения
worker ends

.CONST 
	ten dd 10
.DATA ;сегмент инициализированных данных
	FileName DB "data\base.dat",0
	Workers worker 10 dup(<>);

	;task 1
	menCount dd 0
	womenCount dd 0;

	;task2
	avgAge byte ?

	;task3
	t3result real8 ?

.DATA? ;сегмент не инициализированных данных
	hFile HANDLE ?
	hMemory DWORD ?
	pMemory DWORD ?
	dwBytesRead dd ?
	dwFileSize dd ?
	;task 3
	summSalary dd ?

.CODE ;сегмент кода
	START:
	invoke CreateFile, addr FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
	mov hFile, eax
	cmp hFile, INVALID_HANDLE_VALUE
	jz Error
	invoke GetFileSize, hFile, NULL
	mov dwFileSize, eax
	INVOKE GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, dwFileSize
	mov hMemory, eax
	invoke GlobalLock, hMemory
	mov pMemory, eax
	INVOKE ReadFile, hFile, pMemory, 2048, addr dwBytesRead, NULL
	or eax, eax
	jz Error

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
		cmp ecx, 10;
		JL L1;

	printf("Task1\nMen count is %d\tWomen count is %d\n", [menCount], [womenCount]);
	
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
		cmp ecx, 10;
		JL L2;

	xor eax, eax
	mov ax, bx
	mov bl, 10
	idiv bl
	mov avgAge, al
	printf("Task2\nAvg age is %d\n", [avgAge])


	FINIT
	printf("Task 3\n")

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
		cmp ecx, 10;
		JL L3;

	mov summSalary, ebx;
	printf("Salary summ is %d\n", [summSalary])
	
	fild dword ptr summSalary
    fild dword ptr ten

	fdiv

	fst t3result

	printf("Avg sallary is %f\n", [t3result])

	printf("Task 4\n7-th worker name is ")
	
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

	Error:
		printf ("File can't be opened!");
		invoke ExitProcess,0

	END START