

section .bss
    num1 resb 100 ;reserve 100 bytes in memory
    num2 resb 100 ;reserve 100 bytes in memory
    result resb 100 ;reserve 100 bytes in memory

section .text
    global _start


_start:

    MOV eax, 3 ;invoke read system call
    MOV ebx, 0 ;stdin
    MOV ecx, num1 ;point to num1
    MOV edx, 100 ;length of num1
    int 0x80 ; call kernel


    MOV eax, 3 ;invoke read system call
    MOV ebx, 0 ;stdin
    MOV ecx, num2 ;point to num2
    MOV edx, 100 ;length of num2
    int 0x80 ; call kernel

    ;convert ascii value to integer
    MOV esi, num1 ;point to num1
    call atoi ;call atoi function
    MOV eax, num1 ;move num1 to eax

    MOV esi, num2 ;point to num2
    call atoi ;call atoi function
    MOV ebx, num2 ;move num2 to ebx

    ADD eax,ebx ;add eax and ebx
    MOV [result], eax ;store result in result

    MOV eax, 4 ;invoke write system call
    MOV ebx, 1 ;stdout
    LEA ecx, result ;point to result
    MOV edx, 100 ;length of result
    int 0x80 ; call kernel

    MOV eax,1 ;exit system call
    XOR ebx, ebx ;exit code 0
    int 0x80 ;call kernel


