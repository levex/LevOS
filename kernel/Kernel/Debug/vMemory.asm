; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\vMemory.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	?pd@@3PAIA					; pd
PUBLIC	?last_page@@3PAIA				; last_page
_BSS	SEGMENT
?pd@@3PAIA DD	01H DUP (?)				; pd
?last_page@@3PAIA DD 01H DUP (?)			; last_page
_BSS	ENDS
PUBLIC	?vm_setup@@YA_NPAX@Z				; vm_setup
; Function compile flags: /Ogtpy
; File c:\dev\levos\kernel\kernel\vmemory.cpp
;	COMDAT ?vm_setup@@YA_NPAX@Z
_TEXT	SEGMENT
_pagedirectory$ = 8					; size = 4
?vm_setup@@YA_NPAX@Z PROC				; vm_setup, COMDAT

; 9    : 	pd = (unsigned int*)pagedirectory;

	mov	ecx, DWORD PTR _pagedirectory$[esp-4]
	mov	DWORD PTR ?pd@@3PAIA, ecx		; pd
	xor	eax, eax
$LN3@vm_setup:

; 10   : 	int i = 0;
; 11   : 	for(i = 0; i < 1024; i++)
; 12   : 	{
; 13   : 		//attribute: supervisor level, read/write, not present.
; 14   : 		pd[i] = 0 | 2; 

	mov	edx, DWORD PTR ?pd@@3PAIA		; pd
	mov	DWORD PTR [eax+edx], 2
	add	eax, 4
	cmp	eax, 4096				; 00001000H
	jl	SHORT $LN3@vm_setup

; 15   : 	}
; 16   : 	return (pd == pagedirectory)?true:false;

	cmp	DWORD PTR ?pd@@3PAIA, ecx		; pd
	sete	al

; 17   : }

	ret	0
?vm_setup@@YA_NPAX@Z ENDP				; vm_setup
_TEXT	ENDS
PUBLIC	?vm_map_virt_to_phys@@YAXHH@Z			; vm_map_virt_to_phys
; Function compile flags: /Ogtpy
;	COMDAT ?vm_map_virt_to_phys@@YAXHH@Z
_TEXT	SEGMENT
_virtTableId$ = 8					; size = 4
_physLoc$ = 12						; size = 4
?vm_map_virt_to_phys@@YAXHH@Z PROC			; vm_map_virt_to_phys, COMDAT

; 20   : 	int i;
; 21   : 	for(i = 0; i < 1024; i++)

	mov	ecx, DWORD PTR _physLoc$[esp-4]
	xor	eax, eax
	push	esi
	npad	9
$LL3@vm_map_vir:

; 22   : 	{
; 23   : 		last_page[i] = physLoc | 3; // attributes: supervisor level, read/write, present.

	mov	esi, DWORD PTR ?last_page@@3PAIA	; last_page
	mov	edx, ecx
	or	edx, 3
	mov	DWORD PTR [eax+esi], edx
	add	eax, 4

; 24   : 		physLoc = physLoc + 4096; //advance the address to the next page boundary

	add	ecx, 4096				; 00001000H
	cmp	eax, 4096				; 00001000H
	jl	SHORT $LL3@vm_map_vir

; 25   : 	}
; 26   : 	pd[virtTableId] = (unsigned int)last_page|3;

	mov	ecx, DWORD PTR ?last_page@@3PAIA	; last_page
	mov	eax, DWORD PTR _virtTableId$[esp]
	mov	edx, DWORD PTR ?pd@@3PAIA		; pd
	or	ecx, 3
	mov	DWORD PTR [edx+eax*4], ecx

; 27   : 	pd[virtTableId] |= 3;

	mov	ecx, DWORD PTR ?pd@@3PAIA		; pd
	or	DWORD PTR [ecx+eax*4], 3

; 28   : 	last_page = (unsigned int*)(((unsigned int)last_page)+(4*1024));

	add	DWORD PTR ?last_page@@3PAIA, 4096	; last_page, 00001000H
	pop	esi

; 29   : }

	ret	0
?vm_map_virt_to_phys@@YAXHH@Z ENDP			; vm_map_virt_to_phys
_TEXT	ENDS
PUBLIC	?vm_transform@@YAHH@Z				; vm_transform
; Function compile flags: /Ogtpy
;	COMDAT ?vm_transform@@YAHH@Z
_TEXT	SEGMENT
_addr$ = 8						; size = 4
?vm_transform@@YAHH@Z PROC				; vm_transform, COMDAT

; 33   : 	return addr - 0xC0000000 + 0x100000;

	mov	eax, DWORD PTR _addr$[esp-4]
	add	eax, 1074790400				; 40100000H

; 34   : }

	ret	0
?vm_transform@@YAHH@Z ENDP				; vm_transform
_TEXT	ENDS
PUBLIC	?vm_enable_paging@@YA_NXZ			; vm_enable_paging
; Function compile flags: /Ogtpy
;	COMDAT ?vm_enable_paging@@YA_NXZ
_TEXT	SEGMENT
?vm_enable_paging@@YA_NXZ PROC				; vm_enable_paging, COMDAT

; 38   : 	_asm {
; 39   : 		mov eax, [pd]

	mov	eax, DWORD PTR ?pd@@3PAIA		; pd

; 40   : 		mov cr3, eax

	mov	cr3, eax

; 41   : 
; 42   : 		mov eax, cr0

	mov	eax, cr0

; 43   : 		or eax, 0x80000000

	or	eax, -2147483648			; 80000000H

; 44   : 		mov cr0, eax

	mov	cr0, eax

; 45   : 	}
; 46   : 	return true;

	mov	al, 1

; 47   : }

	ret	0
?vm_enable_paging@@YA_NXZ ENDP				; vm_enable_paging
_TEXT	ENDS
END
