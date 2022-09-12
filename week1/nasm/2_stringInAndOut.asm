
section .data

section .bss
    input: resb 32                  ;reserve a 32 byte space in memory for input string
    
section .text
global _start
_start:
    mov edx, 32                     ;number of bytes to read
    mov ecx, input                  ;ecx stores address of input
    mov ebx, 0                      ;write to the stdin file
    mov eax, 3                      ;invoke sys_read (kernel opcode 3)
    int 80h                         ;
    
    mov edx, 1                      ;read first character of input
    mov ecx, input                  ;
    mov ebx, 1                      ;
    mov eax, 4                      ;
    int 80h                         ;
    
nextchar:                           ;read remaining characters of input
    inc ecx                         ;increment the address in ecx by 1 byte to get the next character of input string
    cmp byte [ecx], 0               ;if the byte pointed to by ecx is 0, we reach the end of input string, then finish the program
    je finish                       ;
    mov eax, 4                      ;read character pointed to by ecx (kernel opcode 4)
    int 80h                         ;
    jmp nextchar                    ;jump to the point labeled 'nextchar'
    
finish:                             ;finish the program and return the control to operating system
    mov eax, 1                      ;kernel opcode 1
    int 80h                         ;
