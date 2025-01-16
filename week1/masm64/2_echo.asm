

GetStdHandle proto						; retrieves a handle of the specified standard device
ReadFile proto							; read file, standard input in this case
WriteFile proto							; write file, standard output in this case
ExitProcess proto						; returns CPU control to operating system

.data
	stdInput qword -10
	stdOutput qword -11

.data?
	message db 256 dup (?)

	stdInputHandle qword ?
	bytesReaded dword ?

	stdOutputHandle qword ?
	bytesWritten dword ?

.code

main proc
	mov rbp, rsp
	sub rsp, 40									; shadow space

	; gets input handle
	mov rcx, stdInput
	call GetStdHandle
	mov stdInputHandle, rax

	; gets message
	mov rcx, stdInputHandle						; handle
	lea rdx, message							; message location
	mov r8, 256									; number of bytes to read
	lea r9, bytesReaded							; bytesReaded will store number of bytes actually readed
	mov qword ptr [rsp + 4*sizeof qword], 0		; 5th qword above return address
	call ReadFile

	; gets output handle
	mov rcx, stdOutput
	call GetStdHandle
	mov stdOutputHandle, rax

	; puts message
	mov rcx, stdOutputHandle
	lea rdx, message							; message location
	mov r8, lengthof message
	lea r9, bytesWritten
	mov qword ptr [rsp + 4*sizeof qword], 0
	call WriteFile

	xor rcx, rcx
	call ExitProcess

main endp

end

