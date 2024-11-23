.386
.model flat, stdcall
option casemap :none   

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\gdi32.inc
include c:\masm32\include\shlwapi.inc
include c:\masm32\include\masm32rt.inc
include c:\masm32\include\fpu.inc

includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\Shlwapi.lib
includelib c:\masm32\lib\fpu.lib

WinMain proto :dword, :dword, :dword, :dword
WndProc proto :dword, :dword, :dword, :dword

.data?
	hInstance dd ?

	hEdit dd ?
	hButton dd ?
	hAnswer dd ?

	hdc  DD ?
	ps  PAINTSTRUCT <?>

	;переменные вычисления
	InXValue real10 ?
	OutFuncValue real10 ?

	fpuSaveState dw ?
.data
	;текст поля
	TEXTA db 20 dup(0)
	OutFuncValueStr db 20 dup(' ')

.const
	ClassName db 'CLASS32',0
	WindowTitle db 'Программа',0
	WindowColor equ 48200ah
	TextColor equ  0fffffah
	
	CLSEDT db 'EDIT',0  
	CPBUT db 'Рассчитать',0  
	CLSBTN db 'BUTTON',0 
	TEXT db 'STATIC',0

	WindowText db 'Посчитать sin(x)*cos(x): ',0
	XValueString db 'x=',0
	ResultString db 'Результат',0
	InputUnits db 'градусов',0

	CONST_180_VALUE real10 180.0

.code

start:
	
	finit

	mov TEXTA, '0'
	lea esi, OutFuncValueStr
	mov byte ptr [esi+1], '0'

	invoke 	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke 	WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT
	invoke	ExitProcess, eax

WinMain proc hInst:dword, hPrevInst:dword, szCmdLine:dword, nShowCmd:dword

	local 	wc 	:WNDCLASSEX
	local 	msg 	:MSG
	local 	hWnd 	:HWND

	mov	wc.cbSize, sizeof WNDCLASSEX
	mov	wc.style, CS_HREDRAW+CS_VREDRAW+CS_GLOBALCLASS
	mov wc.lpfnWndProc, WndProc
	mov wc.cbClsExtra, NULL
	mov	wc.cbWndExtra, NULL

	push	hInst
	pop 	wc.hInstance

	invoke CreateSolidBrush, WindowColor
	mov	wc.hbrBackground, eax

	mov	wc.lpszMenuName, NULL
	mov wc.lpszClassName, offset ClassName

	invoke	LoadIcon, hInst, IDI_APPLICATION
	mov	wc.hIcon, eax
	mov	wc.hIconSm, eax

	invoke	LoadCursor, hInst, IDC_ARROW
	mov	wc.hCursor, eax

	invoke	RegisterClassEx, addr wc

	invoke	CreateWindowEx, WS_EX_APPWINDOW, addr ClassName, addr WindowTitle,
				WS_CAPTION + WS_SYSMENU + WS_THICKFRAME + WS_GROUP + WS_TABSTOP, 
				CW_USEDEFAULT, CW_USEDEFAULT, 500, 300, 
				NULL, NULL, hInst, NULL

	mov	hWnd, eax

	invoke	ShowWindow, hWnd, nShowCmd
	invoke	UpdateWindow, hWnd

	MSG_LOOP:
		invoke 	GetMessage, addr msg, NULL, 0, 0
		cmp 	eax, 0
		je END_LOOP

		invoke	TranslateMessage, addr msg
		invoke	DispatchMessage, addr msg

		jmp 	MSG_LOOP

	END_LOOP:

		mov	eax, msg.wParam
		ret

WinMain endp

WndProc proc hWin :dword, uMsg :dword, 	wParam :dword,lParam:dword
	
	CMP uMsg, WM_DESTROY
		JE  DESTROY_WINDOW
	CMP uMsg, WM_CREATE
		JE  CREATE_WINDOW	
	CMP uMsg, WM_COMMAND
		JE  COMMAND_WINDOW  
	CMP uMsg, WM_PAINT
		JE  PAINT_WINDOW
	invoke	DefWindowProc, hWin, uMsg, wParam, lParam
	ret

DESTROY_WINDOW:
	invoke 	PostQuitMessage, 0
	xor	eax, eax
	ret

CREATE_WINDOW:
	INVOKE CreateWindowExA, 0, offset CLSEDT, offset TEXTA, WS_CHILD+WS_VISIBLE, 30, 50, 60, 20, hWin, 0, hInstance, 0 
	mov  hEdit,eax  
	xor eax, eax   
	INVOKE ShowWindow, hEdit, SW_SHOWNORMAL  
	 
	INVOKE CreateWindowExA, 0, offset CLSBTN, offset CPBUT, WS_CHILD+WS_VISIBLE, 10, 90, 100, 20, hWin, 0, hInstance, 0
	mov  hButton,eax
	xor  eax,eax
	INVOKE ShowWindow, hButton, SW_SHOWNORMAL      

	INVOKE CreateWindowExA, 0, offset TEXT, offset OutFuncValueStr, WS_CHILD+WS_VISIBLE, 250, 50, 100, 20, hWin, 0, hInstance, 0 
	mov hAnswer, eax
	xor  eax,eax
	INVOKE ShowWindow, hAnswer, SW_SHOWNORMAL   

	xor	eax, eax     
	ret


PAINT_WINDOW:
    INVOKE BeginPaint, hWin, offset ps
	mov hdc,eax
	INVOKE SetBkColor, hdc, WindowColor
	INVOKE SetTextColor, hdc, TextColor

	INVOKE TextOutA, hdc, 10, 20, offset WindowText, SIZEOF WindowText
	INVOKE TextOutA, hdc, 10, 50, offset XValueString, SIZEOF XValueString
	INVOKE TextOutA, hdc, 100, 50, offset InputUnits, SIZEOF InputUnits
	INVOKE TextOutA, hdc, 170, 50, offset ResultString, SIZEOF ResultString

	INVOKE EndPaint, hdc, offset ps
	xor	eax, eax
	ret

COMMAND_WINDOW:
	mov eax, hButton  
	cmp lParam,eax   
	jne EXIT_COMAND

    INVOKE SendMessage, hEdit, WM_GETTEXT, 20, offset TEXTA
	INVOKE FpuAtoFL, offset TEXTA, offset InXValue, DEST_MEM

	fsave fpuSaveState

	fld CONST_180_VALUE
	fldpi
	fdiv st(0), st(1)
	
	fld InXValue
	fmul st(0), st(1)

	fcos
	
	fld InXValue
	fmul st(0), st(2)

	fsin

	fmul st(0), st(1)

	fstp OutFuncValue

	frstor fpuSaveState

	INVOKE FpuFLtoA,addr OutFuncValue,6,offset OutFuncValueStr, SRC1_REAL or SRC2_DIMM	
	INVOKE SetWindowTextA, hAnswer, offset OutFuncValueStr

EXIT_COMAND:   
	 xor	eax, eax
	 ret

WndProc endp

end start