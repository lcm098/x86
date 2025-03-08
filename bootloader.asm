[BITS 16]
[ORG 0x7C00]

start:
    ; Set up stack
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Initialize display
    call init_display

    ; Test screen resizing
    call test_screen_resizing

    ; Halt
    jmp $

; Initialize display
init_display:
    ; Set text mode (80x25)
    mov ax, 0x0003
    int 0x10

    ; Ensure cursor is visible
    mov ah, 0x01
    mov cx, 0x0607
    int 0x10
    ret

; Clear screen
clear_screen:
    mov ax, 0x0600
    mov bh, 0x07
    xor cx, cx
    mov dx, 0x184F
    int 0x10

    ; Reset cursor position
    xor dx, dx
    mov bh, 0
    mov ah, 0x02
    int 0x10
    ret

; Print string
; Input: SI = pointer to string
print_string:
    mov ah, 0x0E
    mov bh, 0x00
.print_char:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .print_char
.done:
    ret

; Calculate rows and columns based on font size
; Input: AL = font height
; Output: DH = rows, DL = columns
calculate_rows_columns:
    ; Calculate rows
    mov ah, 0
    mov bl, 250     ; VGA vertical resolution (400 scan lines)
    div bl          ; AX / BL = AL (rows), AH (remainder)
    mov dh, al      ; DH = rows

    ; Calculate columns
    mov dl, 80      ; Default columns (can be adjusted if needed)
    ret

; Set font and update resolution
; Input: AL = font height (8, 14, or 16)
set_font_and_resolution:
    push ax

    ; Set font
    cmp al, 8
    je .set_8_pixel_font
    cmp al, 14
    je .set_14_pixel_font

.set_16_pixel_font:
    mov ax, 0x1112  ; 8x16 font
    jmp .set_font

.set_8_pixel_font:
    mov ax, 0x1110  ; 8x8 font
    jmp .set_font

.set_14_pixel_font:
    mov ax, 0x1111  ; 8x14 font

.set_font:
    mov bl, 0
    int 0x10

    ; Calculate rows and columns
    pop ax
    call calculate_rows_columns

    ; Update resolution in BIOS Data Area (BDA)
    push es
    mov ax, 0x40
    mov es, ax
    dec dh          ; Convert rows to 0-based index
    mov byte [es:0x84], dh  ; Update rows in BDA
    pop es

    ; Reset cursor position
    xor dx, dx
    mov bh, 0
    mov ah, 0x02
    int 0x10

    ret

; Test screen resizing
test_screen_resizing:
    ; Clear screen
    call clear_screen

    ; Print welcome message
    mov si, welcome_msg
    call print_string

    ; Print instructions
    mov si, newline
    call print_string
    mov si, instructions_msg
    call print_string

    ; Main menu
.menu:
    ; Print newlines
    mov si, newline
    call print_string
    call print_string

    ; Print menu
    mov si, menu_msg
    call print_string

    ; Wait for choice
    call wait_for_key

    ; Check key selection
    cmp al, '1'
    je .set_8_pixel
    cmp al, '2'
    je .set_14_pixel
    cmp al, '3'
    je .set_16_pixel
    cmp al, '4'
    je .exit

    jmp .menu      ; Invalid selection, show menu again

.set_8_pixel:
    mov al, 8      ; 8-pixel font
    call set_font_and_resolution
    call clear_screen
    jmp .menu

.set_14_pixel:
    mov al, 14     ; 14-pixel font
    call set_font_and_resolution
    call clear_screen
    jmp .menu

.set_16_pixel:
    mov al, 16     ; 16-pixel font
    call set_font_and_resolution
    call clear_screen
    jmp .menu

.exit:
    ; Final message
    call clear_screen
    mov si, final_msg
    call print_string

    ; Wait for a keypress
    call wait_for_key

    ret

; Wait for keypress
wait_for_key:
    mov ah, 0
    int 0x16
    ret

; Data
welcome_msg db "Screen Resolution Test Program", 0
instructions_msg db "This program lets you test different screen resolutions.", 0
menu_msg db "Select a font size:", 13, 10
         db "1. 8-pixel font", 13, 10
         db "2. 14-pixel font", 13, 10
         db "3. 16-pixel font", 13, 10
         db "4. Exit", 13, 10
         db "Your choice: ", 0
final_msg db "Screen resolution test complete.", 13, 10
         db "Press any key to exit.", 0
newline db 13, 10, 0

; Bootloader signature
times 510-($-$$) db 0
dw 0xAA55