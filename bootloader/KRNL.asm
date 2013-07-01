org	0x100000			; Kernel starts at 1 MB
bits	32				; 32 bit code
jmp	Stage3				; jump to entry point
%include "video.asm"

msg db  0x0A, 0x0A, "              LevOS"
    db  0x0A, 0x0A, "          Kernel Online!", 0x0A, 0

Stage3:
	mov	ax, 0x10		; set data segments to data selector (0x10)
	mov	ds, ax
	mov	ss, ax
	mov	es, ax
	mov	esp, 90000h		; stack begins from 90000h

	call	ClrScr
	mov	ebx, msg
	call	Puts

	cli
	hlt



