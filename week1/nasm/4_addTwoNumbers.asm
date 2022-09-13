;bài này đang bị lỗi, không chạy được


section .text

global _start

_start:

    mov edx, 22
    lea ecx, input
    mov ebx, 0
    mov eax, 3
    int 80h
    
    lea ecx, input
    xor eax, eax
    mov ebx, 10

get_num1:
    mul ebx
    add eax, [ecx]
    sub eax, '0'
    inc ecx
    cmp byte [ecx], 32
    jne get_num1
    push eax
    
    inc ecx
    xor eax, eax

get_num2:
    mul ebx
    add eax, [ecx]
    sub eax, '0'
    inc ecx
    cmp byte [ecx], 0
    jne get_num2
    
    pop ebx
    add eax, ebx
    
    mov ebx, 10
    push 0


push_digits:
    mov ecx, eax
    div ebx
    mul ebx

    push ecx
    sub ecx, eax
    mov edx, ecx
    pop ecx

    add edx, '0'
    push edx
    
    div ebx

    cmp eax, 0
    jne push_digits
    
print:
    mov ecx, esp
    cmp byte [ecx], 0
    je finish
    mov edx, 1
    mov ebx, 1
    mov eax, 4
    int 80h

    pop eax
    

finish:
    mov eax, 1
    int 80h

section .data


segment .bss
    input: resb 22              ;ex: input = '12343 9865456'
