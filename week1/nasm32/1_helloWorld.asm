section .data
    msg db 'Hello World!'           ; message to be printed
    len equ $ - msg                 ; length of the message
    
section .text
global _start
_start:
    mov edx, len                    ; edx stores len - number of bytes to write
    mov ecx, msg                    ; ecx stores address of msg
    mov ebx, 1                      ; write to the stdout file
    
    mov eax, 4                      ; these two lines invoke sys_write
    int 80h                         ;
    
    mov ebx, 0                      ; return 0 - no errors
    mov eax, 1                      ; these two lines invoke sys_exit
    int 80h                         ;
