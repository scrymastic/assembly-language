;input: a sequence
;each number is in a single line
;press enter two times to get the result
;example:
;1
;2
;3
;4
;5
;
;
;sum of odds: 9
;sum of evens: 6

.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

.data
    string1 db "sum of odds: ", 0
    string2 db 10, "sum of evens: ", 0

.data?
    
    num db 11 dup (?)
    sumOdds dd ?
    sumEvens dd ?


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

;eax: num_str
;out:
;eax: even 0, odd 1

odd_or_even proc
    push ebx
    mov ebx, eax
    call slen
    add eax, ebx
    dec eax

    mov bl, byte ptr [eax]

    cmp bl, '0'
    je _even
    cmp bl, '2'
    je _even
    cmp bl, '4'
    je _even
    cmp bl, '6'
    je _even
    cmp bl, '8'
    je _even

    jmp _odd

_odd:
    mov eax, 1
    jmp _done

_even:
    mov eax, 0
    jmp _done

_done:
    pop ebx
    ret

odd_or_even endp


start:
    xor eax, eax
    mov sumOdds, eax
    mov sumEvens, eax

_add_loop:

    push 10
    push offset num
    call StdIn

    cmp byte ptr [num], 0
    je result

    mov eax, offset num
    call odd_or_even

    cmp eax, 0
    je _add_even

    jmp _add_odd
    

_add_even:
    mov eax, offset num
    call atoi
    add sumEvens, eax

    jmp _add_loop

_add_odd:
    mov eax, offset num
    call atoi
    add sumOdds, eax

    jmp _add_loop

result:
    push offset string1
    call StdOut

    mov eax, sumOdds
    mov ebx, offset num
    call itoa

    push offset num
    call StdOut
    
    push offset string2
    call StdOut

    mov eax, sumEvens
    mov ebx, offset num
    call itoa

    push offset num
    call StdOut
    
    
done:
 
    push 0
    call ExitProcess

end start
