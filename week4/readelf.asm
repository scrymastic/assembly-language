; Read
; Compile with: nasm -f elf read.asm
; Link with (64 bit systems require elf_i386 option): ld -m elf_i386 read.o -o read
; Run with: ./read filename


SECTION .data

	elfhe db "ELF Header:", 0
	magic db "  Magic:   ", 0
	class db "  Class:                             ", 0
	    elf32 db "ELF32", 10, 0
	    elf64 db "ELF64", 10, 0
	data  db "  Data:                              ", 0
	    litendian db "2's complement, little endian", 10, 0
	    bigendian db "2's complement, big endian", 10, 0
	daver db "  Version:                           ", 0
	    currvs db "1 (current)", 10, 0
	opabi db "  OS/ABI:                            ", 0
	    sysv db "UNIX - System V", 10, 0
	    hpux db "UNIX - HP-UX", 10, 0
	    nbsd db "UNIX - NetBSD", 10, 0
	    linux db "Linux", 10, 0
	    gnuh db "GNU Hard", 10, 0
	    sola db "UNIX - Solaris", 10, 0
	    aix  db "UNIX - AIX", 10, 0
	    irix db "UNIX - IRIX", 10, 0
	    fbsd db "UNIX - Free BSD", 10, 0
	    tru64 db "UNIX - TRU64", 10, 0
	    nove db "Novell - Modesto", 10, 0
	    obsd db "UNIX - Open BSD", 10, 0
	    ovms db "VMS - Open VMS", 10, 0
	    nstop db "HP - Non-Stop Kenel", 10, 0
	    aros db "AROS", 10, 0
	    feos db "FenixOs", 10, 0
	    nuxi db "Nuxi CloudABI", 10, 0
	    stra db "Stratus Technologies OpenVOS", 10, 0
	abive db "  ABI Version:                       ", 0
	type  db "  Type:                              ", 0
	    none db "NONE (None)", 10, 0
	    relo db "REL (Relocatable file)", 10, 0
	    exec db "EXEC (Executable file)", 10, 0
	    shar db "DYN (Shared object file)", 10, 0
	    core db "CORE (Core file)", 10, 0
	    loos db "LOOS (Os specific)", 10, 0
	    hios db "HIOS (Os pecific)", 10, 0
	    lopr db "LOPROC (Processor specific)", 10, 0
	    hipr db "HIPROC (Processor specific)", 10, 0
	machi db "  Machine:                           ", 0
	    nosp db "None", 10, 0
	    atat db "AT&T WE 32100", 10, 0
	    spar db "SPARC", 10, 0
	    bi86 db "x86", 10, 0
	    mot6 db "Motorola 68000 (M68k)", 10, 0
	    mot8 db "Motorola 88000 (M88k)", 10, 0
	    inmc db "Intel MCU", 10, 0
	    in86 db "Intel 80860", 10, 0
	    mips db "MIPS", 10, 0
	    ibms db "IBM System/370", 10, 0
	    mipr db "MIPS RS3000 Little-endian", 10, 0
	    hewl db "Hewllet-Packard PA-RISC", 10, 0
	    in96 db "Intel 80960", 10, 0
	    popc db "PowerPC", 10, 0
	    po64 db "PowerPC64", 10, 0
	    s390 db "IBM S/390", 10, 0
	    spus db "IBM SPU/SPC", 10, 0
	    necv db "NEC V800", 10, 0
	    fuji db "Fujitsu FR20", 10, 0
	    trwr db "TRWR RH-32", 10, 0
	    motr db "Motorola RCE", 10, 0
	    arm  db "ARM", 10, 0
	    digi db "Digital Alpha", 10, 0
	    supe db "SuperH", 10, 0
	    par9 db "PARC v9", 10, 0
	    siem db "Siemens Tricore", 10, 0
	    argo db "Argonaut RISC Core", 10, 0
	    rene db "Renesas H8/300", 10, 0
	    re3h db "Renesas H8/300H", 10, 0
	    rens db "Renesas H8S", 10, 0
	    ren5 db "Renesas H8/500", 10, 0
	    ia64 db "IA-64", 10, 0
	    stan db "Stanford MIPS-X", 10, 0
	    motc db "Motorola ColdFire", 10, 0
	    motm db "Motorola M68HC12", 10, 0
	    fujm db "Fujitsu MMA Multimedia Accelerator", 10, 0
	    siep db "Siemens PCP", 10, 0
	    sony db "Sony nCPU embedded RISC processor", 10, 0
	    dens db "Denso NDR1 microprocessor", 10, 0
	    mots db "Motorola Star*Core processor", 10, 0
	    toyo db "Toyota ME16 processor", 10, 0
	    stm1 db "STMicroelectronics ST100 processor", 10, 0
	    adva db "Advanced Logic Corp. TinyJ embedded processor family", 10, 0
	    amdx db "AMD x86-64", 10, 0
	    sond db "Sony DSP Processor", 10, 0
	    die0 db "Digital Equipment Corp. PDP-10", 10, 0
	    die1 db "Digital Equipment Corp. PDP-11", 10, 0
	    sief db "Siemens FX66 microcontroller", 10, 0
	    stm9 db "STMicroelectronics ST9+ 8/16 bit microcontroller", 10, 0
	    stm7 db "STMicroelectronics ST7 8-bit microcontroller", 10, 0
	    mo16 db "Motorola MC68HC16 Microcontroller", 10, 0
	    mo11 db "Motorola MC68HC11 Microcontroller", 10, 0
	    mo08 db "Motorola MC68HC08 Microcontroller", 10, 0
	    mo05 db "Motorola MC68HC05 Microcontroller", 10, 0
	    sili db "Silicon Graphics SVx", 10, 0
	    st19 db "STMicroelectronics ST19 8-bit microcontroller", 10, 0
	    digv db "Digital VAX", 10, 0
	    axis db "Axis Communications 32-bit embedded processor", 10, 0
	    infi db "Infineon Technologies 32-bit embedded processor", 10, 0
	    elem db "Element 14 64-bit DSP Processor", 10, 0
	    lsil db "LSI Logic 16-bit DSP Processor", 10, 0
	    tms3 db "TMS320C6000 Family", 10, 0
	    mcst db "MCST Elbrus e2k", 10, 0
	    arm6 db "Arm 64-bits (Armv8/Aarch64)", 10, 0
	    zilo db "Zilog Z80", 10, 0
	    risc db "RISC-V", 10, 0
	    berk db "Berkeley Packet Filter", 10, 0
	    wdc6 db "WDC 65C816", 10, 0
	maver db "  Version:                           ", 0
	entry db "  Entry point address:               ", 0
	stoph db "  Start of program headers:          ", 0
	stosh db "  Start of section headers:          ", 0
	flags db "  Flags:                             ", 0
	sioth db "  Size of this header:               ", 0
	sioph db "  Size of program headers:           ", 0
	nuoph db "  Number of program headers:         ", 0
	siosh db "  Size of section headers:           ", 0
	nuosh db "  Number of section headers:         ", 0
	shsti db "  Section header string table index: ", 0
	
	unknown db "<unknown>", 10, 0
    
    nonelf db "Error: Not an ELF file - it has the wrong magic bytes at the start", 10, 0
    
    hexpre db "0x", 0
    
    bytofl db " (bytes into file)", 10, 0
    strbys db " (bytes)", 10, 0

    uninit db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    

SECTION .bss
filename resb 255
byteContents resb 10
fildes resd 1
litbig resb 1
numbit resb 1
temp resw 1


SECTION .text

;-------------------------------------------
; eax: number of bytes to read
get_next_byte:
    
    mov     edx, eax 
    mov     ecx, byteContents
    mov     ebx, dword [fildes]
    mov     eax, 3
    int     0x80
    ret
    
;-------------------------------------------
; eax: string
; ebx: len
reverse_len:
    push edx
    push ecx
    push ebx
    push eax

    add ebx, eax
    sub ebx, 1
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

;-------------------------------------------
; eax: des
; ebx: source
; return:
; eax: end of string
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

;-------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push    eax
    push    ecx
    push    edx
    push    esi
    mov     ecx, 0

.divideLoop:
    inc     ecx
    mov     edx, 0
    mov     esi, 10
    idiv    esi
    add     edx, 48
    push    edx
    cmp     eax, 0
    jnz     .divideLoop

.printLoop:
    dec     ecx
    mov     eax, esp
    call    sprint
    pop     eax
    cmp     ecx, 0
    jnz     .printLoop

    pop     esi
    pop     edx
    pop     ecx
    pop     eax
    ret



;-------------------------------------------
; eax: number to be printed
; integer (hex) printing function (itoa)
iprintH:
    push    eax
    push    ecx
    push    edx
    push    esi
    mov     ecx, 0
.divideLoop:
    inc     ecx
    mov     edx, 0
    mov     esi, 16
    idiv    esi
    add     edx, 48
    cmp     edx, 57
    jg      .hex_digit
    jmp     .push_digit
.hex_digit:
    add     edx, 39
.push_digit:
    push    edx
    cmp     eax, 0
    jnz     .divideLoop

.printLoop:
    dec     ecx
    mov     eax, esp
    call    sprint
    pop     eax
    cmp     ecx, 0
    jnz     .printLoop

    pop     esi
    pop     edx
    pop     ecx
    pop     eax
    ret




;-------------------------------------------
; eax: byte to be printed
; 0 <= eax <= 255
; 0 => 00
; 10 => 0A
iprint_byteH:
	cmp eax, 15
	jg .print

    push    eax
    mov     eax, 48	
    push    eax 
    mov     eax, esp 
	call    sprint 
    pop     eax 
    pop     eax
    
.print:
	call iprintH
	ret
	

;-------------------------------------------
; print linefeed
print_lf:
    push    eax
    mov     eax, 10
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
    ret


;-------------------------------------------
; print space
print_sp:
    push    eax
    mov     eax, 32
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax
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
    int     0x80

    pop     ebx
    pop     ecx
    pop     edx
    ret

    
;-------------------------------------------
; print a string in hex, each byte is separated by a space
; eax: source
; ebx: len
sprintH_sp:
    push    edx
    push    ecx
    push    ebx
    push    eax
    
	mov esi, eax
	add esi, ebx
	mov ecx, eax

.printLoop:
	cmp ecx, esi
	je .finish

	movzx eax, byte [ecx]
	call iprint_byteH
	call print_sp
	
	inc ecx
	jmp .printLoop
	

.finish:
	pop 	eax
    pop     ebx
    pop     ecx
    pop     edx
    ret


;-------------------------------------------
; print a string in hex
; eax: source
; ebx: len
sprintH:
    push    edx
    push    ecx
    push    ebx
    push    eax
    
	mov esi, eax
	add esi, ebx
	mov ecx, eax
	mov dl, 0
	
.start_print:
    cmp ecx, esi
    je .print0
    
    cmp byte [ecx], 0
    jne .first_digit
    inc ecx
    jmp .start_print
    
.first_digit:
    movzx eax, byte [ecx]
    call iprintH
    inc ecx
.printLoop:
	cmp ecx, esi
	je .finish

	movzx eax, byte [ecx]
	call iprint_byteH
	
	inc ecx
	jmp .printLoop

.print0:
    mov eax, 0
    call iprint

.finish:
	pop 	eax
    pop     ebx
    pop     ecx
    pop     edx
    ret
    


;-------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     ebx, 0
    mov     eax, 1
    int     0x80
    ret



global _start

_start:

	pop eax
	pop eax

	pop eax
	mov ebx, eax
	
	mov eax, filename
	call copy
	


    mov     ecx, 0                      ; Open file from lesson 24
    mov     ebx, filename
    mov     eax, 5
    int     0x80
    
    mov dword [fildes], eax


;-------------------------------------------
; magic:

    mov eax, 4
    call get_next_byte
    
    mov bl, byte [byteContents]
    cmp bl, 0x7F
    jne .nonelf
    
    mov bl, byte [byteContents+1]
    cmp bl, 0x45
    jne .nonelf
    
    mov bl, byte [byteContents+2]
    cmp bl, 0x4C
    jne .nonelf
    
    mov bl, byte [byteContents+3]
    cmp bl, 0x46
    jne .nonelf
    
    mov eax, elfhe
	call sprint
	call print_lf
	
	mov eax, magic
	call sprint
    
    mov eax, byteContents
    mov ebx, 4
    call sprintH_sp

	call print_lf
    
    
;-------------------------------------------
; class:
    mov eax, class
    call sprint

    mov eax, 1
    call get_next_byte
    mov bl, byte [byteContents]
    mov byte [numbit], bl
    cmp bl, 1
    je .printelf32
    
    mov eax, elf64
    call sprint
    
    jmp .finish_class
    
.printelf32:
    mov eax, elf32
    call sprint
    
.finish_class:
    
;-------------------------------------------
; data:
    mov eax, data
    call sprint
    
    mov eax, 1
    call get_next_byte
    mov bl, byte [byteContents]
    cmp bl, 1
    mov byte [litbig], bl
    je .litendian
    
    mov eax, bigendian
    call sprint
    
    jmp .finish_data
    
.litendian:
    mov eax, litendian
    call sprint
    
.finish_data:

;-------------------------------------------
; data version:
	mov eax, maver
	call sprint
	
    mov eax, 1
    call get_next_byte
    mov bl, byte [byteContents]
    cmp bl, 1
    je .currversion
    
    mov eax, unknown
    call sprint
    
    jmp .finish_daver
    
.currversion:
    mov eax, currvs
    call sprint
    
.finish_daver:

;-------------------------------------------
; OS/ABI:
	mov eax, opabi
	call sprint

    mov eax, 1
    call get_next_byte
    
    mov bl, byte [byteContents]
    cmp bl, 0
    je .sysv
    
    cmp bl, 1
    je .hpux
    
    cmp bl, 2
    je .nbsd
    
    cmp bl, 3
    je .linux
    
    cmp bl, 4
    je .gnuh
    
    cmp bl, 6
    je .sola
    
    cmp bl, 7
    je .aix
    
    cmp bl, 8
    je .irix
    
    cmp bl, 9
    je .fbsd
    
    cmp bl, 10
    je .tru64
    
    cmp bl, 11
    je .nove
    
    cmp bl, 12
    je .obsd
    
    cmp bl, 13
    je .ovms
    
    cmp bl, 14
    je .nstop
    
    cmp bl, 15
    je .aros
    
    cmp bl, 16
    je .feos
    
    cmp bl, 17
    je .nuxi
    
    cmp bl, 18
    je .stra
    
    mov eax, unknown
    call sprint
    
    jmp .finish_opabi
    
.sysv:
    mov eax, sysv
    call sprint
    jmp .finish_opabi
    
.hpux:
    mov eax, hpux
    call sprint
    jmp .finish_opabi
    
.nbsd:
    mov eax, nbsd
    call sprint
    jmp .finish_opabi
    
.linux:
    mov eax, linux
    call sprint
    jmp .finish_opabi
    
    
.gnuh:
    mov eax, gnuh
    call sprint
    jmp .finish_opabi
    
.sola:
    mov eax, sola
    call sprint
    jmp .finish_opabi
    
.aix:
    mov eax, sola
    call sprint
    jmp .finish_opabi
    
.irix:
    mov eax, irix
    call sprint
    jmp .finish_opabi
    
.fbsd:
    mov eax, fbsd
    call sprint
    jmp .finish_opabi
    
.tru64:
    mov eax, tru64
    call sprint
    jmp .finish_opabi
    
.nove:
    mov eax, nove
    call sprint
    jmp .finish_opabi
    
.obsd:
    mov eax, obsd
    call sprint
    jmp .finish_opabi
    
.ovms:
    mov eax, ovms
    call sprint
    jmp .finish_opabi
    
.nstop:
    mov eax, nstop
    call sprint
    jmp .finish_opabi
    
.aros:
    mov eax, aros
    call sprint
    jmp .finish_opabi
    
.feos:
    mov eax, feos
    call sprint
    jmp .finish_opabi
    
.nuxi:
    mov eax, nuxi
    call sprint
    jmp .finish_opabi
    
.stra:
    mov eax, stra
    call sprint
    jmp .finish_opabi
    
.finish_opabi:

;-------------------------------------------
; ABI version:
    mov eax, abive
    call sprint
    
    mov eax, 1
    call get_next_byte
    mov bl, byte [byteContents]
    
    movzx eax, bl
    call iprint
    call print_lf
    
    
;-------------------------------------------
; reverved padding bytes:
    mov eax, 7
    call get_next_byte
    
;-------------------------------------------
; type:
	mov eax, type
	call sprint

    mov eax, 2
    call get_next_byte
    
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_type
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .compare_type
.little_type:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]
    
.compare_type:
    cmp cx, 0
    je .none
    
    cmp cx, 1
    je .relo
    
    cmp cx, 2
    je .exec
    
    cmp cx, 3
    je .shar
    
    cmp cx, 4
    je .core
    
    cmp cx, 0xfe00
    je .loos
    
    cmp cx, 0xfeff
    je .hios
    
    cmp cx, 0xff00
    je .lopr
    
    cmp cx, 0xffff
    je .hipr
    
    mov eax, unknown
    call sprint
	jmp .finish_type
    
.none:
    mov eax, none
    call sprint
	jmp .finish_type

.relo:
    mov eax, relo
    call sprint
	jmp .finish_type
    
.exec:
    mov eax, exec
    call sprint
	jmp .finish_type
    
.shar:
    mov eax, shar
    call sprint
	jmp .finish_type
    
.core:
    mov eax, core
    call sprint
	jmp .finish_type
    
.loos:
    mov eax, loos
    call sprint
	jmp .finish_type
    
.hios:
    mov eax, hios
    call sprint
	jmp .finish_type
    
.lopr:
    mov eax, lopr
    call sprint
	jmp .finish_type
    
.hipr:
    mov eax, hipr
    call sprint
	jmp .finish_type



.finish_type:

;-------------------------------------------
; machine:
	mov eax, machi
	call sprint

    mov eax, 2
    call get_next_byte
    
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_machi
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .compare_machi
.little_machi:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]
    
.compare_machi:
    cmp cx, 0
    je .nosp
    
    cmp cx, 1
    je .atat
    
    cmp cx, 2
    je .spar
    
    cmp cx, 3
    je .bi86
    
    cmp cx, 4
    je .mot6
    
    cmp cx, 5
    je .mot8
    
    cmp cx, 6
    je .inmc
    
    cmp cx, 7
    je .in86
    
    cmp cx, 8
    je .mips
    
    cmp cx, 9
    je .ibms
    
    cmp cx, 0xA
    je .mipr
    
    cmp cx, 0xE
    je .hewl
    
    cmp cx, 0x13
    je .in96
    
    cmp cx, 0x14
    je .popc
    
    cmp cx, 0x15
    je .po64
    
    cmp cx, 0x16
    je .s390
    
    cmp cx, 0x17
    je .spus
    
    cmp cx, 0x24
    je .necv
    
    cmp cx, 0x25
    je .fuji
    
    cmp cx, 0x26
    je .trwr
    
    cmp cx, 0x27
    je .motr
    
    cmp cx, 0x28
    je .arm
    
    cmp cx, 0x29
    je .digi
    
    cmp cx, 0x2A
    je .supe
    
    cmp cx, 0x2B
    je .par9
    
    cmp cx, 0x2C
    je .siem
    
    cmp cx, 0x2D
    je .argo
    
    cmp cx, 0x2E
    je .rene
    
    cmp cx, 0x2F
    je .re3h
    
    cmp cx, 0x30
    je .rens
    
    cmp cx, 0x31
    je .ren5
    
    cmp cx, 0x32
    je .ia64
    
    cmp cx, 0x33
    je .stan
    
    cmp cx, 0x34
    je .motc
    
    cmp cx, 0x35
    je .motm
    
    cmp cx, 0x36
    je .fujm
    
    cmp cx, 0x37
    je .siep
    
    cmp cx, 0x38
    je .sony
    
    cmp cx, 0x39
    je .dens
    
    cmp cx, 0x3A
    je .mots
    
    cmp cx, 0x3B
    je .toyo
    
    cmp cx, 0x3C
    je .stm1
    
    cmp cx, 0x3D
    je .adva
    
    cmp cx, 0x3E
    je .amdx
    
    cmp cx, 0x3F
    je .sond
    
    cmp cx, 0x40
    je .die0
    
    cmp cx, 0x41
    je .die1
    
    cmp cx, 0x42
    je .sief
    
    cmp cx, 0x43
    je .stm9
    
    cmp cx, 0x44
    je .stm7
    
    cmp cx, 0x45
    je .mo16
    
    cmp cx, 0x46
    je .mo11
    
    cmp cx, 0x47
    je .mo08
    
    cmp cx, 0x48
    je .mo05
    
    cmp cx, 0x49
    je .sili
    
    cmp cx, 0x4A
    je .st19
    
    cmp cx, 0x4B
    je .digv
    
    cmp cx, 0x4C
    je .axis
    
    cmp cx, 0x4D
    je .infi
    
    cmp cx, 0x4E
    je .elem
    
    cmp cx, 0x4F
    je .lsil
    
    cmp cx, 0x8c
    je .tms3
    
    cmp cx, 0xAF
    je .mcst
    
    cmp cx, 0xB7
    je .arm6
    
    cmp cx, 0xDC
    je .zilo
    
    cmp cx, 0xF3
    je .risc
    
    cmp cx, 0xF7
    je .berk
    
    cmp cx, 0x101
    je .wdc6
    
    mov eax, unknown
    call sprint
    
    jmp .finish_machi
    

.nosp:
    mov eax, nosp
    call sprint
    jmp .finish_machi
.atat:
    mov eax, atat
    call sprint
    jmp .finish_machi
.spar:
    mov eax, spar
    call sprint
    jmp .finish_machi
.bi86:
    mov eax, bi86
    call sprint
    jmp .finish_machi
.mot6:
    mov eax, mot6
    call sprint
    jmp .finish_machi
.mot8:
    mov eax, mot8
    call sprint
    jmp .finish_machi
.inmc:
    mov eax, inmc
    call sprint
    jmp .finish_machi
.in86:
    mov eax, in86
    call sprint
    jmp .finish_machi
.mips:
    mov eax, mips
    call sprint
    jmp .finish_machi
.ibms:
    mov eax, ibms
    call sprint
    jmp .finish_machi
.mipr:
    mov eax, mipr
    call sprint
    jmp .finish_machi
.hewl:
    mov eax, hewl
    call sprint
    jmp .finish_machi
.in96:
    mov eax, in96
    call sprint
    jmp .finish_machi
.popc:
    mov eax, popc
    call sprint
    jmp .finish_machi
.po64:
    mov eax, po64
    call sprint
    jmp .finish_machi
.s390:
    mov eax, s390
    call sprint
    jmp .finish_machi
.spus:
    mov eax, spus
    call sprint
    jmp .finish_machi
.necv:
    mov eax, necv
    call sprint
    jmp .finish_machi
.fuji:
    mov eax, fuji
    call sprint
    jmp .finish_machi
.trwr:
    mov eax, trwr
    call sprint
    jmp .finish_machi
.motr:
    mov eax, motr
    call sprint
    jmp .finish_machi
.arm:
    mov eax, arm
    call sprint
    jmp .finish_machi
.digi:
    mov eax, digi
    call sprint
    jmp .finish_machi
.supe:
    mov eax, supe
    call sprint
    jmp .finish_machi
.par9:
    mov eax, par9
    call sprint
    jmp .finish_machi
.siem:
    mov eax, siem
    call sprint
    jmp .finish_machi
.argo:
    mov eax, argo
    call sprint
    jmp .finish_machi
.rene:
    mov eax, rene
    call sprint
    jmp .finish_machi
.re3h:
    mov eax, re3h
    call sprint
    jmp .finish_machi
.rens:
    mov eax, rens
    call sprint
    jmp .finish_machi
.ren5:
    mov eax, ren5
    call sprint
    jmp .finish_machi
.ia64:
    mov eax, ia64
    call sprint
    jmp .finish_machi
.stan:
    mov eax, stan
    call sprint
    jmp .finish_machi
.motc:
    mov eax, motc
    call sprint
    jmp .finish_machi
.motm:
    mov eax, motm
    call sprint
    jmp .finish_machi
.fujm:
    mov eax, fujm
    call sprint
    jmp .finish_machi
.siep:
    mov eax, siep
    call sprint
    jmp .finish_machi
.sony:
    movzx eax, cx
    call iprintH
    mov eax, sony
    call sprint
    jmp .finish_machi
.dens:
    mov eax, dens
    call sprint
    jmp .finish_machi
.mots:
    mov eax, mots
    call sprint
    jmp .finish_machi
.toyo:
    mov eax, toyo
    call sprint
    jmp .finish_machi
.stm1:
    mov eax, stm1
    call sprint
    jmp .finish_machi
.adva:
    mov eax, adva
    call sprint
    jmp .finish_machi
.amdx:
    mov eax, amdx
    call sprint
    jmp .finish_machi
.sond:
    mov eax, sond
    call sprint
    jmp .finish_machi
.die0:
    mov eax, die0
    call sprint
    jmp .finish_machi
.die1:
    mov eax, die1
    call sprint
    jmp .finish_machi
.sief:
    mov eax, sief
    call sprint
    jmp .finish_machi
.stm9:
    mov eax, stm9
    call sprint
    jmp .finish_machi
.stm7:
    mov eax, stm7
    call sprint
    jmp .finish_machi
.mo16:
    mov eax, mo16
    call sprint
    jmp .finish_machi
.mo11:
    mov eax, mo11
    call sprint
    jmp .finish_machi
.mo08:
    mov eax, mo08
    call sprint
    jmp .finish_machi
.mo05:
    mov eax, mo05
    call sprint
    jmp .finish_machi
.sili:
    mov eax, sili
    call sprint
    jmp .finish_machi
.st19:
    mov eax, st19
    call sprint
    jmp .finish_machi
.digv:
    mov eax, digv
    call sprint
    jmp .finish_machi
.axis:
    mov eax, axis
    call sprint
    jmp .finish_machi
.infi:
    mov eax, infi
    call sprint
    jmp .finish_machi
.elem:
    mov eax, elem
    call sprint
    jmp .finish_machi
.lsil:
    mov eax, lsil
    call sprint
    jmp .finish_machi
.tms3:
    mov eax, tms3
    call sprint
    jmp .finish_machi
.mcst:
    mov eax, mcst
    call sprint
    jmp .finish_machi
.arm6:
    mov eax, arm6
    call sprint
    jmp .finish_machi
.zilo:
    mov eax, zilo
    call sprint
    jmp .finish_machi
.risc:
    mov eax, risc
    call sprint
    jmp .finish_machi
.berk:
    mov eax, berk
    call sprint
    jmp .finish_machi
.wdc6:
    mov eax, wdc6
    call sprint
    jmp .finish_machi
    
    
.finish_machi:

;-------------------------------------------
; machine version:
    mov eax, maver
    call sprint
    
    mov eax, 4
    call get_next_byte
    
    mov eax, hexpre
    call sprint
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_maver
    
    mov eax, byteContents
    mov ebx, 4
    call sprintH
    call print_lf
    
    jmp .finish_maver

.little_maver:
    mov eax, byteContents
    mov ebx, 4
    call reverse_len
    
    call sprintH
    call print_lf
    
.finish_maver:

;-------------------------------------------
; entry:
    mov eax, entry
    call sprint
    
    mov eax, hexpre
    call sprint
    
    mov bl, 1
    cmp byte [numbit], 1
    je .x86_entry
    
    mov eax, 8
    call get_next_byte
    
    mov bl, 1
    cmp byte [litbig], bl
    je .x64little_entry
    
    jmp .x64print_entry
    
.x64little_entry:
    mov eax, byteContents
    mov ebx, 8
    call reverse_len
    
.x64print_entry:
    mov eax, byteContents
    mov ebx, 8
    call sprintH
    jmp .finish_entry
    
.x86_entry:
    mov eax, 4
    call get_next_byte
    
    mov bl, 1
    cmp byte [litbig], bl
    je .x86little_entry
    jmp .x86print_entry
    
.x86little_entry:
    mov eax, byteContents
    mov ebx, 4
    call reverse_len
    
.x86print_entry:
    mov eax, byteContents
    mov ebx, 4
    call sprintH
    
.finish_entry:
    call print_lf
    
;-------------------------------------------
; start of program header:
    mov eax, stoph
    call sprint
    
    mov bl, 1
    cmp byte [numbit], 1
    je .x86_stoph
    
    mov eax, 8
    call get_next_byte
    
    mov bl, 1
    cmp byte [litbig], bl
    je .x64little_stoph
    
    jmp .x64print_stoph
    
.x64little_stoph:
    mov eax, byteContents
    mov ebx, 8
    call reverse_len
    
    mov eax, byteContents+4
    mov ebx, 4
    call reverse_len
    
.x64print_stoph:
    cmp byte [byteContents], 0
    jne .overflow_stoph
    cmp byte [byteContents+1], 0
    jne .overflow_stoph
    cmp byte [byteContents+2], 0
    jne .overflow_stoph
    cmp byte [byteContents+3], 0
    jne .overflow_stoph
    
    mov eax, dword [byteContents+4]
    call iprint
    jmp .finish_stoph
    
.overflow_stoph:
    mov eax, hexpre
    call sprint
    
    mov eax, byteContents
    mov ebx, 8
    call sprintH
    jmp .finish_stoph
    
.x86_stoph:
    mov eax, 4
    call get_next_byte
    
    mov bl, 1
    cmp byte [litbig], bl
    je .x86little_stoph
    jmp .x86print_stoph
    
.x86little_stoph:

    
.x86print_stoph:
    mov eax, dword[byteContents]
    call iprint
    
.finish_stoph:
    mov eax, bytofl
    call sprint


;-------------------------------------------
; start of section header:
    mov eax, stosh
    call sprint
    
    mov bl, 1
    cmp byte [numbit], 1
    je .x86_stosh
    
    mov eax, 8
    call get_next_byte
    
    mov bl, 1
    cmp byte [litbig], bl
    je .x64little_stosh
    
    jmp .x64print_stosh
    
.x64little_stosh:
    mov eax, byteContents
    mov ebx, 8
    call reverse_len
    
    mov eax, byteContents+4
    mov ebx, 4
    call reverse_len
    
.x64print_stosh:
    cmp byte [byteContents], 0
    jne .overflow_stosh
    cmp byte [byteContents+1], 0
    jne .overflow_stosh
    cmp byte [byteContents+2], 0
    jne .overflow_stosh
    cmp byte [byteContents+3], 0
    jne .overflow_stosh
    
    mov eax, dword [byteContents+4]
    call iprint
    jmp .finish_stosh
    
.overflow_stosh:
    mov eax, hexpre
    call sprint
    
    mov eax, byteContents
    mov ebx, 8
    call sprintH
    jmp .finish_stosh
    
.x86_stosh:
    mov eax, 4
    call get_next_byte
    
    mov bl, 1
    cmp byte [litbig], bl
    je .x86little_stosh
    jmp .x86print_stosh
    
.x86little_stosh:

    
.x86print_stosh:
    mov eax, dword[byteContents]
    call iprint
    
.finish_stosh:
    mov eax, bytofl
    call sprint



;-------------------------------------------
; flags:
    mov eax, flags
    call sprint
    
    mov eax, 4
    call get_next_byte
    
    mov eax, hexpre
    call sprint
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_flags
    
    mov eax, byteContents
    mov ebx, 4
    call sprintH
    call print_lf
    
    jmp .finish_flags

.little_flags:
    mov eax, byteContents
    mov ebx, 4
    call reverse_len
    
    call sprintH
    call print_lf
    
.finish_flags:

;-------------------------------------------
; size of this header:
    mov eax, sioth
    call sprint
    
    mov eax, 2
    call get_next_byte
    
        
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_sioth
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .print_sioth
.little_sioth:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]

.print_sioth:
    movzx eax, cx
    call iprint
    
    mov eax, strbys
    call sprint
    
.finish_sioth:

;-------------------------------------------
; size of program header:
    mov eax, sioph
    call sprint
    
    mov eax, 2
    call get_next_byte
    
        
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_sioph
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .print_sioph
.little_sioph:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]

.print_sioph:
    movzx eax, cx
    call iprint
    
    mov eax, strbys
    call sprint
    
.finish_sioph:
    
;-------------------------------------------
; numbers of program header:
    mov eax, nuoph
    call sprint
    
    mov eax, 2
    call get_next_byte
    
        
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_nuoph
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .print_nuoph
.little_nuoph:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]

.print_nuoph:
    movzx eax, cx
    call iprint
    
    call print_lf
    
.finish_nuoph:

;-------------------------------------------
; size of section header:
    mov eax, siosh
    call sprint
    
    mov eax, 2
    call get_next_byte
    
        
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_siosh
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .print_siosh
.little_siosh:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]

.print_siosh:
    movzx eax, cx
    call iprint
    
    mov eax, strbys
    call sprint
    
.finish_siosh:

;-------------------------------------------
; number of section header:

    mov eax, nuosh
    call sprint
    
    mov eax, 2
    call get_next_byte
    
        
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_nuosh
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .print_nuosh
.little_nuosh:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]

.print_nuosh:
    movzx eax, cx
    call iprint
    
    mov eax, strbys
    call sprint
    
.finish_nuosh:

;-------------------------------------------
; section header string table index:
    mov eax, shsti
    call sprint
    
    mov eax, 2
    call get_next_byte
    
        
    xor cx, cx
    
    mov bl, 1
    cmp byte [litbig], bl
    je .little_shsti
    
    mov ch, byte [byteContents]
    mov cl, byte [byteContents+1]
    
    jmp .print_shsti
.little_shsti:
    mov ch, byte [byteContents+1]
    mov cl, byte [byteContents]

.print_shsti:
    movzx eax, cx
    call iprint
    
    call print_lf
    
.finish_shsti:
    
    
jmp finish

.nonelf:
    mov eax, nonelf
    call sprint
finish:
    call    quit                    ; call our quit function
    
