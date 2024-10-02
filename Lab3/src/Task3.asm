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

DEBUG = 1

.DATA ;сегмент инициализированных данных
	FileName DB "data\w_512.dat",0 ;здесь лучше указывать полный путь к файлу

.DATA? ;сегмент не инициализированных данных
	hFile HANDLE ?
	hMemory DWORD ?
	pMemory DWORD ?
	hMemory2 DWORD ?
	pMemory2 DWORD ?
	dwBytesRead dd ?
	dwFileSize dd ?
	count dword ?

.CODE ;сегмент кода
	START: ;точка старта программы
	invoke CreateFile, addr FileName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL; открываем файл для чтения через API функцию
	mov hFile, eax ;возвращаем хендел файла
	cmp hFile, INVALID_HANDLE_VALUE ;проверяем на хендел файла на валидность
	jz ErrorMsg

	invoke GetFileSize, hFile, NULL ;определяем размер файла
	mov dwFileSize, eax; сохраняем размер файла в переменную

	INVOKE GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, dwFileSize; выделяем памяти столько сколько dwFileSize
	mov hMemory, eax
	invoke GlobalLock, hMemory
	mov pMemory, eax ; Возвращаем указатель на память

	;читаем данные из файла размером 2048 байт
	INVOKE ReadFile, hFile, pMemory, 2048, addr dwBytesRead, NULL ;размер чтения должен быть не болше размера стека
	; количество прочитанных байт будет возвращено в dwBytesRead
	or eax, eax ; проверяем на ошибку чтения
	jz ErrorMsg; если вывод операции 0, то ошибка
	mov eax, pMemory;Грузим указатель

	INVOKE GlobalAlloc, GMEM_FIXED or GMEM_ZEROINIT, 20048; выделяем 2048
	mov hMemory2, eax
	invoke GlobalLock, hMemory2
	mov pMemory2, eax ; Возвращаем указатель на память

	printf("Summ with numbers\n");

	mov ecx, 0;

	L1:
		mov eax,pMemory; //указатель на память с данными
		xor ebx, ebx;
		xor edx, edx;
		mov bx, [eax+ecx*2]; //считывание из памяти по адресу
		mov dx, [eax+ecx*2+1]; //считывание из памяти по адресу
			push ecx;
			push ebx;
			push edx;
			if DEBUG
				printf("%d + %d = ", bx, dx);
			endif
			pop edx;
			pop ebx;
			pop ecx;
		add bx, dx;
		mov eax, pMemory2;
		mov [eax+ecx*2], bx;

		push ecx;
		if DEBUG
			printf("%d\n", bx);
		endif
		pop ecx;

		inc ecx;
		cmp ecx, 256;
		JL L1;
		
	printf("Summ from memory\n");

	mov ecx, 0;

	L2:
		mov eax, pMemory2;
		mov bx, [eax+ecx*2];
		push ecx;
		if DEBUG
			printf ("%d\n", bx);
		endif
		pop ecx;

		inc ecx;
		cmp ecx, 256;
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