%ifndef __PAGING_INC_
%define __PAGING_INC_

bits 32

; page directory table
%define		PAGE_DIR			0x9B000
; 0th page table
%define		PAGE_TABLE_0		0x9D000
; 768th page table
%define		PAGE_TABLE_768		0x9E000
%define 	PAGE_TABLE_1		0x9F000
%define		PAGE_TABLE_2		0xA0000
%define		PAGE_TABLE_3		0xA1000
; each page table has 1024 entries
%define		PAGE_TABLE_ENTRIES	1024
; attributes (page is present;page is writable; supervisor mode)
%define		PRIV				3

EnablePaging:
	pusha										; save stack frame

	; mapping 0-4MB
	mov		eax, PAGE_TABLE_0					; first page table
	mov		ebx, 0x0 | PRIV						; starting physical address of page
	mov		ecx, PAGE_TABLE_ENTRIES				; for every page in table...
.loop:
	mov		dword [eax], ebx					; write the entry
	add		eax, 4								; go to next page entry in table (Each entry is 4 bytes)
	add		ebx, 4096							; go to next page address (Each page is 4Kb)
	loop	.loop								; go to next entry
	
	; pagetable 1
	
	; --- mappin 4-8MB
	
	mov eax, PAGE_TABLE_1 ; pagetable location
	mov ebx, 0x400000 | PRIV ; where it begins
	mov ecx, PAGE_TABLE_ENTRIES ; 1024 times...
.loop3:
	mov dword [eax], ebx ; EBX = page data
	add eax, 4 ;next page entry: bc 4bytes/page
	add ebx, 4096 ; next page address: bc 4KB/page
	loop .loop3 ; loop 1024 times...
	
	; --- mapping 8-12MB
	
	mov		eax, PAGE_TABLE_2				; first page table
	mov		ebx, 0x800000 | PRIV			; starting physical address of page
	mov		ecx, PAGE_TABLE_ENTRIES			; for every page in table...
.loop4:
	mov dword [eax], ebx ; EBX = page data
	add eax, 4 ;next page entry: bc 4bytes/page
	add ebx, 4096 ; next page address: bc 4KB/page
	loop .loop4 ; loop 1024 times...
	
	; --- mapping 12-16MB
	
	mov		eax, PAGE_TABLE_3				; first page table
	mov		ebx, 0xC00000 | PRIV			; starting physical address of page
	mov		ecx, PAGE_TABLE_ENTRIES			; for every page in table...
.loop5:
	mov dword [eax], ebx ; EBX = page data
	add eax, 4 ;next page entry: bc 4bytes/page
	add ebx, 4096 ; next page address: bc 4KB/page
	loop .loop5 ; loop 1024 times...
	
	; --- mappin 3GB-(3GB+4MB)
	
	mov		eax, PAGE_TABLE_768				; first page table
	mov		ebx, 0x100000 | PRIV			; starting physical address of page
	mov		ecx, PAGE_TABLE_ENTRIES			; for every page in table...
.loop2:
	mov		dword [eax], ebx				; write the entry
	add		eax, 4							; go to next page entry in table (Each entry is 4 bytes)
	add		ebx, 4096						; go to next page address (Each page is 4Kb)
	loop	.loop2							; go to next entry
	
	

	mov		eax, PAGE_TABLE_0 | PRIV			; 1st table is directory entry 0
	mov		dword [PAGE_DIR], eax
	
	mov eax, PAGE_TABLE_1 | PRIV
	mov dword [PAGE_DIR + (1*4)], eax
	
	mov eax, PAGE_TABLE_2 | PRIV
	mov dword [PAGE_DIR + (2*4)], eax
	
	mov eax, PAGE_TABLE_3 | PRIV
	mov dword [PAGE_DIR + (3*4)], eax

	mov		eax, PAGE_TABLE_768 | PRIV			; 768th entry in directory table
	mov		dword [PAGE_DIR+(768*4)], eax

	mov		eax, PAGE_DIR
	mov		cr3, eax

	mov		eax, cr0
	or		eax, 0x80000000
	mov		cr0, eax

	popa
	ret

%endif
