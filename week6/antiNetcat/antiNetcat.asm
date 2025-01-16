



section .data
path db "/usr/bin/killall", 0
arg1 db "nc", 0
arg2 db "netcat", 0

argv dq path, arg1, arg2, 0



timeval:
	tv_sec dq 10						; Number of whole seconds of elapsed time
	tv_usec dq 0						; Number of microseconds of rest of elapsed time minus tv_sec. Always less than one million


section .text
global _start

_start:
.loop:
	mov rdi, timeval					; time sleep = 10s and 0 ns
	xor rsi, rsi
	mov rax, 35							; syscall nanosleep
	syscall
	
	
	mov rax, 57							; syscall fork()
	syscall
	; fork() creates a new process by duplicating the calling process
	; The calling process is called parent process, the new process is child process
	; On success, the ID of the child process is returned in the parent, and 0 is returned in the child
	
	cmp rax, 0
	; if this is child process
	jz killNetcat
	
	; else
	jmp .loop

killNetcat:
	
	mov rdi, path
	mov rsi, argv
	mov rdx, 0
	mov rax, 59							; syscall execve: killall nc netcat
	syscall


	
exit:
	mov rdi, 0
	mov rax, 60							; syscall exit
	syscall
	



