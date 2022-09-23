section .text

global _start

_start:
    lea eax, str1
    call sprint
    
cal_loop:
    call menu
    
    lea eax, [cal]
    call get_char
    
    mov dl, [cal]
    cmp dl, '1'
    je .addi
    
    cmp dl, '2'
    je .subt
    
    cmp dl, '3'
    je .mult
    
    cmp dl, '4'
    je .divi
    
    lea eax, str3
    call sprint
    jmp cal_loop
    
    
.addi:

    call get_nums
    
    lea eax, num1
    call atoi
    
    mov ebx, eax
    
    lea eax, num2
    call atoi
    add ebx, eax
    jmp .result123
    

.subt:
    call get_nums
    
    lea eax, num1
    call atoi
    mov ebx, eax
    
    lea eax, num2
    call atoi
    sub ebx, eax
    
    jmp .result123
    
.mult:

    call get_nums
    
    lea eax, num1
    call atoi
    mov ebx, eax
    
    lea eax, num2
    call atoi
    mul ebx
    
    mov ebx, eax
    
    jmp .result123

.divi:

    call get_nums
    
    lea eax, num1
    call atoi
    
    mov ebx, eax
    
    lea eax, num2
    call atoi
    
    mov ecx, eax
    mov eax, ebx
    mov ebx, ecx
    
    mov edx, 0
    
    div ebx
    
    mov ebx, eax

    jmp .result4
    
    
.result123:
    lea eax, str6
    call sprint
    
    mov eax, ebx
    call iprint
    
    jmp .continue
    
.result4:
    lea eax, str6
    call sprint
    
    mov eax, ebx
    call iprint
    
    lea eax, str7
    call sprint
    
    mov eax, edx
    call iprint
    
    jmp .continue

    
.continue:
    lea eax, str8
    call sprint

    lea eax, conti
    call get_char
    
    mov dh, [conti]
    
    cmp dh, 'y'
    je cal_loop
    
    cmp dh, 'Y'
    je cal_loop
    
    cmp dh, 'n'
    je finish
    
    cmp dh, 'N'
    je finish
    
    lea eax, str3
    call sprint
    jmp .continue
    
    
finish:
    lea eax, str9
    call sprint
    call quit


menu:
    push eax
    lea eax, str2
    call sprint
    pop eax
    ret

get_nums:
    push eax
    
    lea eax, str4
    call sprint
    
    lea eax, num1
    call get_until_linefeed
    
    lea eax, str5
    call sprint
    
    lea eax, num2
    call get_until_linefeed
    
    pop eax
    ret
    

;------------------------------------------
;eax: string num
;return:
;eax: num int
atoi:
    push    ebx
    push    ecx
    push    edx
    push    esi
    mov     esi, eax
    mov     eax, 0
    mov     ecx, 0
.multiplyLoop:
    xor     ebx, ebx
    mov     bl, [esi+ecx]
    cmp     bl, 48
    jl      .finished
    cmp     bl, 57
    jg      .finished

    sub     bl, 48
    add     eax, ebx
    mov     ebx, 10
    mul     ebx
    inc     ecx
    jmp     .multiplyLoop
.finished:
    cmp     ecx, 0
    je      .restore
    mov     ebx, 10
    div     ebx
.restore:
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    ret



;------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
;eax: num int
iprint:
    push eax
    push ecx
    push edx
    push esi
    mov ecx, 0
    
.divide_loop:
    inc ecx
    mov edx, 0
    mov esi, 10
    idiv esi
    add edx, 48
    push edx
    cmp eax, 0
    jne .divide_loop
    
.print_loop:
    dec ecx
    mov eax, esp
    call sprint
    pop eax
    cmp ecx, 0
    jne .print_loop
    
    pop esi
    pop edx
    pop ecx
    pop eax
    
    ret




;----------------
;eax: destination
;return:
;eax: destination
;ebx: len
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
   
   
   


;eax: destination
;return:
;eax: destination
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
   
    

;------------------------------------------
;eax: string
;return:
;eax: len string
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


;------------------------------------------
;eax: string
;return:
;eax: len string
sprint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    slen

    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret
    
    
quit:
    mov ebx, 0
    mov eax, 1
    int 80h

section .data
    str1 db "CALCULATOR: ", 0
    str2 db "1(+) | 2(-) | 3(*) | 4(:)", 10, "Your choice: ", 0
    str3 db "Invalid! ", 0
    str4 db "first  num: ", 0
    str5 db "second num: ", 0
    str6 db "Result: ", 0
    str7 db " remaind: ", 0
    str8 db "Continue[y/n]? ", 0
    str9 db "Bye ", 0

segment .bss

    cal resb 1
    conti resb 1
    num1 resb 11
    num2 resb 11


