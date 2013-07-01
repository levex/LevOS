[org 0x7C00]
[bits 32]
	jmp 0x18:Entry16
	
bits 16

idt_real:
	dw 0x3ff		; 256 entries, 4b each = 1K
	dd 0			; Real Mode IVT @ 0x0000
 
savcr0:
	dd 0			; Storage location for pmode CR0.
 
Entry16:
        ; We are already in 16-bit mode here!
	xchg bx, bx
	cli			; Disable interrupts.
 
	; Need 16-bit Protected Mode GDT entries!
	mov eax, 0x20	; 16-bit Protected Mode data selector.
	mov ds, eax
	mov es, eax
	mov fs, eax
	mov gs, eax
 
	; Disable paging (we need everything to be 1:1 mapped).
	mov eax, cr0
	mov [savcr0], eax	; save pmode CR0
	and eax, 0x7FFFFFFe	; Disable paging bit & enable 16-bit pmode.
	mov cr0, eax
 
	jmp 0:GoRMode		; Perform Far jump to set CS.
 
GoRMode:
	mov     ax, 0x0000				; set the stack
    mov     ss, ax
    mov     sp, 0xFFFF
	mov ax, 0		; Reset segment registers to 0.
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	lidt [idt_real]
	sti			; Restore interrupts -- be careful, unhandled int's will kill it.
	
	xor ax, ax
	;int 0x16
	;JMP far [0x40]
	
halt:
	jmp halt
	
	