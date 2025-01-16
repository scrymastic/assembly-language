section .text

global _start

_start:
    lea eax, num1
    call get_until_linefeed
    
    lea eax, num2
    call get_until_linefeed
    
    

    lea eax, num1
    lea ebx, num2
    lea ecx, num3
    
    call add_nums
    
    lea eax, num3
    
    call sprint

   
    call quit

;-------------------------------------------
; eax: num1
; ebx: num2
; ecx: num3 = num2 + num1
; return:
; no changes
add_nums:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov esi, eax
    mov edi, ebx
    
    
    call slen
    mov edx, eax
    sub edx, 1
    mov eax, ebx
    call slen
    mov ebx, eax
    sub ebx, 1
    
    xor ax, ax

.add_loop:

    add al, byte [esi+edx]
    add al, byte [edi+ebx]
    sub al, '0'
    sub al, '0'

    
    movzx ax, al
    push ecx
    mov cl, 10
    div cl
    pop ecx
    
    add ah, '0'
    mov byte [ecx], ah
    inc ecx
    dec edx
    dec ebx
    
    cmp edx, 0
    jl .one_left1
    
    cmp ebx, 0
    jl .one_left2
    
    jmp .add_loop
    
.one_left1:
    cmp ebx, 0
    jl .last_step
.one_left1_loop:

    add al, byte [edi+ebx]
    sub al, '0'
    
    movzx ax, al
    push ecx
    mov cl, 10
    div cl
    pop ecx
    
    add ah, '0'
    mov byte [ecx], ah
    inc ecx
    dec ebx
    

    cmp ebx, 0
    jl .last_step
    jmp .one_left1_loop
    
.one_left2:
    cmp edx, 0
    jl .last_step
.one_left2_loop:

    add al, byte [esi+edx]
    sub al, '0'
    
    movzx ax, al
    push ecx
    mov cl, 10
    div cl
    pop ecx
    
    add ah, '0'
    mov byte [ecx], ah
    inc ecx
    dec edx
    
    cmp edx, 0
    jl .last_step
    
    jmp .one_left2_loop

.last_step:
    cmp al, 0
    je .finish
    
    add al, '0'
    mov byte [ecx], al
    inc ecx
.finish:
    mov byte [ecx], 0
    
    pop edi
    pop esi
    pop edx
    pop ecx
    mov eax, ecx
    call reverse
    pop ebx
    pop eax
    
    ret
    

;-------------------------------------------
; eax: string
reverse:
    push edx
    push ecx
    push ebx
    push eax
   
    push eax

    mov ebx, eax
    call slen
    add ebx, eax
    sub ebx, 1
    pop eax
.swap_loop:

    mov cl, [eax]
    mov dl, [ebx]
    mov [eax], dl
    mov [ebx], cl

    inc eax
    dec ebx
    cmp eax, ebx
    jl .swap_loop
    
    pop eax
    pop ebx
    pop ecx
    pop edx
   
    ret
   
   


;-------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    ebx
    mov     ebx, eax

.nextchar:
    cmp     byte [eax], 0
    jz      .finished
    inc     eax
    jmp     .nextchar

.finished:
    sub     eax, ebx
    pop     ebx
    ret


;-------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen

    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret
    


;-------------------------------------------
; eax: destination
; return:
; eax: destination
; ebx: len
get_until_linefeed:
    push eax
   
    mov ebx, eax
   
.get_loop:
    call get_char
    cmp byte [eax], 0ah
    je .finish
    inc eax
    jmp .get_loop
   
.finish:
    mov byte [eax], 0

    sub eax, ebx
    mov ebx, eax
   
    pop eax
   
    ret
   
   

;-------------------------------------------
; eax: destination
; return:
; eax: destination
get_char:
    push eax
    push ebx
    push ecx
    push edx
   
    mov edx, 1
    mov ecx, eax
    mov ebx, 0
    mov eax, 3
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
    ; num1 db '1987', 0
    ; num2 db '8', 0

segment .bss
    num1 resb 22
    num2 resb 22
    num3 resb 22
    
