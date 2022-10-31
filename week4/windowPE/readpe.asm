.386
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\masm32rt.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\masm32.lib

.data?
    sizeOfDataDirArr dd ?
    PEversion dw ?
    numberOfSections dw ?
    file_name db 128 dup (?)
    file_contents db 128 dup (?)
    file_handle HANDLE ?
    	
    bytes_read db ?
	
    buffer DWORD ?
	
    ImportDirExist DWORD ?
    ImportDirRVA DWORD ?
    ImportDirSize DWORD ?
    ImportDirOft DWORD ?


	
    ExportDirExist DWORD ?
    ExportDirRVA DWORD ?
    ExportDirSize DWORD ?
    ExportDirOft DWORD ?

	
    tempRVAddr DWORD ?
    tempRawAddr DWORD ?
	
    tempOfts DWORD ?
	
    libNameAddr DWORD ?
    firstThunk DWORD ?
    tempfunc DWORD ?
	
    SectionAlignment DWORD ?
    count DWORD ?
    countW DWORD ?
    

.data
    ofs OFSTRUCT<>
	
    doneImportDirAddr db 0
    doneExportDirAddr db 0
.code

get_next proc ByteToRead: DWORD
    
    invoke ReadFile, file_handle, offset file_contents, ByteToRead, offset bytes_read, 0
    ret

get_next endp

start:


invoke GetCL, 1, offset file_name

invoke OpenFile, offset file_name, offset ofs, OF_READ
mov file_handle, eax


DOS_Header:
    printf ("DOS Header\n")
    
    invoke get_next, 2
    xor eax, eax
    movzx eax, word ptr [file_contents]
    .if eax == 23117
        printf ("    Magic number:                      0x5a4d (MZ)\n")
    .else
        jmp not_pe
    .endif

    invoke get_next, 2
    printf ("    Bytes in last page:                %d\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Pages in file:                     %d\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Relocations:                       %d\n", word ptr [file_contents])
    
    invoke get_next, 2
    printf ("    Size of header in paragraphs:      %d\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Minimum extra paragraphs:          %d\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Maximum extra paragraphs:          %d\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Initial (relative) SS value:       0x%x\n", word ptr [file_contents])
    
    invoke get_next, 2
    printf ("    Initial SP value:                  0x%x\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Checksum:                          0x%x\n", word ptr [file_contents])


    invoke get_next, 2
    printf ("    Initial IP value:                  0x%x\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Initial (relative) CS value:       0x%x\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Address of relocation table:       0x%x\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    Overlay number:                    0x%x\n", word ptr [file_contents])

    invoke get_next, 8                      ; reserved bytes
    
    invoke get_next, 2
    printf ("    OEM indentifier:                   0x%x\n", word ptr [file_contents])

    invoke get_next, 2
    printf ("    OEM information:                   0x%x\n", word ptr [file_contents])

    invoke get_next, 20                     ; reserved bytes

    invoke get_next, 4
    printf ("    PE header offset:                  0x%x\n", dword ptr [file_contents])


invoke SetFilePointer, file_handle, dword ptr [file_contents], 0, FILE_BEGIN

invoke get_next, 4

NT_Header:
    printf ("NT Header\n")

    File_Header:
    printf ("    File Header\n")
        invoke get_next, 2
        printf ("        Machine:                       0x%x ", word ptr [file_contents])

        movzx eax, word ptr [file_contents]
        .if eax == 0
            printf ("IMAGE_FILE_MACHINE_UNKNOWN")
        .elseif eax == 467
            printf ("IMAGE_FILE_MACHINE_AM33")
        .elseif eax == 34404
            printf ("IMAGE_FILE_MACHINE_AMD64")
        .elseif eax == 448
            printf ("IMAGE_FILE_MACHINE_ARM")
        .elseif eax == 43620
            printf ("IMAGE_FILE_MACHINE_ARM64")
        .elseif eax == 452
            printf ("IMAGE_FILE_MACHINE_ARMNT")
        .elseif eax == 3772
            printf ("IMAGE_FILE_MACHINE_EBC")
        .elseif eax == 332
            printf ("IMAGE_FILE_MACHINE_I386")
        .elseif eax == 512
            printf ("IMAGE_FILE_MACHINE_IA64")
        .elseif eax == 25138
            printf ("IMAGE_FILE_MACHINE_LOONGARCH32")
        .elseif eax == 25188
            printf ("IMAGE_FILE_MACHINE_LOONGARCH64")
        .elseif eax == 36929
            printf ("IMAGE_FILE_MACHINE_M32R")
        .elseif eax == 614
            printf ("IMAGE_FILE_MACHINE_MIPS16")
        .elseif eax == 870
            printf ("IMAGE_FILE_MACHINE_MIPSFPU")
        .elseif eax == 1126
            printf ("IMAGE_FILE_MACHINE_MIPSFPU16")
        .elseif eax == 496
            printf ("IMAGE_FILE_MACHINE_POWERPC")
        .elseif eax == 497
            printf ("IMAGE_FILE_MACHINE_POWERPCFP")
        .elseif eax == 358
            printf ("IMAGE_FILE_MACHINE_R4000")
        .elseif eax == 20530
            printf ("IMAGE_FILE_MACHINE_RISCV32")
        .elseif eax == 20580
            printf ("IMAGE_FILE_MACHINE_RISCV64")
        .elseif eax == 20776
            printf ("IMAGE_FILE_MACHINE_RISCV128")
        .elseif eax == 418
            printf ("IMAGE_FILE_MACHINE_SH3")
        .elseif eax == 419
            printf ("IMAGE_FILE_MACHINE_SH3DSP")
        .elseif eax == 422
            printf ("IMAGE_FILE_MACHINE_SH4")
        .elseif eax == 424
            printf ("IMAGE_FILE_MACHINE_SH5")
        .elseif eax == 450
            printf ("IMAGE_FILE_MACHINE_THUMB")
        .elseif eax == 361
            printf ("IMAGE_FILE_MACHINE_WCEMIPSV2")
        .else
            printf ("UNKNOWN")
        .endif
        printf ("\n")

        invoke get_next, 2
        printf ("        Number of sections:            %d\n", word ptr [file_contents])
        mov ax, word ptr [file_contents]
        mov numberOfSections, ax


        invoke get_next, 4
        printf ("        Date/time stamp:               %d\n", dword ptr [file_contents])

        invoke get_next, 4
        printf ("        Symbol Table offset:           %d\n", dword ptr [file_contents])

        invoke get_next, 4
        printf ("        Number of symbols:             %d\n", dword ptr [file_contents])

        invoke get_next, 2
        printf ("        Size of optional header:       0x%x\n", word ptr [file_contents])

        invoke get_next, 2
        printf ("        Characteristics:               0x%x\n", word ptr [file_contents])

        printf ("        Characteristics names\n")

        xor eax, eax                            
        movzx eax, word ptr [file_contents]
        
        .if eax >= 32768
            push eax
            printf ("                                       IMAGE_FILE_BYTES_REVERSED_HI\n")
            pop eax
            sub eax, 32768
        .endif
        .if eax >= 16384
            push eax
            printf ("                                       IMAGE_FILE_UP_SYSTEM_ONLY\n")
            pop eax
            sub eax, 16384
        .endif
        .if eax >= 8192
            push eax
            printf ("                                       IMAGE_FILE_DLL\n")
            pop eax
            sub eax, 8192
        .endif
        .if eax >= 4096
            push eax
            printf ("                                       IMAGE_FILE_SYSTEM\n")
            pop eax
            sub eax, 4096
        .endif
        .if eax >= 2048
            push eax
            printf ("                                       IMAGE_FILE_NET_RUN_FROM_SWAP\n")
            pop eax
            sub eax, 2048
        .endif
        .if eax >= 1024
            push eax
            printf ("                                       IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP\n")
            pop eax
            sub eax, 1024
        .endif
        .if eax >= 512
            push eax
            printf ("                                       IMAGE_FILE_DEBUG_STRIPPED\n")
            pop eax
            sub eax, 512
        .endif
        .if eax >= 256
            push eax
            printf ("                                       IMAGE_FILE_32BIT_MACHINE\n")
            pop eax
            sub eax, 256
        .endif
        .if eax >= 128
            push eax
            printf ("                                       IMAGE_FILE_BYTES_REVERSED_LO\n")
            pop eax
            sub eax, 128
        .endif
        .if eax >= 64
            sub eax, 64
        .endif
        .if eax >= 32
            push eax
            printf ("                                       IMAGE_FILE_LARGE_ADDRESS_AWARE\n")
            pop eax
            sub eax, 32
        .endif
        .if eax >= 16
            push eax
            printf ("                                       IMAGE_FILE_AGGRESSIVE_WS_TRIM\n")
            pop eax
            sub eax, 16
        .endif
        .if eax >= 8
            push eax
            printf ("                                       IMAGE_FILE_LOCAL_SYMS_STRIPPED\n")
            pop eax
            sub eax, 8
        .endif
        .if eax >= 4
            push eax
            printf ("                                       IMAGE_FILE_LINE_NUMS_STRIPPED\n")
            pop eax
            sub eax, 4
        .endif
        .if eax >= 2
            push eax
            printf ("                                       IMAGE_FILE_EXECUTABLE_IMAGE\n")
            pop eax
            sub eax, 2
        .endif
        .if eax >= 1
            push eax
            printf ("                                       IMAGE_FILE_RELOCS_STRIPPED\n")
            pop eax
            sub eax, 1
        .endif

    Optional_Header:
        printf ("    Optional/Image header\n")

        invoke get_next, 2
        printf ("        Magic number:                  0x%x ", word ptr [file_contents])
        mov ax, word ptr [file_contents]

        .if ax == 267
            mov PEversion, 32
            printf ("(PE32)\n")
        .elseif ax == 523
            mov PEversion, 64
            printf ("(PE32+)\n")
        .else
            printf ("UNKNOWN\n")
        .endif
        
        invoke get_next, 1
        printf ("        Linker major version:          %d\n", byte ptr [file_contents])

        invoke get_next, 1
        printf ("        Linker minor version:          %d\n", byte ptr [file_contents])

        invoke get_next, 4
        printf ("        Size of .text section:         0x%x\n", dword ptr [file_contents])

        invoke get_next, 4
        printf ("        Size of .data section:         0x%x\n", dword ptr [file_contents])

        invoke get_next, 4
        printf ("        Size of .bss section:          0x%x\n", dword ptr [file_contents])

        invoke get_next, 4
        printf ("        Entry point:                   0x%x\n", dword ptr [file_contents])

        invoke get_next, 4
        printf ("        Address of .text section:      0x%x\n", dword ptr [file_contents])

        .if PEversion == 32

            invoke get_next, 4
            printf ("        Address of .data section:      0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Image base:                    0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
			push dword ptr [file_contents]
			pop SectionAlignment
            printf ("        Alignment of sections:         0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Alignment of factor:           0x%x\n", dword ptr [file_contents])

            invoke get_next, 2
            printf ("        Major version of require OS:   %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Minor version of require OS:   %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Major version of image:        %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Minor version of image:        %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Major version of subsystem:    %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Minor version of subsystem:    %d\n", word ptr [file_contents])

            invoke get_next, 4
            ; printf ("        Win32 version value:           %d\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of image:                 0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of header:                0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Checksum:                      0x%x\n", dword ptr [file_contents])

            invoke get_next, 2
            printf ("        Subsystem required:            0x%x ", word ptr [file_contents])

            mov eax, dword ptr [file_contents]

            .if eax == 0
                printf ("(IMAGE_SUBSYSTEM_UNKNOWN)\n")
            .elseif eax == 1
                printf ("(IMAGE_SUBSYSTEM_NATIVE)\n")
            .elseif eax == 2
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_GUI)\n")
            .elseif eax == 3
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_CUI)\n")
            .elseif eax == 5
                printf ("(IMAGE_SUBSYSTEM_OS2_CUI)\n")
            .elseif eax == 7
                printf ("(IMAGE_SUBSYSTEM_POSIX_CUI)\n")
            .elseif eax == 8
                printf ("(IMAGE_SUBSYSTEM_NATIVE_WINDOWS)\n")
            .elseif eax == 9
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_CE_GUI)\n")
            .elseif eax == 10
                printf ("(IMAGE_SUBSYSTEM_EFI_APPLICATION)\n")
            .elseif eax == 11
                printf ("(IMAGE_SUBSYSTEM_EFI_BOOT_ SERVICE_DRIVER)\n")
            .elseif eax == 12
                printf ("(IMAGE_SUBSYSTEM_EFI_RUNTIME_ DRIVER)\n")
            .elseif eax == 13
                printf ("(IMAGE_SUBSYSTEM_EFI_ROM)\n")
            .elseif eax == 14
                printf ("(IMAGE_SUBSYSTEM_XBOX)\n")
            .elseif eax == 16
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_BOOT_APPLICATION)\n")
            .else
                printf ("UNKNOWN\n")
            .endif

            invoke get_next, 2
            printf ("        DLL characteristics:           %d\n", word ptr [file_contents])

            ; DLL characteristics names
            printf ("        DLL characteristics name\n")
            xor eax, eax                            
            movzx eax, word ptr [file_contents]
        
            .if eax >= 32768
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE\n")
                pop eax
                sub eax, 32768
            .endif
            .if eax >= 16384
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_GUARD_CF\n")
                pop eax
                sub eax, 16384
            .endif
            .if eax >= 8192
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_WDM_DRIVER\n")
                pop eax
                sub eax, 8192
            .endif
            .if eax >= 4096
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_APPCONTAINER\n")
                pop eax
                sub eax, 4096
            .endif
            .if eax >= 2048
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NO_BIND\n")
                pop eax
                sub eax, 2048
            .endif
            .if eax >= 1024
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NO_SEH\n")
                pop eax
                sub eax, 1024
            .endif
            .if eax >= 512
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NO_ISOLATION\n")
                pop eax
                sub eax, 512
            .endif
            .if eax >= 256
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NX_COMPAT\n")
                pop eax
                sub eax, 256
            .endif
            .if eax >= 128
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_FORCE_INTEGRITY\n")
                pop eax
                sub eax, 128
            .endif
            .if eax >= 64
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE\n")
                sub eax, 64
                pop eax
            .endif
            .if eax >= 32
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_HIGH_ENTROPY_VA\n")
                pop eax
                sub eax, 32
            .endif
            .if eax >= 16
                sub eax, 16
            .endif
            .if eax >= 8
                sub eax, 8
            .endif
            .if eax >= 4
                sub eax, 4
            .endif
            .if eax >= 2
                sub eax, 2
            .endif
            .if eax >= 1
                sub eax, 1
            .endif


            invoke get_next, 4
            printf ("        Size of stack to reserve:      0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of stack to commit:       0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of heap space to reserve: 0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of heap space to commit:  0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Loader flags:                  0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of data directories array:0x%x\n", dword ptr [file_contents])
            mov eax, dword ptr [file_contents]
            mov sizeOfDataDirArr, eax

            
        .elseif PEversion == 64

            invoke get_next, 8
            printf ("        Image base:                    0x%08x", dword ptr [file_contents+4])
            printf ("%08x\n", dword ptr [file_contents])


            invoke get_next, 4
            printf ("        Alignment of sections:         0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Alignment of factor:           0x%x\n", dword ptr [file_contents])

            invoke get_next, 2
            printf ("        Major version of require OS:   %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Minor version of require OS:   %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Major version of image:        %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Minor version of image:        %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Major version of subsystem:    %d\n", word ptr [file_contents])

            invoke get_next, 2
            printf ("        Minor version of subsystem:    %d\n", word ptr [file_contents])

            invoke get_next, 4
            ; printf ("        Win32 version value:           %d\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of image:                 0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of header:                0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Checksum:                      0x%x\n", dword ptr [file_contents])

            invoke get_next, 2
            printf ("        Subsystem required:            0x%x ", word ptr [file_contents])

            mov eax, dword ptr [file_contents]

            .if eax == 0
                printf ("(IMAGE_SUBSYSTEM_UNKNOWN)\n")
            .elseif eax == 1
                printf ("(IMAGE_SUBSYSTEM_NATIVE)\n")
            .elseif eax == 2
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_GUI)\n")
            .elseif eax == 3
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_CUI)\n")
            .elseif eax == 5
                printf ("(IMAGE_SUBSYSTEM_OS2_CUI)\n")
            .elseif eax == 7
                printf ("(IMAGE_SUBSYSTEM_POSIX_CUI)\n")
            .elseif eax == 8
                printf ("(IMAGE_SUBSYSTEM_NATIVE_WINDOWS)\n")
            .elseif eax == 9
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_CE_GUI)\n")
            .elseif eax == 10
                printf ("(IMAGE_SUBSYSTEM_EFI_APPLICATION)\n")
            .elseif eax == 11
                printf ("(IMAGE_SUBSYSTEM_EFI_BOOT_ SERVICE_DRIVER)\n")
            .elseif eax == 12
                printf ("(IMAGE_SUBSYSTEM_EFI_RUNTIME_ DRIVER)\n")
            .elseif eax == 13
                printf ("(IMAGE_SUBSYSTEM_EFI_ROM)\n")
            .elseif eax == 14
                printf ("(IMAGE_SUBSYSTEM_XBOX)\n")
            .elseif eax == 16
                printf ("(IMAGE_SUBSYSTEM_WINDOWS_BOOT_APPLICATION)\n")
            .else
                printf ("UNKNOWN\n")
            .endif

            invoke get_next, 2
            printf ("        DLL characteristics:           %d\n", word ptr [file_contents])

            ; DLL characteristics names
            printf ("        DLL characteristics name\n")
            xor eax, eax                            
            movzx eax, word ptr [file_contents]
        
            .if eax >= 32768
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE\n")
                pop eax
                sub eax, 32768
            .endif
            .if eax >= 16384
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_GUARD_CF\n")
                pop eax
                sub eax, 16384
            .endif
            .if eax >= 8192
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_WDM_DRIVER\n")
                pop eax
                sub eax, 8192
            .endif
            .if eax >= 4096
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_APPCONTAINER\n")
                pop eax
                sub eax, 4096
            .endif
            .if eax >= 2048
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NO_BIND\n")
                pop eax
                sub eax, 2048
            .endif
            .if eax >= 1024
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NO_SEH\n")
                pop eax
                sub eax, 1024
            .endif
            .if eax >= 512
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NO_ISOLATION\n")
                pop eax
                sub eax, 512
            .endif
            .if eax >= 256
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_NX_COMPAT\n")
                pop eax
                sub eax, 256
            .endif
            .if eax >= 128
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_FORCE_INTEGRITY\n")
                pop eax
                sub eax, 128
            .endif
            .if eax >= 64
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE\n")
                sub eax, 64
                pop eax
            .endif
            .if eax >= 32
                push eax
                printf ("                                       IMAGE_DLLCHARACTERISTICS_HIGH_ENTROPY_VA\n")
                pop eax
                sub eax, 32
            .endif
            .if eax >= 16
                sub eax, 16
            .endif
            .if eax >= 8
                sub eax, 8
            .endif
            .if eax >= 4
                sub eax, 4
            .endif
            .if eax >= 2
                sub eax, 2
            .endif
            .if eax >= 1
                sub eax, 1
            .endif


            invoke get_next, 8
            printf ("        Size of stack to reserve:      0x%08x", dword ptr [file_contents+4])
            printf ("%08x\n", dword ptr [file_contents])

            invoke get_next, 8
            printf ("        Size of stack to commit:       0x%08x", dword ptr [file_contents+4])
            printf ("%08x\n", dword ptr [file_contents])

            invoke get_next, 8
            printf ("        Size of heap space to reserve: 0x%08x", dword ptr [file_contents+4])
            printf ("%08x\n", dword ptr [file_contents])

            invoke get_next, 8
            printf ("        Size of heap space to commit:  0x%08x", dword ptr [file_contents+4])
            printf ("%08x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Loader flags:                  0x%x\n", dword ptr [file_contents])

            invoke get_next, 4
            printf ("        Size of data directories array:0x%x\n", dword ptr [file_contents])
            mov eax, dword ptr [file_contents]
            mov sizeOfDataDirArr, eax

        .else
        .endif

        ; Data Directories
        printf ("    Data directories:\n")
        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax

            printf ("        Export directory:\n")
                invoke get_next, 4
				push dword ptr [file_contents]
				pop ExportDirRVA
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
				push dword ptr [file_contents]
				pop ExportDirSize
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
			.if (ExportDirRVA == 0)
				.if (ExportDirSize == 0)
					xor eax, eax
					mov ExportDirExist, eax
				.else
					mov eax, 1
					mov ExportDirExist, eax
				.endif
			.else
				mov eax, 1
				mov ExportDirExist, eax
			.endif
		.endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Import directory:\n")
                invoke get_next, 4
				push dword ptr [file_contents]
				pop ImportDirRVA
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
				push dword ptr [file_contents]
				pop ImportDirSize
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
			.if (ImportDirRVA == 0)
				.if (ImportDirSize == 0)
					xor eax, eax
					mov ImportDirExist, eax
				.else
					mov eax, 1
					mov ImportDirExist, eax
				.endif
			.else
				mov eax, 1
				mov ImportDirExist, eax
			.endif
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Resource directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Exception directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Security directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Relocation directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Debug directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Architecture directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif


            ; reserved
        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            invoke get_next, 8
        .endif


        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        TLS directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Configuration directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Bound import directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Import address directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax
            printf ("        Delay import directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif

        .if sizeOfDataDirArr > 0
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax       
            printf ("        .NET meta data directory:\n")
                invoke get_next, 4
                printf ("            Address:                   0x%x\n", dword ptr [file_contents])
                invoke get_next, 4
                printf ("            Size:                      0x%x\n", dword ptr [file_contents])
        .endif



        printf ("        %d Unknown directories\n", sizeOfDataDirArr)
        
        .while sizeOfDataDirArr > 0
            invoke get_next, 8
            mov eax, sizeOfDataDirArr
            dec eax
            mov sizeOfDataDirArr, eax

        .endw

; Section Headers:
    printf ("Section Headers\n")

    .while numberOfSections > 0

        printf ("    Name: ")
        invoke get_next, 8
        invoke StdOut, offset file_contents
        printf ("\n")
            invoke get_next, 4
            printf ("        Virtual Size:                  0x%x\n", dword ptr [file_contents])
            invoke get_next, 4
			push dword ptr [file_contents]
			pop tempRVAddr
            printf ("        Virtual Address:               0x%x\n", dword ptr [file_contents])
            invoke get_next, 4
            printf ("        Raw Data Size:                 0x%x\n", dword ptr [file_contents])
            invoke get_next, 4
			push dword ptr [file_contents]
			pop tempRawAddr
            printf ("        Raw Data Address:              0x%x\n", dword ptr [file_contents])
            invoke get_next, 4
            printf ("        Relocations Address:           0x%x\n", dword ptr [file_contents])
            invoke get_next, 4
            printf ("        Line Numbers Address:          0x%x\n", dword ptr [file_contents])
            invoke get_next, 2
            printf ("        Relocations Number:            0x%x\n", word ptr [file_contents])
            invoke get_next, 2
            printf ("        Line Numbers Number:           0x%x\n", word ptr [file_contents])
            invoke get_next, 4
            printf ("        Characteristics:               0x%x\n", dword ptr [file_contents])

			.if (ImportDirExist != 0)
				mov eax, tempRVAddr
				add eax, SectionAlignment
				.if eax > ImportDirRVA
					.if doneImportDirAddr == 0
						mov eax, ImportDirRVA
						sub eax, tempRVAddr
						add eax, tempRawAddr
						mov ImportDirOft, eax
						mov al, 1
						mov doneImportDirAddr, al
					.else
						nop
					.endif
				.endif
			.endif
			
			.if (ExportDirExist != 0)
				mov eax, tempRVAddr
				add eax, SectionAlignment
				.if eax > ExportDirRVA
					.if doneExportDirAddr == 0
						mov eax, ExportDirRVA
						sub eax, tempRVAddr
						add eax, tempRawAddr
						mov ExportDirOft, eax
						mov al, 1
						mov doneExportDirAddr, al
					.else
						nop
					.endif
				.endif
			.endif
				
        mov ax, numberOfSections
        dec ax
        mov numberOfSections, ax
            
     .endw

Import_Directories:
	printf ("Import Directories\n")
	.if ImportDirExist == 0
		jmp finish_importDir
	.endif
	
	xor eax, eax
	mov countW, eax
	.while TRUE
		mov eax, countW
		mov edi, 20
		mul edi
		add eax, ImportDirOft
		mov edi, eax
		
		invoke SetFilePointer, file_handle, edi, 0, FILE_BEGIN
		invoke get_next, 20
		.if dword ptr [file_contents] == 0
			.if dword ptr [file_contents+4] == 0
				.if dword ptr [file_contents+8] == 0
					.if dword ptr [file_contents+12] == 0
						.if dword ptr [file_contents+16] == 0
							.break
						.endif
					.endif
				.endif
			.endif
		.endif
		push dword ptr [file_contents+12]
		pop libNameAddr
		mov eax, libNameAddr
		sub eax, ImportDirRVA
		add eax, ImportDirOft
		mov libNameAddr, eax
		
		push dword ptr [file_contents+16]
		pop firstThunk
		mov eax, firstThunk
		sub eax, ImportDirRVA
		add eax, ImportDirOft
		mov firstThunk, eax
		
		
		printf ("    Library\n")
		printf ("        Name:                          ")
			  
		invoke SetFilePointer, file_handle, libNameAddr, 0, FILE_BEGIN
		invoke get_next, 64
		invoke StdOut, offset file_contents
		printf ("\n")
		
		xor eax, eax
		mov count, eax
		.while TRUE
			
			mov eax, count
			mov esi, 4
			mul esi
			add eax, firstThunk
			mov esi, eax
			
			invoke SetFilePointer, file_handle, esi, 0, FILE_BEGIN

			invoke get_next, 4
			push dword ptr [file_contents]
			pop tempfunc
			.break .if (tempfunc == 0)
			mov eax, tempfunc
			sub eax, ImportDirRVA
			add eax, ImportDirOft
			mov tempfunc, eax
			
			invoke SetFilePointer, file_handle, tempfunc, 0, FILE_BEGIN
			invoke get_next, 64
			printf ("        Functions\n")
			printf ("            Hint:                      0x%x\n", word ptr [file_contents])
			printf ("            Name:                      ")

			invoke StdOut, offset file_contents+2
			printf ("\n")
			
			mov esi, count
			inc esi
			mov count, esi
		.endw
		
		mov edi, countW
		inc edi
		mov countW, edi
	
	.endw

	finish_importDir:
	
Export_Directories:
	printf ("Export Directories\n")
	.if ExportDirExist == 0
		jmp finish_exportDir
	.endif
	
	xor eax, eax
	mov countW, eax
	.while TRUE
		mov eax, countW
		mov edi, 20
		mul edi
		add eax, ExportDirOft
		mov edi, eax
		
		invoke SetFilePointer, file_handle, edi, 0, FILE_BEGIN
		invoke get_next, 20
		.if dword ptr [file_contents] == 0
			.if dword ptr [file_contents+4] == 0
				.if dword ptr [file_contents+8] == 0
					.if dword ptr [file_contents+12] == 0
						.if dword ptr [file_contents+16] == 0
							.break
						.endif
					.endif
				.endif
            .endif
		.endif
		push dword ptr [file_contents+12]
		pop libNameAddr
		mov eax, libNameAddr
		sub eax, ExportDirRVA
		add eax, ExportDirOft
		mov libNameAddr, eax
		
		push dword ptr [file_contents+16]
		pop firstThunk
		mov eax, firstThunk
		sub eax, ExportDirRVA
		add eax, ExportDirOft
		mov libNameAddr, eax
		
		push dword ptr [file_contents+16]
		pop firstThunk
		mov eax, firstThunk
		sub eax, ExportDirRVA
		add eax, ExportDirOft
		mov firstThunk, eax
		
		
		printf ("    Library\n")
		printf ("        Name:                          ")
			  
		invoke SetFilePointer, file_handle, libNameAddr, 0, FILE_BEGIN
		invoke get_next, 64
		invoke StdOut, offset file_contents
		printf ("\n")
		
		xor eax, eax
		mov count, eax
		.while TRUE
			
			mov eax, count
			mov esi, 4
			mul esi
			add eax, firstThunk
			mov esi, eax
			
			invoke SetFilePointer, file_handle, esi, 0, FILE_BEGIN

			invoke get_next, 4
			push dword ptr [file_contents]
			pop tempfunc
			.break .if (tempfunc == 0)
			mov eax, tempfunc
			sub eax, ExportDirRVA
			add eax, ExportDirOft
			mov tempfunc, eax
			
			invoke SetFilePointer, file_handle, tempfunc, 0, FILE_BEGIN
			invoke get_next, 64
			printf ("        Functions\n")
			printf ("            Hint:                      0x%x\n", word ptr [file_contents])
			printf ("            Name:                      ")

			invoke StdOut, offset file_contents+2
			printf ("\n")
			
			mov esi, count
			inc esi
			mov count, esi
		.endw
		
		mov edi, countW
		inc edi
		mov countW, edi
	
	.endw

	finish_exportDir:
	
	
inkey

jmp done
not_pe:
    printf ("Not a PE file\n")
    
done:
invoke ExitProcess, 0

end start


