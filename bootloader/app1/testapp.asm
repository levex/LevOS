bits 32
org 0x800000

jmp main
msg db 0xA,0xD,"Hell yeah!", 0

main:
	mov ebx, msg
	mov eax, 0x02 ; print
	int 0x2F
	mov eax, 0x01 ; terminate 
	int 0x2F