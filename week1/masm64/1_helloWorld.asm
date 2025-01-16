

GetStdHandle proto						; retrieves a handle of the specified standard device
WriteConsoleA proto						; writes to command window
ExitProcess proto						; returns CPU control to operating system

.data
	message byte "Hello, world!", 10, 0
	bytesToWrite dword 15
	stdOutput qword -11

.data?
	stdOutputHandle qword ?
	bytesWritten dword ?

.code

main proc
	sub rsp, 32							; shadow space

	mov rcx, stdOutput
	call GetStdHandle
	mov stdOutputHandle, rax

	; displays "Hello, world!"
	mov rcx, stdOutputHandle			; handle
	lea rdx, message					; message location
	mov r8, lengthof message			; length of message
	lea r9, bytesWritten				; bytesWritten will store number of bytes actually written
	call WriteConsoleA

	xor rcx, rcx
	call ExitProcess

main endp

end

