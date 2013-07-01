%ifndef __STDIO_INC
%define __STDIO_INC
 
bits	16

;Resets the system in PMODE
Reset:
	mov	al, 1	; set bit 1 (fast reset)
	out	0x92, al

;Prints a string in REALMODE
Print:
		pusha				; save registers
.Loop1:
		lodsb				; load next byte from string from SI to AL
		or	al, al			; Does AL=0?
		jz	Puts16Done		; Yep, null terminator found-bail out
		mov	ah, 0eh			; Nope-Print the character
		int	10h			; invoke BIOS
		jmp	.Loop1			; Repeat until null terminator found
Puts16Done:
		popa				; restore registers
		ret				; we are done, so return
		

 
%endif ;__STDIO_INC