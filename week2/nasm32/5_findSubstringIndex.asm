section .text

global _start

_start:
    
    lea eax, out1
    call sprint

    lea eax, stringS
    call get_until_linefeed
    
    call slen
    
    mov [len], eax
    lea eax, out2
    call sprint
    
    lea eax, stringC

    call get_until_linefeed
    lea eax, stringS
    lea ebx, stringC
    
    mov edx, -1
    
.find_index:
    inc edx
    push eax
    add eax, edx
    call compare_at
    pop eax
    call matched
    
    cmp edx, [len]
    jl .find_index
    
    call quit
    
matched:

    cmp ecx, 1
    jne .finished
    push edx
    push eax
    mov eax, edx
    
    call iprint
    call print_sp
    
    pop eax
    pop edx

.finished:
    ret
    

;-------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push    eax             ; preserve eax on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     ecx, 0          ; counter of how many bytes we need to print in the end

.divideLoop:
    inc     ecx             ; count each byte to print - number of characters
    mov     edx, 0          ; empty edx
    mov     esi, 10         ; mov 10 into esi
    idiv    esi             ; divide eax by esi
    add     edx, 48         ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push    edx             ; push edx (string representation of an intger) onto the stack
    cmp     eax, 0          ; can the integer be divided anymore?
    jnz     .divideLoop     ; jump if not zero to the label divideLoop

.printLoop:
    dec     ecx             ; count down each byte that we put on the stack
    mov     eax, esp        ; mov the stack pointer into eax for printing
    call    sprint          ; call our string print function
    pop     eax             ; remove last character from the stack to move esp forward
    cmp     ecx, 0          ; have we printed all bytes we pushed onto the stack?
    jnz     .printLoop      ; jump is not zero to the label printLoop

    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     eax             ; restore eax from the value we pushed onto the stack at the start
    ret

    

;-------------------------------------------
; eax: destination
; return:
; eax: destination
; ebx: len
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


; eax: destination
; return:
; eax: destination
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
    
  
  
;-------------------------------------------
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


;-------------------------------------------
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

    
print_sp:
    push eax
    push ebx
    push ecx
    push edx
    
    mov eax, ' '
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
    
    
; eax: source
; ebx: substring
; return:
; eax: source
; ebx: substring
; ecx: 1 or 0
compare_at:
    push eax
    push ebx
    push esi
    push edi
    
    mov esi, eax
    mov edi, ebx

    mov ecx, -1
.compare_loop:
    inc ecx
    mov bl, byte [edi+ecx]
    cmp bl, 0
    je .true
    
    cmp bl, byte [esi+ecx]
    je .compare_loop
    jmp .false
.true:
    mov ecx, 1
    jmp .finish
.false:
    mov ecx, 0
    jmp .finish
.finish:
    pop edi
    pop esi
    pop ebx
    pop eax
    
    ret
    

    
quit:
    mov ebx, 0
    mov eax, 1
    int 80h

    

section .data
    out1 db 'S=', 0
    out2 db 'C='


segment .bss

    stringS resb 257
    
    stringC resb 257
    
    len resd 1
    
