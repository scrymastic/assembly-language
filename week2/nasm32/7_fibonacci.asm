section .text

global _start

_start:
    lea eax, N_str
    call get_until_linefeed
    mov eax, N_str

    call atoi

    mov [N_int], eax
    
    mov byte [num1], '0'
    mov byte [num1+1], 0
    mov byte [num2], '1'
    mov byte [num2+1], 0
    
.N0:
    mov edx, eax
    cmp edx, 0
    je done
    
.N1:
    lea eax, num1
    call sprint

    cmp edx, 1
    je done

.N2:
    call print_lf
    lea eax, num2
    call sprint
    cmp edx, 2
    je done
    
    mov edx, 2
.fibo_loop:

    call print_lf

    lea eax, num1
    lea ebx, num2
    lea ecx, num3
    call add_nums
    
    lea eax, num3
    call sprint

    
    lea eax, num1
    lea ebx, num2
    call copy
    
    lea eax, num2
    lea ebx, num3
    call copy
    
    inc edx
    cmp edx, [N_int]

    je done
    
    jmp .fibo_loop
    
    
    
done:
    call quit

;eax: num1
;ebx: num2
;ecx: num3 = num2 + num1
;return:
;no changes
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
    


;eax: string
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
    

;eax: des
;ebx: source
;return:
;eax: end of string
copy:
    push eax
    push ebx
    push ecx
    push edx
    
    xor edx, edx
    
.copy_loop:
    
    mov cl, byte [ebx+edx]
    mov byte [eax+edx], cl
    
    cmp cl, 0
    je .finish
    inc edx
    jmp .copy_loop
    
.finish:
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    ret


   
print_lf:
    push eax
    push ebx
    push ecx
    push edx
   
    mov eax, 10
    push eax
   
    mov edx, 1
    mov ecx, esp
    mov ebx, 1
    mov eax, 4
    int 80h
   
    pop eax
    pop edx
    pop ecx
    pop ebx
    pop eax
   
    ret

;------------------------------------------
; int slen(String message)
; String length calculation function
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
; void sprint(String message)
; String printing function
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
; int atoi(Integer number)
; Ascii to integer function (atoi)
atoi:
    push    ebx             ; preserve ebx on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     esi, eax        ; move pointer in eax into esi (our number to convert)
    mov     eax, 0          ; initialise eax with decimal value 0
    mov     ecx, 0          ; initialise ecx with decimal value 0
 
.multiplyLoop:
    xor     ebx, ebx        ; resets both lower and uppper bytes of ebx to be 0
    mov     bl, [esi+ecx]   ; move a single byte into ebx register's lower half
    cmp     bl, 48          ; compare ebx register's lower half value against ascii value 48 (char value 0)
    jl      .finished       ; jump if less than to label finished
    cmp     bl, 57          ; compare ebx register's lower half value against ascii value 57 (char value 9)
    jg      .finished       ; jump if greater than to label finished
 
    sub     bl, 48          ; convert ebx register's lower half to decimal representation of ascii value
    add     eax, ebx        ; add ebx to our interger value in eax
    mov     ebx, 10         ; move decimal value 10 into ebx
    mul     ebx             ; multiply eax by ebx to get place value
    inc     ecx             ; increment ecx (our counter register)
    jmp     .multiplyLoop   ; continue multiply loop
 
.finished:
    cmp     ecx, 0          ; compare ecx register's value against decimal 0 (our counter register)
    je      .restore        ; jump if equal to 0 (no integer arguments were passed to atoi)
    mov     ebx, 10         ; move decimal value 10 into ebx
    div     ebx             ; divide eax by value in ebx (in this case 10)
 
.restore:
    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     ebx             ; restore ebx from the value we pushed onto the stack at the start
    
    ret

   
   
quit:
    mov ebx, 0
    mov eax, 1
    int 80h


section .data
    ; num1 db '1987', 0
    ; num2 db '8', 0

segment .bss
    N_str resb 3
    N_int resd 1
    num1 resb 22
    num2 resb 22
    num3 resb 22
