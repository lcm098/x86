section .data
    len db 3           ; Length of item to print (1 char + newline)

section .bss
    list resb 10       ; Reserve 10 bytes for list
    item resb 3        ; Reserve 2 bytes (char + newline)

section .text
    global _start

_start:
    ; Store values in the list
    mov ah, 10
    mov [list], ah
    mov ah, 20
    mov [list+1], ah
    mov ah, 30
    mov [list+2], ah
    mov ah, 40
    mov [list+3], ah
    mov ah, 50
    mov [list+4], ah
    mov ah, 60
    mov [list+5], ah
    mov ah, 70
    mov [list+6], ah
    mov ah, 80
    mov [list+7], ah
    mov ah, 90
    mov [list+8], ah
    mov ah, 0           ; Null terminator (optional for clarity)
    mov [list+9], ah

    ; Extract value from list+7, convert to ASCII
    mov al, [list+4]    ; Load value from list+7 (80)
    mov ah, 0 ;clear high bytes

    mov bl, 10 ; Divisor for conversion (base 10)
    div bl              ; Divide by 10

    add al, '0'         ; Convert to ASCII (basic conversion, may need more handling)
    add ah, '0'         ; Convert to ASCII (basic conversion, may need more handling)


    mov [item], al      ; Store character in item
    mov [item+1], ah    ; Store newline character '\n'
    mov byte [item+2], 10  ; Store newline character '\n'

    ; Print item
    mov eax, 4          ; write system call
    mov ebx, 1          ; stdout
    lea ecx, item       ; pointer to item
    mov edx, len         ; length of item (char + newline)
    int 0x80            ; call kernel

    ; Exit program
    mov eax, 1          ; exit system call
    xor ebx, ebx        ; exit code 0
    int 0x80            ; call kernel
