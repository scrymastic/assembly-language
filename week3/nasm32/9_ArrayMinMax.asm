
section .text

global _start

_start:
    
.first_num:
    lea eax, num
    call get_until_not_num

    call atoi

    mov ecx, eax
    mov edx, eax
    
    cmp ebx, 0
    je .result
    jmp .compare_loop

.compare_loop:
    lea eax, num
    call get_until_not_num
    call atoi
    
    cmp eax, edx
    jg .new_max

    cmp eax, ecx
    jl .new_min

    cmp ebx, 0
    je .result
    jmp .compare_loop


.new_max:
    mov edx, eax
    cmp ebx, 0
    je .result
    jmp .compare_loop
    
.new_min:
    mov ecx, eax
    cmp ebx, 0
    je .result
    jmp .compare_loop


.result:
    lea eax, string1
    call sprint
    
    mov eax, ecx
    call iprint
    
    lea eax, linefeed
    call sprint
    
    lea eax, string2
    call sprint
    
    mov eax, edx
    call iprint
    
    call quit


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
.multiply_loop:
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
    jmp     .multiply_loop
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
    
    
;------------------------------------------
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
;eax: destination
;return:
;eax: destination
;ebx: no more 0, still more 1
get_until_not_num:
    push eax
    push ecx
   
    mov ebx, eax
.get_loop:
    call get_char
    mov cl, byte [eax]
    cmp cl, 10
    je .no_more
    cmp cl, '0'
    jl .still_more
    cmp cl, '9'
    jg .still_more
    inc eax
    jmp .get_loop
    
.no_more:
    mov ebx, 0
    jmp .finish
    
.still_more:
    mov ebx, 1
    jmp .finish

.finish:
    mov byte [eax], 0

    pop ecx
    pop eax
   
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



;------------------------------------------
quit:
    mov ebx, 0
    mov eax, 1
    int 80h

section .data
    string1 db 'min: ', 0
    string2 db 'max: ', 0
    linefeed db 10, 0

segment .bss

    num resb 11
