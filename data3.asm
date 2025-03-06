


section .data
	char db 'Z'
	list db  1, 2, 3, 4, 5,6, 7, 8, 9, 0
	name db "Danishk", 10
	name_len equ $ - name


section .bss
	buffer resb 2 ; (1char + newline)

section .text
	global _start

	_start:
		MOV eax, 4 ; invoke write system call
		MOV ebx, 1 ; stdout
		LEA ecx, char ;point to char
		MOV edx, 1 ;length of character
		INT 0x80

		MOV eax, 4
		MOV ebx, 1
		LEA ecx, name
		MOV edx, name_len
		INT 0x80

		MOV al, [list+5] ;load 6th item in list
		ADD al, '0' ; convert to ascii
		MOV [buffer], al ;store converted ascii to buffer
		MOV byte [buffer+1], 10 ; store newline in buffer

		MOV eax, 4
		MOV ebx, 1
		LEA ecx, buffer
		MOV edx,2
		INT 0x80

		MOV eax, 1
		XOR ebx, ebx
		INT 0x80

