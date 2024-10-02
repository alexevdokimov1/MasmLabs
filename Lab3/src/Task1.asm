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

.DATA ;сегмент инициализированных данных
	FileName DB "data\w_512.dat",0 ;здесь лучше указывать полный путь к файлу
	checkSumm dword 0

.DATA? ;сегмент не инициализированных данных
	hFile HANDLE ?
	hMemory DWORD ?
	pMemory DWORD ?
	memID DWORD ?
	SizeR DWORD ?
	dwBytesRead dd ?
	HW DD ?
	dwFileSize dd ?

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
	
	mov ecx, 256

	L1:
		mov bx, [eax+ecx*2];
		movsx ebx, bx;
		add checkSumm, ebx;
	loop L1

	mov eax, checkSumm;
	and eax, 0000FFFFh;

	mov ebx, eax;
	xor eax, eax;
	sub eax, ebx;

	mov checkSumm, eax;

	printf ("Check summ: %d\n", [checkSumm] );

	invoke GlobalUnlock, pMemory
	invoke GlobalFree, hMemory
	INVOKE CloseHandle, hFile

	jmp End_code
	ErrorMsg:
		printf ("File dont open!");
		invoke ExitProcess,0
	End_code:
	RET
	END START