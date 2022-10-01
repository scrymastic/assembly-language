

.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

.data



.data?
    num1 db 22 dup (?)
    num2 db 22 dup (?)
    num3 db 22 dup (?)


.code

;eax: num1
;ebx: num2
;ecx: num3 = num2 + num1
;return:
;no changes
add_nums proc
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

_add_loop:

    add al, byte ptr [esi+edx]
    add al, byte ptr [edi+ebx]
    sub al, '0'
    sub al, '0'

    
    movzx ax, al
    push ecx
    mov cl, 10
    div cl
    pop ecx
    
    add ah, '0'
    mov byte ptr [ecx], ah
    inc ecx
    dec edx
    dec ebx
    
    cmp edx, 0
    jl _one_left1
    
    cmp ebx, 0
    jl _one_left2
    
    jmp _add_loop
    
_one_left1:
    cmp ebx, 0
    jl _last_step
_one_left1_loop:

    add al, byte ptr [edi+ebx]
    sub al, '0'
    
    movzx ax, al
    push ecx
    mov cl, 10
    div cl
    pop ecx
    
    add ah, '0'
    mov byte ptr [ecx], ah
    inc ecx
    dec ebx
    

    cmp ebx, 0
    jl _last_step
    jmp _one_left1_loop
    
_one_left2:
    cmp edx, 0
    jl _last_step
_one_left2_loop:

    add al, byte ptr [esi+edx]
    sub al, '0'
    
    movzx ax, al
    push ecx
    mov cl, 10
    div cl
    pop ecx
    
    add ah, '0'
    mov byte ptr [ecx], ah
    inc ecx
    dec edx
    
    cmp edx, 0
    jl _last_step
    
    jmp _one_left2_loop

_last_step:
    cmp al, 0
    je _finish
    
    add al, '0'
    mov byte ptr [ecx], al
    inc ecx
_finish:
    mov byte ptr [ecx], 0
    
    pop edi
    pop esi
    pop edx
    pop ecx
    mov eax, ecx
    call reverse
    pop ebx
    pop eax
    
    ret

add_nums endp
    
reverse proc
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

    swap_loop:
        mov cl, byte ptr [eax]
        mov dl, byte ptr [ebx]
        mov byte ptr [eax], dl
        mov byte ptr [ebx], cl

        inc eax
        dec ebx
        cmp eax, ebx
        jl swap_loop

    pop eax
    pop ebx
    pop ecx
    pop edx

    ret

reverse endp
    


;eax: string
;out:
;eax: len
slen proc
    push ebx
    mov ebx, eax

    next_char:
        cmp byte ptr [eax], 0
        je finish
        inc eax
        jmp next_char

    finish:
        sub eax, ebx
        pop ebx
        ret

slen endp

start:
    push 20
    push offset num1
    call StdIn

    push 20
    push offset num2
    call StdIn

    mov eax, offset num1
    mov ebx, offset num2
    mov ecx, offset num3
    call add_nums

    push offset num3
    call StdOut

    inkey

    push 0
    call ExitProcess

end start
