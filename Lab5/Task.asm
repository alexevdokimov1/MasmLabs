.586
.MODEL FLAT, stdcall

include win.inc
include console.inc 

includelib c:\masm32\lib\Shlwapi.lib

include c:\masm32\include\msvcrt.inc
includelib c:\masm32\lib\msvcrt.lib

.data  
	BACKGROUND equ 48285ah
	TEXT equ 0ffffffh
    HWND      DD 0 ; дескриптор главного окна!
    HINST   DD 0 ; дескриптор приложения  !
    TITL  DB "Программа",0  
    CLASSNAME DB 'CLASS32',0
    Message   MSG <?>      
    WC        WNDCLASS  <?>
   
    CPBUT db 'Рассчитать',0  
    CLSBTN db 'BUTTON',0  
    CLSEDT db 'EDIT',0  
    CAP  db 'Сообщение',0
    TEXTA db 20 dup(0) ; текст в полях редактирования      
    TEXTB db 20 dup(0)
	valueFromField real8 ?;

	hBut DD ? ; дескриптор кнопки  
	hedt1 DD ? ; дескриптор поля 1  
	hdc  DD ? ; дескриптор контекста окна
	ps  PAINTSTRUCT <?>  
	mess1 db 'Посчитать sin(x)*cos(x): ',0 ; надпись в окне   
	mess1_len equ $-mess1-1   
	mess2 db '=',10 dup(' '),0 ; результат суммы строковый   
	sum_len   equ $-mess2-1

.code
	START:

	FINIT

	INVOKE GetModuleHandle, 0
	MOV HINST, EAX

	MOV WC.style, CS_HREDRAW+CS_VREDRAW+CS_GLOBALCLASS ; процедура обработки сообщений      
    MOV WC.lpfnWndProc, OFFSET WNDPROC ;процедура обработки кода окна должна быть представлена в коде (пример процедуры будет приведен ниже)
	MOV EAX, HINST
	MOV WC.hInstance, EAX  
	INVOKE LoadIcon, 0, IDI_APPLICATION  ;грузит иконки    
	MOV  WC.hIcon, EAX  
	INVOKE LoadCursor, 0, IDC_ARROW   ;грузит курсор   
	MOV  WC.hCursor, EAX  
	INVOKE CreateSolidBrush, BACKGROUND ;создает кисть для заполнения фона окна
	MOV  WC.hbrBackground, EAX      
	MOV DWORD PTR WC.lpszMenuName, 0      
	MOV DWORD PTR WC.lpszClassName, OFFSET CLASSNAME  

	INVOKE RegisterClass, OFFSET WC
	INVOKE CreateWindowEx, 0, OFFSET CLASSNAME, OFFSET TITL, 
	WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_GROUP + WS_TABSTOP, 100, 100, 400, 450, 0, 0, HINST,0
	CMP EAX, 0  ; проверка на ошибку      
	JZ  END_LOOP      
	MOV HWND, EAX ; дескриптор окна 
    INVOKE ShowWindow, HWND, SW_SHOWNORMAL ; показать созданное окно  
    INVOKE UpdateWindow, HWND ;перерисовать видимую часть окна 

	MSG_LOOP:  
      INVOKE GetMessage, OFFSET Message, 0,0,0      
	  CMP EAX, 0      
	  JE  END_LOOP  
	  INVOKE TranslateMessage, OFFSET Message
	  INVOKE DispatchMessageA, OFFSET Message
	  JMP MSG_LOOP 
	END_LOOP:  
	  INVOKE ExitProcess, Message.wParam ; выход из программы 

WNDPROC  PROC hW:DWORD, Mes:DWORD, wParam:DWORD, lParam:DWORD      
     CMP Mes, WM_DESTROY  ;будет выполняться при закрытии окна     
	 JE  WMDESTROY
	 CMP Mes, WM_CREATE ; при создании окна      
	 JE  WMCREATE      
	 CMP Mes, WM_COMMAND ; общие команды (сообщения) 
	 JE  WMCOMMAND      
	 CMP Mes, WM_PAINT ; события перерисовки формы окна      
	 JE  WMPAINT      
	 JMP DEFWNDPROC 

WMCREATE:       ; создание окна    
	INVOKE CreateWindowExA, 0, offset CLSEDT, offset TEXTA, WS_CHILD+WS_VISIBLE, 10, 50, 60, 20, hW, 0, HINST, 0
	mov  hedt1,eax  ; сохранение дескриптора   
	mov  eax,0   
	INVOKE ShowWindow, hedt1, SW_SHOWNORMAL   

	INVOKE CreateWindowExA, 0, offset CLSBTN, offset CPBUT, WS_CHILD+WS_VISIBLE, 10, 90, 100, 20, hW, 0, HINST, 0
	mov  hBut,eax   ; сохранение дескриптора   
	mov  eax,0   
	INVOKE ShowWindow, hBut, SW_SHOWNORMAL      
	
	MOV EAX, 0      
	JMP FINISH

WMCOMMAND:   ; обработка нажатия кнопки   
	mov eax, hBut   
	cmp lParam,eax    
	jne COM_END  ; команда не соответствует нажатию кнопки

    INVOKE SendMessage, hedt1, WM_GETTEXT, 20, offset TEXTA

    INVOKE crt_atof, offset valueFromField, addr TEXTA
 
    mov eax, sum_len
	INVOKE TextOutA, hdc, 180, 50, offset mess2, eax 
	;printf("%f", [ValueFromField])
	;INVOKE _gcvt, ValueFromField, offset mess2+1
	INVOKE LENSTR, offset mess2 ; определение длины результата  
	push eax  
	INVOKE TextOutA, hdc, 180, 50, offset mess2, eax  
	pop ecx   ; очистка строки  
	inc ecx  
	mov al,' '  
	mov edi, offset mess2+1 
CLR: mov [edi],al  
	 inc edi
	 loop CLR 

COM_END:   
	 MOV EAX, 0
	 JMP FINISH 

WMPAINT:
    INVOKE BeginPaint, hW, offset ps
	mov hdc,eax  
	INVOKE SetBkColor, hdc,  BACKGROUND
	
	INVOKE SetTextColor, hdc, TEXT

    mov eax, mess1_len
	INVOKE TextOutA, hdc, 10, 20, offset mess1, eax
	INVOKE EndPaint, hdc, offset ps      
	MOV EAX, 0      
	JMP FINISH 

DEFWNDPROC:
	INVOKE DefWindowProc, hW, Mes, wParam, lParam       
	JMP FINISH 

WMDESTROY:
	INVOKE PostQuitMessage, 0      
	MOV EAX, 0 

FINISH: ret  
WNDPROC ENDP 
END START 
