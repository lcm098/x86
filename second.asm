
bits 16
org 0x7c00 ; bootloader start address 


; main entry point
section .text:
    ; setup segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00 ; set up the stack pointer

    ; move the data between registers
    mov ax, 0x1234 ; load ax with value 0x1234
    mov bx, ax ; copy the value of ax to bx
    mov cx, 0x5678 ; load cx with value 0x5678

    ; store value in memory
    mov [my_variable], ax ; store the value of ax in memory location my_variable
    mov dx, [my_variable] ; load the value of my_variable into dx

    mov si, dx ; load the value of dx into si
    call print_string ; call the print_string function


print_string:
    pusha; save the registers
    mov ah, 0x0E ; BIOS Interrupt 0x10, function 0x0E (ah used for interrupt service rutine)
.loop:
    lodsb ; load the byte at address ds:si into al
    test al, al ; check if al is zero
    jz .done ; if al is zero, we are done
    int 0x10 ; call the BIOS interrupt to print the character
    jmp .loop ; repeat for the next character
.done:
    popa ; restore the registers
    ret ; return from the function    


my_variable dw 0
; bootloader signature
times 510-($-$$) db 0 ; fill the rest of the sector with 0s
dw 0xaa55 ; boot signature
