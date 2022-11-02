
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
	
.data
	ClassName db "MyWinCLass", 0
	AppName db "Bouncing Ball", 0
	
	colorIn COLORREF Red
	colorOut COLORREF Black
	ballSizeOut dword 35
	ballSizeIn dword 30

	vctX dd 6
	vctY dd 6

	
	firstTime db 1
.data?
	hInstance HINSTANCE ?
	CommandLine LPSTR ?
	
	ps PAINTSTRUCT <>
	hdc HDC ?
	
	hPenIn HPEN ?
	hPenOut HPEN ?
	hOldpen HPEN ?
	
	; ball position
	BallRect RECT <>
	
	buffer dword ?
	WndRect RECT <>
	
	SystemTime SYSTEMTIME <>
	tempRand dword ?
	
	randStart dword ?
	randStop dword ?
	
	tmpRect RECT <>
	
.code

RandInt proc rStart: dword, rStop: dword
	push esi
	push edx
	mov esi, rStop
	sub esi, rStart
	invoke GetSystemTime, offset SystemTime
	movzx eax, SystemTime.wMilliseconds
	xor edx, edx
	div esi
	mov eax, edx
	add eax, rStart
	
	pop edx
	pop esi
	ret
	
RandInt endp
	
	
	

MoveBall proc
	mov eax, vctX
	add BallRect.left, eax
	add BallRect.right, eax
	
	mov eax, vctY
	add BallRect.top, eax
	add BallRect.bottom, eax
	
	ret
MoveBall endp

CreateBall proc
	invoke SelectObject, hdc, hPenOut
	mov hOldpen, eax
	invoke Ellipse, hdc, BallRect.left, BallRect.top, BallRect.right, BallRect.bottom
	
	invoke SelectObject, hdc, hPenIn
	mov hOldpen, eax
	invoke Ellipse, hdc, BallRect.left, BallRect.top, BallRect.right, BallRect.bottom
	
	
	invoke MoveBall
	
	push esi
	xor esi, esi
	mov eax, ballSizeIn
	mov edi, 2
	div edi
	mov esi, eax
	.if BallRect.left <= esi
		neg vctX
	.endif
	
	add esi, 5
	.if BallRect.top <= esi
		neg vctY
	.endif
	
	mov esi, WndRect.right
	sub esi, 10
	.if BallRect.right >= esi
		neg vctX
	.endif
	
	mov esi, WndRect.bottom
	sub esi, 10
	.if BallRect.bottom >= esi
		neg vctY
	.endif
	pop esi
	ret
CreateBall endp

WndProc proc hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	.if uMsg == WM_CREATE
		invoke CreatePen, PS_SOLID, ballSizeOut, colorOut
		mov hPenOut, eax
		
		invoke CreatePen, PS_SOLID, ballSizeIn, colorIn
		mov hPenIn, eax
	
		
		invoke SetTimer, hWnd, 1001, 30, NULL
		
	.elseif uMsg == WM_PAINT
		invoke BeginPaint, hWnd, offset ps
		mov hdc, eax

		invoke GetClientRect, hWnd, offset WndRect
		
		.if (firstTime == 1)
		
			; random position
			mov eax, WndRect.right
			sub eax, WndRect.left
			sub eax, ballSizeOut
			mov randStop, eax
			invoke RandInt, ballSizeOut, randStop
			mov BallRect.left, eax
			add eax, ballSizeIn
			mov BallRect.right, eax
			
			mov eax, WndRect.bottom
			sub eax, WndRect.top
			sub eax, ballSizeOut
			mov randStop, eax
			invoke RandInt, ballSizeOut, randStop
			mov BallRect.top, eax
			add eax, ballSizeIn
			mov BallRect.bottom, eax
			
			; random direction
			invoke RandInt, 0, 4
			mov esi, eax
			.if esi == 0
				neg vctX
			.elseif esi == 1
				neg vctY
			.elseif esi == 2
				neg vctX
				neg vctY
			.else
				nop
			.endif
			
			
			mov al, 0
			mov firstTime, al
			
		.endif
		
		invoke CreateBall
		
		invoke EndPaint, hWnd, offset ps
		
	.elseif uMsg == WM_TIMER
		invoke InvalidateRect, hWnd, NULL, TRUE

	.elseif uMsg == WM_COMMAND
		nop
	
	.elseif uMsg == WM_DESTROY
		invoke KillTimer, hWnd, 1001
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
		CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,\
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
