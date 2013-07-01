%ifndef __VIDEO_INC_
%define __VIDEO_INC_

bits 32

%define		VIDMEM	0xB8000			; video memory
%define		COLS	80			; width and height of screen
%define		LINES	25
%define		CHAR_ATTRIB 0x1F			; character attribute

_CurX db 0					; current x/y location
_CurY db 0

Putch:

	pusha				; save registers
	mov	edi, VIDMEM		; get pointer to video memory

	xor	eax, eax		; clear eax

	mov	ecx, COLS*2		; Mode 7 has 2 bytes per char, so its COLS*2 bytes per line
	mov	al, byte [_CurY]	; get y pos
	mul	ecx			; multiply y*COLS
	push	eax			; save eax--the multiplication

	mov	al, byte [_CurX]	; multiply _CurX by 2 because it is 2 bytes per char
	mov	cl, 2
	mul	cl
	pop	ecx			; pop y*COLS result
	add	eax, ecx
	xor	ecx, ecx
	add	edi, eax		; add it to the base address

	cmp	bl, 0x0A		; is it a newline character?
	je	.Row			; yep--go to next row
	mov	dl, bl			; Get character
	mov	dh, CHAR_ATTRIB		; the character attribute
	mov	word [edi], dx		; write to video display

	inc	byte [_CurX]		; go to next character
;	cmp	byte [_CurX], COLS		; are we at the end of the line?
;	je	.Row			; yep-go to next row
	jmp	.done			; nope, bail out
	
.Row:
	mov	byte [_CurX], 0		; go back to col 0
	inc	byte [_CurY]		; go to next row

.done:
	popa				; restore registers and return
	ret


Puts:

	pusha				; save registers
	push	ebx			; copy the string address
	pop	edi

.loop:

	mov	bl, byte [edi]		; get next character
	cmp	bl, 0			; is it 0 (Null terminator)?
	je	.done			; yep-bail out

	call	Putch			; Nope-print it out

	inc	edi			; go to next character
	jmp	.loop

.done:

	mov	bh, byte [_CurY]	; get current position
	mov	bl, byte [_CurX]
	call	MovCur			; update cursor

	popa				; restore registers, and return
	ret

bits 32

MovCur:

	pusha				; save registers

	xor	eax, eax
	mov	ecx, COLS
	mov	al, bh			; get y pos
	mul	ecx			; multiply y*COLS
	add	al, bl			; Now add x
	mov	ebx, eax

	mov	al, 0x0f
	mov	dx, 0x03D4
	out	dx, al

	mov	al, bl
	mov	dx, 0x03D5
	out	dx, al			; low byte

	xor	eax, eax

	mov	al, 0x0e
	mov	dx, 0x03D4
	out	dx, al

	mov	al, bh
	mov	dx, 0x03D5
	out	dx, al			; high byte

	popa
	ret
	
bits 32

ClrScr:

	pusha
	cld
	mov	edi, VIDMEM
	mov	cx, 2000
	mov	ah, CHAR_ATTRIB
	mov	al, ' '	
	rep	stosw

	mov	byte [_CurX], 0
	mov	byte [_CurY], 0
	popa
	ret

bits 32

GotoXY:
	pusha
	mov	[_CurX], al		; just set the current position
	mov	[_CurY], ah
	popa
	ret




%endif ;__VIDEO_INC_
