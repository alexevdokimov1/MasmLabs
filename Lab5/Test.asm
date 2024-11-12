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
	hInstance 		dd ?
	lpszCmdLine		dd ?

	hEdit dd ?
	hButton dd ?

	hdc  DD ?
	ps  PAINTSTRUCT <?> 
.data
	ClassName db 'CLASS32',0
	WindowTitle db '���������',0
	WindowColor equ 48285ah
	;����
	CLSEDT db 'EDIT',0  
	TEXTA db 20 dup(0)
	
	;������
	CPBUT db '����������',0  
	CLSBTN db 'BUTTON',0  
	;���������� ����������
	InXValue real10 ?
	OutFuncValue real10 ?
	OutFuncValueStr db 8 dup(' ')
.const
	WindowText db '��������� sin(x)*cos(x): ',0
	XValueString db 'x=',0
	ResultString db '���������'
.code

start:
	
	finit

	mov TEXTA, '0'

	invoke 	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke	GetCommandLine
	mov	lpszCmdLine, eax

	invoke 	WinMain, hInstance, NULL, lpszCmdLine, SW_SHOWDEFAULT
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
				CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, 
				NULL, NULL, hInst, NULL

	mov	hWnd, eax

	invoke	ShowWindow, hWnd, nShowCmd
	invoke	UpdateWindow, hWnd

MSG_LOOP:
	invoke 	GetMessage, addr msg, NULL, 0, 0
	cmp 	eax, 0
	je 	END_LOOP

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
	mov  hEdit,eax  ; ���������� �����������   
	mov  eax,0   
	INVOKE ShowWindow, hEdit, SW_SHOWNORMAL  
	 
	INVOKE CreateWindowExA, 0, offset CLSBTN, offset CPBUT, WS_CHILD+WS_VISIBLE, 10, 90, 100, 20, hWin, 0, hInstance, 0
	mov  hButton,eax   ; ���������� �����������   
	mov  eax,0   
	INVOKE ShowWindow, hButton, SW_SHOWNORMAL      
	
	MOV EAX, 0      
	ret


PAINT_WINDOW:
    INVOKE BeginPaint, hWin, offset ps
	mov hdc,eax  
	INVOKE SetBkColor, hdc, WindowColor

	INVOKE TextOutA, hdc, 10, 20, offset WindowText, SIZEOF WindowText
	INVOKE TextOutA, hdc, 10, 50, offset XValueString, SIZEOF XValueString

	INVOKE TextOutA,hdc, 100, 50, offset ResultString, SIZEOF ResultString
	INVOKE TextOutA,hdc, 180, 50, offset OutFuncValueStr, SIZEOF OutFuncValueStr
	INVOKE EndPaint, hdc, offset ps
	MOV EAX, 0
	ret


COMMAND_WINDOW:   
	mov eax, hButton  
	cmp lParam,eax   
	jne EXIT_COMAND

    INVOKE SendMessage, hEdit, WM_GETTEXT, 20, offset TEXTA
	INVOKE FpuAtoFL, offset TEXTA, offset InXValue, DEST_MEM

	fld InXValue;
	fcos

	fld InXValue;
	fsin

	fmul st(0), st(1)

	fstp OutFuncValue

	invoke FpuFLtoA,addr OutFuncValue,6,offset OutFuncValueStr, SRC1_REAL or SRC2_DIMM
	INVOKE TextOutA,hdc, 100, 50, offset ResultString, SIZEOF ResultString
	INVOKE TextOutA,hdc, 180, 50, offset OutFuncValueStr, SIZEOF OutFuncValueStr

EXIT_COMAND:   
	 MOV EAX, 0
	 ret

WndProc endp

end start