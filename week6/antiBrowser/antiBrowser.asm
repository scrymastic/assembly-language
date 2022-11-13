



extrn CloseHandle: proc
extrn CreateWindowExA: proc
extrn DefWindowProcA: proc
extrn DispatchMessageA: proc
extrn EnumWindows: proc
extrn ExitProcess: proc
extrn KillTimer: proc
extrn LoadIconA: proc
extrn LoadCursorA: proc
extrn GetDlgItemTextA: proc
extrn GetCommandLineA: proc
extrn GetMessageA: proc
extrn GetModuleHandleA: proc
extrn GetWindowThreadProcessId: proc
extrn GetProcessImageFileNameA: proc
extrn OpenProcess: proc
extrn PostQuitMessage: proc
extrn RegisterClassExA: proc
extrn SendMessageA: proc
extrn SetDlgItemTextA: proc
extrn SetTimer: proc
extrn ShowWindow: proc
extrn TranslateMessage: proc


extrn lstrlenA: proc
extrn lstrcmpA: proc



.data
	className db "AntiBrowsers", 0
	windowName db "Anti Browsers", 0
	static db "static", 0
	windowText db "No browsers allowed while I am running", 0
	firefoxExe db "\firefox.exe", 0
	chromeExe db "\chrome.exe", 0
	msedgeExe db "\msedge.exe", 0

.data?
	wc db 80 dup (?)							; WNDCLASSEX structure
	msg db 48 dup (?)							; MSG structure
	hWindow dq ?
	buffer db 256 dup (?)
	procID dd ?
	hProc dq ?

	len dq ?


.code


WinMain proc
	push rbp
	mov rbp, rsp
	sub rsp, 60h

	mov [rbp + 10h], rcx						; hInstance
	mov [rbp + 18h], rdx						; hPrevInstance

	mov dword ptr [wc + 0h], 80					; cbSize = sizeof(WNDCLASSEX) = 80 bytes
	mov dword ptr [wc + 4h], 2 or 1					; style = CS_HREDRAW | CS_VREDRAW
	lea rcx, WndProc
	mov qword ptr [wc + 8h], rcx					; lpfnWndProc
	mov dword ptr [wc + 10h], 0					; cbClsExtra = NULL
	mov dword ptr [wc + 14h], 0					; cbWndExtra = NULL

	mov rcx, [rbp + 10h]
	mov qword ptr [wc + 18h], rcx					; hInstance

	xor rcx, rcx							; hInstance = NULL
	mov rdx, 32512							; lpIconName = IDI_APPLICATION (Default application icon)
	call LoadIconA							; LoadIconA(NULL, IDI_APPLICATION)
	mov qword ptr [wc + 20h], rax					; hIcon, just created

	xor rcx, rcx							; hInstance = NULL
	mov rdx, 32512							; lpCursorName = IDI_APPLICATION (Default application cursor)
	call LoadCursorA						; LoadCursorA(NULL, IDI_APPLICATION)
	mov qword ptr [wc + 28h], rax					; hCursor, just created

	mov qword ptr [wc + 30h], 16					; hbrBackground = COLOR_3DFACE + 1
	mov qword ptr [wc + 38h], 0					; lpszMenuName = NULL (no default menu)

	lea rcx, className
	mov qword ptr [wc + 40h], rcx					; lpszClassName

	mov rcx, qword ptr [wc + 20h]
	mov qword ptr [wc + 48h], rcx					; hIconSm = hIcon

	; registers wndclassex
	lea rcx, wc
	call RegisterClassExA
	test rax, rax
	; if failed
	jz exitWinMain

	; suceeded
	mov qword ptr [rsp + 20h], 80000000h				; X = CW_USEDEFAULT
	mov qword ptr [rsp + 28h], 80000000h				; Y = CW_USEDEFAULT
	mov qword ptr [rsp + 30h], 325					; nWidth = 325
	mov qword ptr [rsp + 38h], 100					; nHeight = 100
	mov qword ptr [rsp + 40h], 0					; hWndParent = NULL (desktop's child)
	mov qword ptr [rsp + 48h], 0					; hMenu = NULL (no menu)

	mov rcx, [rbp + 10h]
	mov qword ptr [rsp + 50h], rcx					; hInstance
	mov qword ptr [rsp + 58h], 0				 	; lpParam = NULL

	xor rcx, rcx							; dwExStyle
	lea rdx, className						; lpszClassName
	lea r8, windowName						; lpWindow
	mov r9, 0cf0000h						; dwStyle = WS_OVERLAPPEDWINDOW 
									; = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX
	call CreateWindowExA
	mov hWindow, rax

	; makes the window visible on the screen
	mov rcx, rax							; hWnd
	mov rdx, 1							; nCmdShow = SW_NORMAL
	call ShowWindow

	; gets message while running
	messageLoop:
		lea rcx, msg
		xor rdx, rdx
		xor r8, r8
		xor r9, r9
		call GetMessageA
		test rax, rax
		; if message = WM_CLOSE
		jz exitWinMain

		lea rcx, msg
		call TranslateMessage

		; sends message to WndProc
		lea rcx, msg
		call DispatchMessageA

		jmp messageLoop

	exitWinMain:
		mov rsp, rbp
		pop rbp
		ret

WinMain endp


WndProc proc
	push rbp
	mov rbp, rsp
	sub rsp, 60h

	; save parameters
	mov [rbp + 10h], rcx						; hWnd = hWindow
	mov [rbp + 18h], rdx						; the message
	mov [rbp + 20h], r8						; wParam
	mov [rbp + 28h], r9						; lParam

	mov rax, rdx

	cmp rax, 1
	; if message == WM_CREATE
	jz WM_CREATE

	cmp rax, 2
	; else if message == WM_DESTROY
	jz WM_DESTROY

	cmp rax, 113h
	; else if message == WM_TIMER
	jz WM_TIMER

	; else
	mov rcx, [rbp + 10h]
	mov rdx, [rbp + 18h]
	mov r8, [rbp + 20h]
	mov r9, [rbp + 28h]
	call DefWindowProcA

	jmp exitWndProc

	WM_CREATE:
		
		; creates a static text box
		mov qword ptr [rsp + 20h], 20				; X = 20
		mov qword ptr [rsp + 28h], 10				; Y = 10
		mov qword ptr [rsp + 30h], 270				; nWidth = 270
		mov qword ptr [rsp + 38h], 20				; nHeigth = 20

		mov rcx, [rbp + 10h]
		mov qword ptr [rsp + 40h], rcx				; hWndParent = hWindow

		mov qword ptr [rsp + 48h], 1001				; hMenu (child-window identifier)
		mov qword ptr [rsp + 50h], 0				; hInstance
		mov qword ptr [rsp + 58h], 0				; lpParam

		xor rcx, rcx						; dwExStyle
		lea rdx, static						; lpClassName
		lea r8, windowText					; lpWindowName (a string to be dislayed)
		mov r9, 50000000h					; dwStyle = WS_CHILD | WS_VISIBLE
		call CreateWindowExA


		lea rcx, EnumWindowsProc				; lpEnumFunc (a callback function)
		mov rdx, 0						; lParam (value to be passed to the callback function)
		call EnumWindows

		mov rcx, [rbp + 10h]					; hWnd = hWindow
		mov rdx, 1001						; nIDEvent (a timer identifier)
		mov r8, 5000						; uElapse (time-out value) = 5000 ms
		xor r9, r9						; lpTimerFunc = NULL (posts WM_TIMER message)
		call SetTimer

		jmp exitWndProc

	WM_DESTROY:
		mov rcx, [rbp + 10h]				  	; hWnd
		mov rdx, 1001						; uIDEvent = 1001 (same as the nIDEvent)
		call KillTimer

		xor rcx, rcx
		call PostQuitMessage

		jmp exitWndProc

	WM_TIMER:
		lea rcx, EnumWindowsProc
		xor rdx, rdx
		call EnumWindows

		jmp exitWndProc


	exitWndProc:
		mov rsp, rbp
		pop rbp
		
		ret

WndProc endp



EnumWindowsProc proc
	push rbp
	mov rbp, rsp

	sub rsp, 20h

	mov [rbp + 10h], rcx						; hWnd = a handle to a top-level window
									; sended by EnumWindows
	mov [rbp + 18h], rdx						; the value given in EnumWindows

	test rcx, rcx
	jz exitEnumWindowsProc

	lea rdx, procID							; lpdwProcessId (a variable receives procID)
	call GetWindowThreadProcessId

	mov rcx, 400h							; dwDesiredAccess = PROCESS_QUERY_INFORMATION
													        ; (required to retrieve certain information about a process)
	xor rdx, rdx							; bInheritHandle = FALSE (do not inherit the handle)
	mov r8d, procID							; dwProcessId (the identifier of the process)
	call OpenProcess
	mov hProc, rax							; return handle to process

	; retrieves the name of the exe file that created the process
	mov rcx, hProc
	lea rdx, buffer							; buffer that receives the full path to the exe file
	mov r8, 255							; sizeof buffer
	call GetProcessImageFileNameA					
	; after calling this function, buffer stores a path like "\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
	; now check if that path belongs to a browser or not
	
	lea rcx, buffer
	call lstrlenA
	mov len, rax

	; msedge.exe
	lea rcx, buffer
	add rcx, len
	sub rcx, 11							; leghtof msedgeExe
	lea rdx, msedgeExe
	call lstrcmpA
	test rax, rax
	; if this is msedge browser
	jz destroy

	; chrome.exe
	lea rcx, buffer
	add rcx, len
	sub rcx, 11							; leghtof chromeExe
	lea rdx, chromeExe
	call lstrcmpA
	test rax, rax
	; if this is chrome browser
	jz destroy

	; chrome.exe
	lea rcx, buffer
	add rcx, len
	sub rcx, 12							; lenghtof firefoxExe
	lea rdx, firefoxExe
	call lstrcmpA
	test rax, rax
	; if this is firefox browser
	jz destroy

	jmp exitEnumWindowsProc


	destroy:
		mov rcx, [rbp + 10h]
		mov rdx, 2
		xor r8, r8
		xor r9, r9
		call SendMessageA


	exitEnumWindowsProc:
		mov rcx, hProc
		call CloseHandle
		mov rax, 1
		
		mov rsp, rbp
		pop rbp

		ret

EnumWindowsProc endp


WinMainCRTStartup proc
	mov rbp, rsp
	sub rsp, 28h							; shadow space

	xor rcx, rcx
	call GetModuleHandleA						; GetModuleHandleA(NULL)
	mov rcx, rax

	call GetCommandLineA						; GetCommandLineA()
	mov r8, rax

	mov r9, 10
	xor rdx, rdx
	call WinMain

	mov rcx, rax
	call ExitProcess

WinMainCRTStartup endp

end
		
	
	

