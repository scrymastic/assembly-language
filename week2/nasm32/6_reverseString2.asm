section .text

global _start

_start:
    
    mov edx, 256
    mov ecx, input
    mov ebx, 0
    mov eax, 3
    int 80h
    
    lea eax, input

    call print_reverse
    
    call quit
    
    

;-------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    ebx
    mov     ebx, eax

.nextchar:
    cmp     byte [eax], 0
    jz      .finished
    inc     eax
    jmp     .nextchar

.finished:
    sub     eax, ebx
    pop     ebx
    ret


;-------------------------------------------
; eax: source string
; return:
; no changes
print_reverse:
    push ebx
    push ecx
    push edx
    push eax
    
    call slen
    
    mov ecx, eax
    pop eax
    
.print_loop:

    push eax
    add eax, ecx
    dec eax
    
    call print_char
    pop eax
    dec ecx
    cmp ecx, 0
    jne .print_loop
    
    pop edx
    pop ecx
    pop ebx
    
    ret
    

;-------------------------------------------
; eax: source
; return:
; eax: source
print_char:
    push eax
    push ebx
    push ecx
    push edx
    
    mov edx, 1
    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 80h
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    ret
    

quit:
    mov ebx, 0
    mov eax, 1
    int 80h
    
    

section .data


segment .bss

    input resb 257
    
