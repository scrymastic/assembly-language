
.386
.model flat, stdcall
option casemap: none

include C:\masm32\include\masm32rt.inc
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\masm32.lib
includelib C:\masm32\lib\gdi32.lib

WndProc proto :DWORD, :DWORD, :DWORD, :DWORD
WinMain proto :DWORD, :DWORD, :DWORD, :DWORD

.const
	EditID equ 1001
	PrintID equ 1002
	IDM_HELLO equ 1001
	IDM_CLEAR equ 1002
	IDM_ABOUT equ 1003
	IDM_GETTEXT equ 1004
	IDM_EXIT equ 1005


.data
	ClassName db "MyWinCLass", 0
	AppName db "Reverse Text Box", 0
	MenuName db "Menu", 0
	TestString db "Wow! I'm in a text box now", 0
	AboutString db "This program was written by someone", 0


.data?
	hInstance HINSTANCE ?
	CommandLine LPSTR ?
	hwndEdit HWND ?
	hwndPrint HWND ?
	buffer db 512 dup (?)
	rvString db 512 dup (?)

.code

Reverse proc
	lea edi, [buffer]
	lea esi, [rvString]
	add edi, eax
    dec edi
    @loop_length:
        mov bh, byte ptr [edi]           
		mov byte ptr [esi], bh          
        inc esi                
        dec edi
        dec eax
        cmp eax, 0h
        jge @loop_length               
    mov byte ptr [esi], 0h
    ret
Reverse endp
		

WndProc proc hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	.if uMsg == WM_CREATE
		mov esi, rv(CreateMenu)
        mov edi, rv(CreateMenu)

		invoke AppendMenu, esi, MF_POPUP, edi, chr$("&Menu")
		
		invoke AppendMenu, edi, MF_STRING, IDM_HELLO, chr$("&Hello")
		invoke AppendMenu, edi, MF_STRING, IDM_CLEAR, chr$("&Clear")
        invoke AppendMenu, edi, MF_STRING, IDM_ABOUT, chr$("&About")
		invoke AppendMenu, edi, MF_STRING, IDM_EXIT, chr$("&Exit")
		
        invoke SetMenu, hWnd, esi
		
		invoke CreateWindowEx, WS_EX_CLIENTEDGE,\
				chr$("edit"), NULL,\
				WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOVSCROLL or ES_MULTILINE,\
				9, 8, 400, 40,\
				hWnd, EditID, hInstance, NULL
		mov hwndEdit, eax
		invoke CreateWindowEx, WS_EX_CLIENTEDGE,\
				chr$("edit"), NULL,\
				WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOVSCROLL or ES_READONLY or ES_NOHIDESEL or ES_MULTILINE,\
				9, 100, 400, 40,\
				hWnd, PrintID, hInstance, NULL
		mov hwndPrint, eax
		
		invoke SetFocus, hwndEdit
	.elseif uMsg == WM_COMMAND
		mov eax, wParam
		.if lParam == 0
			.if ax == IDM_HELLO
				invoke SetWindowText, hwndEdit, addr TestString
				invoke SendMessage, hWnd, WM_COMMAND, IDM_GETTEXT, NULL
			.elseif ax == IDM_CLEAR
				invoke SetWindowText, hwndEdit, NULL
				invoke SendMessage, hWnd, WM_COMMAND, IDM_GETTEXT, NULL
			.elseif ax == IDM_ABOUT
				invoke MessageBox, NULL, addr AboutString, chr$("About"), MB_OK
			.elseif ax == IDM_EXIT
				invoke PostQuitMessage, NULL
			.elseif ax == IDM_GETTEXT
				invoke GetWindowText, hwndEdit, addr buffer, 512
				invoke Reverse
				invoke SetWindowText, hwndPrint, addr rvString
			.else
				invoke DestroyWindow, hWnd
			.endif
		.else
			.if ax == EditID
				invoke SendMessage, hWnd, WM_COMMAND, IDM_GETTEXT, NULL
			.endif
		.endif

    .elseif uMsg == WM_DESTROY
		invoke PostQuitMessage, NULL
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam
		ret
	.endif
	xor eax, eax
	ret
WndProc endp

WinMain proc hInst: HINSTANCE, hPrevInst: HINSTANCE, CmdLine: LPSTR, CmdShow: DWORD
	local wc: WNDCLASSEX
	local msg: MSG
	local hwnd: HWND
	
	mov wc.cbSize, sizeof WNDCLASSEX
	mov wc.style, CS_HREDRAW or CS_VREDRAW
	mov wc.lpfnWndProc, offset WndProc
	mov wc.cbClsExtra, NULL
	mov wc.cbWndExtra, NULL
	push hInst
	pop wc.hInstance
	mov wc.hbrBackground, COLOR_WINDOW+1
	mov wc.lpszMenuName, NULL
	mov wc.lpszClassName, offset ClassName
	
	
	invoke LoadIcon, NULL, IDI_APPLICATION
	mov wc.hIcon, eax
	mov wc.hIconSm, eax
	
	invoke LoadCursor, NULL, IDC_ARROW
	mov wc.hCursor, eax
	
	invoke RegisterClassEx, addr wc
	invoke CreateWindowEx, NULL,\
			addr ClassName, addr AppName,\
			WS_OVERLAPPEDWINDOW,\
			CW_USEDEFAULT, CW_USEDEFAULT, 450, 300,\
			NULL, NULL, hInst, NULL
			
	mov hwnd, eax
	
	invoke ShowWindow, hwnd, CmdShow
	invoke UpdateWindow, hwnd
	
	.while TRUE
		invoke GetMessage, addr msg, NULL, 0, 0
		.break .if (!eax)
		
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
		
	.endw
	mov eax, msg.wParam
	ret
	
WinMain endp

start:
	invoke GetModuleHandle, NULL
	mov hInstance, eax
	invoke WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT

	invoke ExitProcess, eax
	
end start
	
