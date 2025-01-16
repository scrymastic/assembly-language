
section .data

section .bss
    input: resb 32                  ; reserva a 32 byte space in memory for input string
    
section .text
global _start
_start:
    mov edx, 32                     ; number of bytes to read
    lea ecx, input                  ; ecx stores address of input
    mov ebx, 0                      ; write to the stdin file
    mov eax, 3                      ; invoke sys_read (kernel opcode 3)
    int 80h
    
    mov edx, 1                      ; following part of program will print each character in input string
    mov ebx, 1                      ; write to the stdout file

    lea ecx, input                  ; load the address of input into ecx
    cmp byte [ecx], 97              ; if the character is not lowercase, jump to print1
    jl print1
    cmp byte [ecx], 122
    jg print1
    jmp print2                      ; if not, jump to print2
    
nextchar:                           ; print remaining character of input, one by one
    inc ecx                         ; increment the address in ecx by 1 byte to get the next character of input string
    cmp byte [ecx], 0               ; if the byte pointed to by ecx is 0, we reach the end of input string, then finish the program
    je finish                       ;
    cmp byte [ecx], 97              ; if the character is not lowercase, jump to print1
    jl print1
    cmp byte [ecx], 122
    jg print1
    jmp print2                      ; if not, jump to print2

    
print1:                             ; print character pointed to by ecx
    mov eax, 4
    int 80h
    jmp nextchar

print2:
    push ecx                        ; push the value in ecx onto the stack to preserve it while we use ecx
    mov eax, [ecx]                  ; eax stores the character at address pointed to by ecx
    sub eax, 32                     ; this character is lowercase, we will convert it into uppercase
    push eax                        ; push eax into stack, so we can get its address by using esp register
    mov ecx, esp
    mov eax, 4
    int 80h                         ; print the character, now in lowercase
    pop eax                         ; pop the value on the stack back into eax
    pop ecx                         ; and ecx
    jmp nextchar                    ; jump to 'nextchar'
    
    
finish:
    mov eax, 1
    int 80h

