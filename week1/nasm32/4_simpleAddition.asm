section .bss
    input: resb 22                  ; Ex: input = '1234 45677'
    
section .data

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
    
get_num1:                           ; take the digits from input string and convert them to two numbers
    xor ebx, ebx
    mov bl, [ecx]
    cmp bl, 32
    je end1
    sub bl, 48
    add eax, ebx
    
    mov ebx, 10
    mul ebx
    
    inc ecx
    
    jmp get_num1

end1:
    mov ebx, 10
    div ebx
    push eax
    
    inc ecx
    xor eax, eax
    
get_num2:
    xor ebx, ebx
    mov bl, [ecx]
    cmp bl, 48
    jl end2
    cmp bl, 57
    jg end2
    sub bl, 48
    add eax, ebx
    
    mov ebx, 10
    mul ebx
    
    inc ecx
    
    jmp get_num2

end2:
    mov ebx, 10
    div ebx
    
    pop ebx
    add eax, ebx                    ; add two numbers to get the sum
    
    mov ecx, 0
    
push_digits:                        ; push each digit in the sum onto the stack
    inc ecx
    mov edx, 0
    mov ebx, 10
    idiv ebx
    add edx, 48
    push edx
    cmp eax, 0
    jne push_digits
    
    mov edx, 1
    mov ebx, 1
    
print:                              ; take each digit from the stack and print it out
    dec ecx
    mov eax, esp
    push ecx
    mov ecx, eax
    
    push eax
    mov eax, 4
    int 80h
    
    pop eax
    pop ecx
    pop eax
    
    cmp ecx, 0
    jne print
    
quit:
    mov ebx, 0
    mov eax, 1
    int 80h
