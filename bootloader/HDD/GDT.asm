%ifndef __GDT_INC
%define __GDT_INC
bits	16
InstallGDT:
 
	cli				; clear interrupts
	pusha				; save registers
	lgdt 	[toc]			; load GDT into GDTR
	;sti				; enable interrupts
	popa				; restore registers
	ret				; All done!
	
; GDT

gdt_data: 
	dd 0 				; null descriptor 0-31
	dd 0 				; 31-64
 
; gdt code:				; code descriptor
	dw 0FFFFh 			; LIMIT = FF FF [2 bytes]
	dw 0 				; BASE = 00 00 (2 bytes)    BASE is 3 byte long
	db 0 				; BASE += 00  (1 byte)
	db 10011010b 			; access  
			; access , R/W, direction, code/data, system/codeORdata, ring0;1;2;3? (2 bits),  loaded?
	db 11001111b 			; granularity 
	db 0 				; base high 
 
; gdt data:				; data descriptor
	dw 0FFFFh 			; limit low (Same as code)
	dw 0 				; base low
	db 0 				; base middle
	db 10010010b 			; access
	db 11001111b 			; granularity
	db 0				; base high
 
end_of_gdt:
toc: 
	dw end_of_gdt - gdt_data - 1 	; limit (Size of GDT)
	dd gdt_data 			; base of GDT
 
 
%endif ;__GDT_INC