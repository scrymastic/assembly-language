
.386
.model flat, stdcall
option casemap:none

include \masm32\include\masm32rt.inc

StdIn proto :dword, :dword
StdOut proto :dword
ExitProcess proto :dword

.data
    out1 db "CACULATOR: ", 0
    out2 db 10, "1(+) | 2(-) | 3(*) | 4(/) | 5(Exit)", 10, "Your choice: ", 0
    out3 db "first number: ", 0
    out4 db "second number: ", 0
    out5 db "result: ", 0
    out6 db "result: -", 0
    out7 db " remainder: ", 0
    out8 db "Invalid!", 0
    out9 db "Bye!", 10, 0

    choice db 0, 0, 0

.data?
    num1 dd ?
    num2 dd ?
    
    cont db 3 dup (?)
    
    str1 db 12 dup (?)
    str2 db 12 dup (?)
    str3 db 12 dup (?)

    


.code

; eax: string
; out:
; eax: number

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


; eax: num
; ebx: des
; out:
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


getNum proc

    invoke StdOut, offset out3
    invoke StdIn, offset str1, 11                   ; why do we need two lines?
    invoke StdIn, offset str1, 11                   ; It seems like the input is not working properly, maybe because of the newline character left in the buffer.


    invoke StdOut, offset out4
    invoke StdIn, offset str2, 11

    lea eax, str1
    call atoi
    mov num1, eax


    lea eax, str2
    call atoi
    mov num2, eax
    
    ret
getNum endp


start:

    invoke StdOut, offset out1
    
    .while TRUE
        invoke StdOut, offset out2
        invoke StdIn, offset choice, 2
    
        .if byte ptr [choice] == "1"
            call getNum
            mov eax, num1
            add eax, num2
    
            lea ebx, str3
            call itoa
    
            invoke StdOut, offset out5
            invoke StdOut, offset str3
 
        .elseif byte ptr [choice] == "2"
            call getNum
            mov eax, num1
            mov ebx, num2
    
            .if eax >= ebx
                sub eax, ebx
                lea ebx, str3
                call itoa
    
                invoke StdOut, offset out5
                invoke StdOut, offset str3
    
            .else
                xchg eax, ebx
                sub eax, ebx
                lea ebx, str3
                call itoa
    
                invoke StdOut, offset out6
                invoke StdOut, offset str3
    
            .endif
            
    
        .elseif byte ptr [choice] == "3"
            call getNum
            mov eax, num1
            mov ebx, num2
            mul ebx
            lea ebx, str3
            call itoa
        
            invoke StdOut, offset out5
            invoke StdOut, offset str3
            
    
        .elseif byte ptr [choice] == "4"
            call getNum
            mov eax, num1
            mov ebx, num2
            xor edx, edx
            div ebx
            push edx
            lea ebx, str3
            call itoa
    
            invoke StdOut, offset out5
            invoke StdOut, offset str3
    
            pop eax
            lea ebx, str3
            call itoa
            invoke StdOut, offset out7
            invoke StdOut, offset str3
            
        .elseif byte ptr [choice] == "5"
            invoke StdOut, offset out9
            .break

        .else
            invoke StdOut, offset out8
            invoke StdIn, offset choice, 2                  ; Same reason as two lines of "invoke StdIn, offset str1, 11"
            
        .endif

    .endw
       
    
done:
    inkey
 
    invoke ExitProcess, 0

end start
