.model small
.stack 100h
.data
bios_ver db 13,10,'BIOS version: $'
buffer db 128 dup(0)
.code
org 100h
main proc
    mov ah, 0x0E     ; set cursor position
    mov bh, 0x00     ; page number
    mov dh, 0x00     ; row number
    mov dl, 0x00     ; column number
    int 0x10         ; invoke BIOS interrupt
    mov ah, 0x12     ; get BIOS data area segment
    int 0x15         ; invoke BIOS interrupt
    mov es, bx       ; set ES to the BIOS data area segment
    mov bx, word ptr es:[0x0000] ; get the BIOS ROM segment
    mov dx, 0xFFFF   ; set the starting offset
    mov si, offset buffer ; set the buffer address
read_loop:
    mov al, byte ptr ds:[bx:dx] ; read a byte from the BIOS ROM
    mov byte ptr [si], al ; store the byte in the buffer
    cmp al, 0x20     ; check for space character
    je end_read      ; if space, end of BIOS version string
    inc si           ; increment the buffer pointer
    inc dx           ; increment the offset
    jmp read_loop    ; loop until space character is found
end_read:
    mov ah, 0x09     ; print BIOS version string
    mov dx, offset bios_ver
    int 0x21         ; invoke MS-DOS interrupt
    mov ah, 0x09     ; print BIOS version string
    mov dx, offset buffer
    int 0x21         ; invoke MS-DOS interrupt
    mov ah, 0x4C     ; terminate program
    int 0x21         ; invoke MS-DOS interrupt
main endp
end main
