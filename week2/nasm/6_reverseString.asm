
section .text

global _start

_start:
    mov edx, 256
    lea ecx, input
    mov ebx, 0
    mov eax, 3
    int 80h
   
    lea esi, input
    xor ecx, ecx
   
push_chars:    
    xor ebx, ebx
    mov bl, byte [esi+ecx]
    cmp bl, 0
    je print
    inc ecx
    push ebx
    jmp push_chars


print:
    dec ecx
    mov eax, esp

    call print_char
   
   
    pop eax
    cmp ecx, 0
   
    jne print
   
    call print_lf
    call quit
   
   

print_char:
    push edx
    push ecx
    push ebx
    push eax
   
    mov edx, 1
    pop eax
    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 80h
   
    pop ebx
    pop ecx
    pop edx
   
    ret

print_lf:
    push eax
    push ebx
    push ecx
    push edx
   
    mov eax, 10
    push eax
    mov ecx, esp
    mov edx, 1
    mov ebx, 1
    mov eax, 4
    int 80h
   
    pop eax
    pop edx
    pop ebx
    pop ecx
    pop eax
   
    ret

quit:
    mov ebx, 0
    mov eax, 1
    int 80h
   
    ret



section .data

section .bss
    input: resb 256

    
