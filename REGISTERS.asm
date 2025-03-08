

bits 16
org 0x7c00 ; bootloader start address


start:
    ; setup fresh segments
    xor ax, ax ; clear ax to (0)
    mov ds, ax ; set ds to 0
    mov es, ax ; set es to 0
    mov ss, ax ; set ss to 0
    mov sp, 0x7c00 ; set up the stack pointer

    ; move the data between registers
    mov si, msg1
    call print_greeting

    mov si, msg2
    call print_greeting

    mov si, msg3
    call print_greeting

    cli ; clear interrupts
    hlt ; halt the system

print_greeting:
    pusha ; save the previous values of the registers
    mov ah, 0x0E ; set bios teletype function
    mov bh, 0x00 ; page number (0)
    mov bl, 0x0A ; text attribute (light gray on black)

.loop:
    lodsb ; load the byte at address ds:si into al
    int 0x10 ; call the BIOS interrupt to print the character
    test al, al ; check if al is zero
    jz .done ; if al is zero, we are done
    jmp .loop ; repeat for the next character

.done:
    popa ; restore the previous values of the registers
    ret ; return from the function

msg1: db 'Hello, India', 0
msg2: db 'Welcome To My Own Bootloader', 0
msg3: db 'This is my first bootloader', 0

times 510-($-$$) db 0 ; fill the rest of the sector with 0s
dw 0xAA55 ; boot signature