; minimal.asm
BITS 16
ORG 0x7c00

; Main entry point
start:
    ; Set up segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    
    ; Set up stack
    mov ss, ax
    mov sp, 0x7C00
    
    ; Print message
    mov si, message
    call print_string
    
    ; Infinite loop
    cli
    hlt
hang:
    jmp hang

; Function to print a string
print_string:
    pusha
    mov ah, 0x0E        ; BIOS teletype function
.loop:
    lodsb               ; Load character from SI into AL
    test al, al         ; Check if character is 0 (end of string)
    jz .done            ; If zero, we're done
    int 0x10            ; Print the character
    jmp .loop           ; Repeat for next character
.done:
    popa
    ret

message: db 'Hello, World!', 0

; Pad to 510 bytes and add boot signature
times 510 - ($ - $$) db 0
dw 0xAA55