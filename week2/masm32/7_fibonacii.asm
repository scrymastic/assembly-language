

.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

.data
    lf db 10, 0

.data?
    
    num1 db 22 dup (?)
    num2 db 22 dup (?)
    num3 db 22 dup (?)
    N_str db 4 dup (?)
    N_int dd ?
    count dd ?


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



;eax: des
;ebx: src
copy proc
    push eax
    push ebx
    push ecx
    push edx
    
    xor edx, edx
    
_copy_loop:
    
    mov cl, byte ptr [ebx+edx]
    mov byte ptr [eax+edx], cl
    
    cmp cl, 0
    je _finish
    inc edx
    jmp _copy_loop
    
_finish:
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    ret

copy endp


;eax: string
;out:
;eax: number

atoi proc
    push ebx
    push ecx
    push edx
    push esi
    mov esi, eax
    mov eax, 0
    mov ecx, 0

    mul_loop:
        xor ebx, ebx
        mov bl, byte ptr [esi+ecx]
        
        cmp bl, 48
        jl finish

        cmp bl, 57
        jg finish

        sub bl, 48
        mov edx, 10
        mul edx
        add eax, ebx
        inc ecx
        jmp mul_loop
    finish:
        pop esi
        pop edx
        pop ecx
        pop ebx

        ret

atoi endp


;eax: num
;ebx: des
;out:
;

itoa proc
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    mov esi, ebx

    mov ecx, 0
    mov ebx, 10

    div_loop:
        xor edx, edx
        div ebx
        add dl, 48
        mov byte ptr [esi+ecx], dl
        inc ecx

        test eax, eax
        jne div_loop
    mov byte ptr [esi+ecx], 0
    mov eax, esi
    call reverse

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

itoa endp



;eax: string
;
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
    push 3
    push offset N_str
    call StdIn

    
    mov eax, offset N_str
    call atoi

    mov N_int, eax
    
    mov byte ptr [num1], '0'
    mov byte ptr [num1+1], 0
    mov byte ptr [num2], '1'
    mov byte ptr [num2+1], 0
    
_N0:
    mov count, eax
    cmp count, 0
    je done
    
_N1:
    push offset num1
    call StdOut

    cmp count, 1
    je done

_N2:
    push offset lf
    call StdOut
    
    push offset num2
    call StdOut
    
    cmp count, 2
    je done
    
    mov count, 2
_fibo_loop:

    push offset lf
    call StdOut

    mov eax, offset num1
    mov ebx, offset num2
    mov ecx, offset num3
    call add_nums
    
    push offset num3
    call StdOut

    
    mov eax, offset num1
    mov ebx, offset num2
    call copy
    
    mov eax, offset num2
    mov ebx, offset num3
    call copy
    
    inc count
    push eax
    mov eax, count  
    cmp eax, N_int
    je done
    pop eax
    
    jmp _fibo_loop
    
    
done:
    pop eax
    push 0
    call ExitProcess

end start
