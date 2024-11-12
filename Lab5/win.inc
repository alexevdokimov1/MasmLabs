; файл win.inc 
; директивы компилятору для подключения прототипов функций
 include c:\masm32\include\kernel32.inc
 include c:\masm32\include\user32.inc
 include c:\masm32\include\gdi32.inc
 include c:\masm32\include\shlwapi.inc
 
; стандартные дескрипторы окна
 IDI_APPLICATION = 32512
 IDI_HAND        = 32513
 IDI_QUESTION    = 32514
 IDI_EXCLAMATION = 32515
 IDI_ASTERISK    = 32516
 
 ;стандартные дескрипторы курсора
 IDC_ARROW       = 32512
 IDC_IBEAM       = 32513
 IDC_WAIT        = 32514
 IDC_CROSS       = 32515
 IDC_UPARROW     = 32516
 IDC_SIZE        = 32640
 IDC_ICON        = 32641
 IDC_SIZENWSE    = 32642
 IDC_SIZENESW    = 32643
 IDC_SIZEWE      = 32644
 IDC_SIZENS      = 32645
 
 ; свойства окна
 CS_VREDRAW         = 0001h
 CS_HREDRAW         = 0002h
 CS_KEYCVTWINDOW    = 0004H
 CS_DBLCLKS         = 0008h
 CS_OWNDC           = 0020h
 CS_CLASSDC         = 0040h
 CS_PARENTDC        = 0080h
 CS_NOKEYCVT        = 0100h
 CS_SAVEBITS        = 0800h
 CS_NOCLOSE         = 0200h
 CS_BYTEALIGNCLIENT = 1000h
 CS_BYTEALIGNWINDOW = 2000h
 CS_GLOBALCLASS     = 4000h
 
 ; цвет кисти
 WHITE_BRUSH  =0
 ;прозрачное окно
 LTGRAY_BRUSH =1
 GRAY_BRUSH  =2
 DKGRAY_BRUSH =3
 BLACK_BRUSH  =4
 NULL_BRUSH  =5
 ; привычный цвет окна
 HOLLOW_BRUSH =5 
 ; структура
 WNDCLASS STRUCT  
  style             DD      ?
  lpfnWndProc       DD      ?
  cbClsExtra        DD      0
  cbWndExtra        DD      0
  hInstance         DD      ?
  hIcon             DD      ?
  hCursor           DD      ?
  hbrBackground     DD      ?
  lpszMenuName      DD      0
  lpszClassName     DD      ?
  WNDCLASS ENDS
  
 ; тип окна
 WS_OVERLAPPED =000000000h
 WS_ICONICPOPUP =0C0000000h
 WS_POPUP  =080000000h
 WS_CHILD  =040000000h
 WS_MINIMIZE  =020000000h
 WS_VISIBLE  =010000000h
 WS_DISABLED  =008000000h
 WS_CLIPSIBLINGS =004000000h
 WS_CLIPCHILDREN =002000000h
 WS_MAXIMIZE  =001000000h
 WS_CAPTION  =000C00000h ;WS_BORDER | WS_DLGFRAME
 WS_BORDER  =000800000h
 WS_DLGFRAME  =000400000h
 WS_VSCROLL  =000200000h
 WS_HSCROLL  =000100000h
 WS_SYSMENU  =000080000h
 WS_THICKFRAME =000040000h
 WS_HREDRAW  =000020000h
 WS_VREDRAW  =000010000h
 WS_GROUP  =000020000h
 WS_TABSTOP  =000010000h
 WS_MINIMIZEBOX =000020000h
 WS_MAXIMIZEBOX =000010000h
 
 ; отображение окна
 SW_HIDE   =0
 SW_SHOWNORMAL  =1
 SW_NORMAL  =1
 SW_SHOWMINIMIZED =2
 SW_SHOWMAXIMIZED =3
 SW_MAXIMIZE  =3
 SW_SHOWNOACTIVATE =4
 SW_SHOW   =5
 SW_MINIMIZE  =6
 SW_SHOWMINNOACTIVE =7
 SW_SHOWNA  =8
 SW_RESTORE  =9
 
 ; Типы сообщений
 WM_NULL                              equ 0h
 WM_CREATE                            equ 1h
 WM_DESTROY                           equ 2h 
 WM_MOVE                              equ 3h
 WM_SIZE                              equ 5h
 WM_ACTIVATE                          equ 6h
 WM_SETFOCUS                          equ 7h
 WM_KILLFOCUS                         equ 08h
 WM_ENABLE                            equ 0Ah
 WM_SETREDRAW                         equ 0Bh
 WM_SETTEXT                           equ 0Ch
 WM_GETTEXT                           equ 0Dh
 WM_GETTEXTLENGTH                     equ 0Eh
 WM_PAINT                             equ 0Fh
 WM_CLOSE                             equ 10h
 WM_QUIT                              equ 12h
 WM_KEYFIRST                          equ 100h
 WM_KEYDOWN                           equ 100h
 WM_KEYUP                             equ 101h
 WM_CHAR                              equ 102h
 WM_INITDIALOG                        equ 110h
 WM_COMMAND                           equ 111h
 WM_SYSCOMMAND                        equ 112h
 WM_TIMER                             equ 113h
 WM_HSCROLL                           equ 114h
 WM_VSCROLL                           equ 115h
 WM_MOUSEMOVE                         equ 200h
 WM_LBUTTONDOWN                       equ 201h
 WM_LBUTTONUP                         equ 202h
 WM_LBUTTONDBLCLK                     equ 203h
 WM_RBUTTONDOWN                       equ 204h
 WM_RBUTTONUP                         equ 205h
 WM_RBUTTONDBLCLK                     equ 206h
 WM_MBUTTONDOWN                       equ 207h
 WM_MBUTTONUP                         equ 208h
 WM_MBUTTONDBLCLK                     equ 209h
 WM_WINDOWPOSCHANGING                 equ 46h
 WM_WINDOWPOSCHANGED                  equ 47h
 WM_SIZING     equ 214h 
 
 
; структура сообщения
 POINT STRUCT
 x  DD ?
 y  DD ?
 POINT ENDS 
 
MSG STRUCT
   hwnd      DD      ?
   message   DD      ?
   wParam    DD      ?
   lParam    DD      ?
   time      DD      ?
   pt        POINT      <>
MSG ENDS 
 
PAINTSTRUCT STRUCT
     hdc    DWORD 0 ; дескриптор контекста окна 
     fErase DWORD 0 ; 1 – стирать фон, 0 – оставить фон окна
	 left   DWORD 0 ; левый      
	 top    DWORD 0 ; верхний      
	 right  DWORD 0 ; правый      
	 bottom DWORD 0 ; нижний угол прямоугольника для перерисовки      
	 fRes   DWORD 0 ; резервный, используется системой      
	 fIncUp DWORD 0 ; резервный, используется системой      
	 Reserv DB 32 dup(0) ; резервный, используется системой 
PAINTSTRUCT ENDS 
 
RECT STRUCT   
 left    dd      0   
 top     dd      0   
 right   dd      0   
 bottom  dd      0 
RECT ENDS 
 
SRCCOPY                              equ 0CC0020h
SRCPAINT                             equ 0EE0086h
SRCAND                               equ 8800C6h 
SRCINVERT                            equ 660046h 
SRCERASE                             equ 440328h 
 
PATCOPY                              equ 0F00021h 
PATPAINT                             equ 0FB0A09h 
PATINVERT                            equ 5A0049h 
DSTINVERT                            equ 550009h 
BLACKNESS                            equ 42h 
WHITENESS                            equ 0FF0062h 
 
PS_SOLID                             equ 0 
PS_DASH                              equ 1 
PS_DOT                               equ 2 
PS_DASHDOT                           equ 3 
PS_DASHDOTDOT                        equ 4 
PS_NULL                              equ 5 
PS_INSIDEFRAME                       equ 6 
PS_USERSTYLE                         equ 7 
PS_ALTERNATE                         equ 8 
PS_STYLE_MASK                        equ 0Fh 
PS_ENDCAP_ROUND                      equ 0h 
PS_ENDCAP_SQUARE                     equ 100h 
PS_ENDCAP_FLAT                       equ 200h 
PS_ENDCAP_MASK                       equ 0F00h 
PS_JOIN_ROUND                        equ 0h 
PS_JOIN_BEVEL                        equ 1000h 
PS_JOIN_MITER                        equ 2000h 
PS_JOIN_MASK                         equ 0F000h 
PS_COSMETIC                          equ 0h 
PS_GEOMETRIC                         equ 10000h 
PS_TYPE_MASK                         equ 0F0000h 
 
 
SM_CXSCREEN                          equ 0 
SM_CYSCREEN                          equ 1 
SM_CXVSCROLL                         equ 2 
SM_CYHSCROLL                         equ 3 
SM_CYCAPTION                         equ 4 
SM_CXBORDER                          equ 5 
SM_CYBORDER                          equ 6 
SM_CXDLGFRAME                        equ 7 
SM_CYDLGFRAME                        equ 8 
SM_CYVTHUMB                          equ 9 
SM_CXHTHUMB                          equ 10 
SM_CXICON                            equ 11 
SM_CYICON                            equ 12 
SM_CXCURSOR                          equ 13 
SM_CYCURSOR                          equ 14 
SM_CYMENU                            equ 15 
SM_CXFULLSCREEN                      equ 16 
SM_CYFULLSCREEN                      equ 17 
SM_CYKANJIWINDOW                     equ 18 
SM_MOUSEPRESENT                      equ 19 
SM_CYVSCROLL                         equ 20 
SM_CXHSCROLL                         equ 21 
SM_DEBUG                             equ 22 
SM_SWAPBUTTON                        equ 23 
SM_RESERVED1                         equ 24 
SM_RESERVED2                         equ 25 
SM_RESERVED3                         equ 26 
SM_RESERVED4                         equ 27 
SM_CXMIN                             equ 28 
SM_CYMIN                             equ 29 
SM_CXSIZE                            equ 30 
SM_CYSIZE                            equ 31 
SM_CXFRAME                           equ 32 
SM_CYFRAME                           equ 33 
SM_CXMINTRACK                        equ 34 
SM_CYMINTRACK                        equ 35 
SM_CXDOUBLECLK                       equ 36 
SM_CYDOUBLECLK                       equ 37 
SM_CXICONSPACING                     equ 38 
SM_CYICONSPACING                     equ 39 
SM_MENUDROPALIGNMENT                 equ 40 
SM_PENWINDOWS                        equ 41 
SM_DBCSENABLED                       equ 42 
SM_CMOUSEBUTTONS                     equ 43 
SM_CXFIXEDFRAME                      equ SM_CXDLGFRAME
SM_CYFIXEDFRAME                      equ SM_CYDLGFRAME 
SM_CXSIZEFRAME                       equ SM_CXFRAME 
SM_CYSIZEFRAME                       equ SM_CYFRAME 
SM_SECURE                            equ 44 
SM_CXEDGE                            equ 45 
SM_CYEDGE                            equ 46 
SM_CXMINSPACING                      equ 47 
SM_CYMINSPACING                      equ 48 
SM_CXSMICON                          equ 49 
SM_CYSMICON                          equ 50 
SM_CYSMCAPTION                       equ 51 
SM_CXSMSIZE                          equ 52 
SM_CYSMSIZE                          equ 53 
SM_CXMENUSIZE                        equ 54 
SM_CYMENUSIZE                        equ 55 
SM_ARRANGE                           equ 56 
SM_CXMINIMIZED                       equ 57 
SM_CYMINIMIZED                       equ 58 
SM_CXMAXTRACK                        equ 59 
SM_CYMAXTRACK                        equ 60 
SM_CXMAXIMIZED                       equ 61 
SM_CYMAXIMIZED                       equ 62 
SM_NETWORK                           equ 63 
SM_CLEANBOOT                         equ 67 
SM_CXDRAG                            equ 68 
SM_CYDRAG                            equ 69 
SM_SHOWSOUNDS                        equ 70 
SM_CXMENUCHECK                       equ 71 
SM_CYMENUCHECK                       equ 72 
SM_SLOWMACHINE                       equ 73 
SM_MIDEASTENABLED                    equ 74 
SM_MOUSEWHEELPRESENT         		 equ 75 
SM_CMETRICS                          equ 75 
SM_XVIRTUALSCREEN            		 equ 76 
SM_YVIRTUALSCREEN            		 equ 77 
SM_CXVIRTUALSCREEN           		 equ 78 
SM_CYVIRTUALSCREEN           		 equ 79 
SM_CMONITORS                 		 equ 80 