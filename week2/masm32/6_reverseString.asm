.386 
.model flat, stdcall 
option casemap:none 

include C:\masm32\include\masm32rt.inc
.data

.data?

   string db 33 dup (?)

.code

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
    
    push 32                       
    push offset string           
    call StdIn   
    
    mov eax, offset string
    call reverse        

    push offset string       
    call StdOut
    
    call ExitProcess
end start


