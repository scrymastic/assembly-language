;input: a sequence
;each number is in a single line
;enter two times to get the result
;example:
;1
;2
;3
;4
;
;
;min = 1
;max = 4


.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

.data
    string1 db "min = ", 0
    string2 db 10, "max = ", 0

.data?
    
    num db 11 dup (?)
    min dd ?
    max dd ?


.code

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
    
    push 10
    push offset num
    call StdIn

    cmp byte ptr [num], 0
    je result

    mov eax, offset num
    call atoi

    mov min, eax
    mov max, eax
    
    jmp compare_loop

compare_loop:
    push 10
    push offset num
    call StdIn

    cmp byte ptr [num], 0
    je result

    mov eax, offset num
    call atoi

    cmp eax, max
    jg new_max


    jmp compare_loop

new_max:
    mov max, eax
    cmp byte ptr [num], 0
    je result
    jmp compare_loop

new_min:
    mov min, eax
    cmp byte ptr [num], 0
    je result
    jmp compare_loop

result:
    push offset string1
    call StdOut

    mov eax, min
    mov ebx, offset num
    call itoa

    push offset num
    call StdOut
    
    push offset string2
    call StdOut

    mov eax, max
    mov ebx, offset num
    call itoa

    push offset num
    call StdOut
    
    
done:
 
    push 0
    call ExitProcess

end start


