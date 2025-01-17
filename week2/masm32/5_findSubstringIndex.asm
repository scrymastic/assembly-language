

.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

.data
    out1  db "S = ", 0
    out2  db "C = ", 0
    space dd " ", 0


.data?
    stringS db 101 dup (?)
    stringC db 11 dup (?)
    temp    db 4 dup (?)
    _len  dd ?


.code

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


;-------------------------------------------
; eax: string
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


;-------------------------------------------
; eax: src
; ebx: substring
; out:
; eax: src
; ebx: substring
; ecx: 1 or 0

compare_at proc
    push eax
    push ebx
    push esi
    push edi

    mov esi, eax
    mov edi, ebx

    mov ecx, -1
_compare_loop:
    inc ecx
    mov bl, byte ptr [edi+ecx]
    cmp bl, 0
    je _true

    cmp bl, byte ptr [esi+ecx]
    je _compare_loop
    jmp _false
    
_true:
    mov ecx, 1
    jmp _finish

_false:
    mov ecx, 0
    jmp _finish

_finish:
    pop edi
    pop esi
    pop ebx
    pop eax

    ret

compare_at endp

match proc
    cmp ecx, 1
    jne _finish
    push edx
    push eax
    push ebx
    mov eax, edx
    mov ebx, offset temp
    
    call itoa

    push ebx
    call StdOut

    push offset space
    call StdOut

    pop ebx
    pop eax
    pop edx

_finish:
    ret

match endp


;-------------------------------------------
; eax: string
; out:
; eax: len
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
    push offset out1
    call StdOut

    push 100
    push offset stringS
    call StdIn

    mov eax, offset stringS
    call slen

    mov _len, eax

    push offset out2
    call StdOut

    push 10
    push offset stringC
    call StdIn

    mov eax, offset stringS
    mov ebx, offset stringC

    mov edx, -1

_find_index:
    inc edx
    push eax
    add eax, edx
    call compare_at

    pop eax
    call match

    cmp edx, _len
    jl _find_index

    call ExitProcess
    
end start
