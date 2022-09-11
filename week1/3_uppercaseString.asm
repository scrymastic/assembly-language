

    

.model small
.stack 100

.data
    str db 36 dup ('$')
    flcr db 10, 13, '$'
    
.code
    main proc
        lea ax, data
        mov ds, ax
        
        lea dx, str
        mov ah, 10
        int 21h
        
        
        lea dx, flcr
        mov ah, 9
        int 21h
        
        call printUpper
        
        
        mov ah, 4ch
        int 21h
        
    main endp 
    
    
    printUpper proc
        lea si, str+2
        
        loop_:
            mov dl, [si]
            cmp dl, 'a'
            jl print
            cmp dl, 'z'
            jg print
            sub dl, 32
            
        print:
            mov ah, 2
            int 21h
            inc si
            cmp [si], '$'
            jne loop_
            
        ret
        
    printUpper endp
    
end
