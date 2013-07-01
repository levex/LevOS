; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\IDT.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

_DATA	SEGMENT
__idt	DD	0ffffffffH
_DATA	ENDS
_BSS	SEGMENT
__idtr	DF	01H DUP (?)
; Function compile flags: /Ogtpy
; File c:\dev\levos\kernel\kernel\idt.cpp
_BSS	ENDS
;	COMDAT ?idt_install@@YAXXZ
_TEXT	SEGMENT
?idt_install@@YAXXZ PROC				; idt_install, COMDAT

; 38   : #ifdef _MSC_VER
; 39   : 	_asm lidt [_idtr]

	lidt	FWORD PTR __idtr

; 40   : #endif
; 41   : }

	ret	0
?idt_install@@YAXXZ ENDP				; idt_install
_TEXT	ENDS
PUBLIC	?geninterrupt@@YAXH@Z				; geninterrupt
; Function compile flags: /Odtpy
;	COMDAT ?geninterrupt@@YAXH@Z
_TEXT	SEGMENT
_n$ = 8							; size = 4
?geninterrupt@@YAXH@Z PROC				; geninterrupt, COMDAT

; 50   : void geninterrupt (int n) {

	push	ebp
	mov	ebp, esp

; 51   : #ifdef _MSC_VER
; 52   : 	_asm {
; 53   : 		mov al, byte ptr [n]

	mov	al, BYTE PTR _n$[ebp]

; 54   : 		mov byte ptr [genint+1], al

	mov	OFFSET $genint$2678+1, al

; 55   : 		jmp genint

	jmp	SHORT $genint$2678
$genint$2678:

; 56   : 	genint:
; 57   : 		int 0	// above code modifies the 0 to int number to generate

	int	0

; 58   : 	}
; 59   : #endif
; 60   : }

	pop	ebp
	ret	0
?geninterrupt@@YAXH@Z ENDP				; geninterrupt
_TEXT	ENDS
PUBLIC	??_C@_0BP@OOOIHOGD@?6Unhandled?5Exception?5?$CIhalted?$CJ?6?$AA@ ; `string'
EXTRN	?DebugPrintf@@YAHPBDZZ:PROC			; DebugPrintf
;	COMDAT ??_C@_0BP@OOOIHOGD@?6Unhandled?5Exception?5?$CIhalted?$CJ?6?$AA@
CONST	SEGMENT
??_C@_0BP@OOOIHOGD@?6Unhandled?5Exception?5?$CIhalted?$CJ?6?$AA@ DB 0aH, 'U'
	DB	'nhandled Exception (halted)', 0aH, 00H	; `string'
; Function compile flags: /Ogtpy
CONST	ENDS
;	COMDAT ?i86_default_handler@@YAXXZ
_TEXT	SEGMENT
?i86_default_handler@@YAXXZ PROC			; i86_default_handler, COMDAT

; 65   : 
; 66   : 	DebugPrintf ("\nUnhandled Exception (halted)\n");

	push	OFFSET ??_C@_0BP@OOOIHOGD@?6Unhandled?5Exception?5?$CIhalted?$CJ?6?$AA@
	call	?DebugPrintf@@YAHPBDZZ			; DebugPrintf
	add	esp, 4
	npad	3
$LL2@i86_defaul:

; 67   : 	for(;;);

	jmp	SHORT $LL2@i86_defaul
?i86_default_handler@@YAXXZ ENDP			; i86_default_handler
_TEXT	ENDS
PUBLIC	?i86_get_ir@@YAPAUidt_descriptor@@I@Z		; i86_get_ir
; Function compile flags: /Ogtpy
;	COMDAT ?i86_get_ir@@YAPAUidt_descriptor@@I@Z
_TEXT	SEGMENT
_i$ = 8							; size = 4
?i86_get_ir@@YAPAUidt_descriptor@@I@Z PROC		; i86_get_ir, COMDAT

; 72   : 
; 73   : 	if (i>I86_MAX_INTERRUPTS)

	mov	eax, DWORD PTR _i$[esp-4]
	cmp	eax, 256				; 00000100H
	jbe	SHORT $LN1@i86_get_ir

; 74   : 		return 0;

	xor	eax, eax

; 77   : }

	ret	0
$LN1@i86_get_ir:

; 75   : 
; 76   : 	return &_idt[i];

	mov	ecx, DWORD PTR __idt
	lea	eax, DWORD PTR [ecx+eax*8]

; 77   : }

	ret	0
?i86_get_ir@@YAPAUidt_descriptor@@I@Z ENDP		; i86_get_ir
_TEXT	ENDS
PUBLIC	?i86_install_ir@@YAHIGGP6AXXZ@Z			; i86_install_ir
; Function compile flags: /Ogtpy
;	COMDAT ?i86_install_ir@@YAHIGGP6AXXZ@Z
_TEXT	SEGMENT
_i$ = 8							; size = 4
_flags$ = 12						; size = 2
_sel$ = 16						; size = 2
_irq$ = 20						; size = 4
?i86_install_ir@@YAHIGGP6AXXZ@Z PROC			; i86_install_ir, COMDAT

; 82   : 
; 83   : 	if (i>I86_MAX_INTERRUPTS)

	mov	edx, DWORD PTR _i$[esp-4]

; 84   : 		return 0;

	xor	eax, eax
	cmp	edx, 256				; 00000100H
	ja	SHORT $LN3@i86_instal

; 85   : 
; 86   : 	if (!irq)

	push	esi
	mov	esi, DWORD PTR _irq$[esp]
	test	esi, esi

; 87   : 		return 0;

	je	SHORT $LN5@i86_instal

; 88   : 
; 89   : 	// get base address of interrupt handler
; 90   : 	uint64_t		uiBase = (uint64_t)&(*irq);
; 91   : 
; 92   : 	// store base address into idt
; 93   : 	_idt[i].baseLo		=	uint16_t(uiBase & 0xffff);

	mov	ecx, DWORD PTR __idt
	mov	WORD PTR [ecx+edx*8], si

; 94   : 	_idt[i].baseHi		=	uint16_t((uiBase >> 16) & 0xffff);

	shrd	esi, eax, 16
	shr	eax, 16					; 00000010H

; 95   : 	_idt[i].reserved	=	0;
; 96   : 	_idt[i].flags		=	unsigned char(flags);

	mov	al, BYTE PTR _flags$[esp]
	mov	BYTE PTR [ecx+edx*8+5], al

; 97   : 	_idt[i].sel			=	sel;

	mov	ax, WORD PTR _sel$[esp]
	mov	WORD PTR [ecx+edx*8+2], ax
	mov	WORD PTR [ecx+edx*8+6], si
	mov	BYTE PTR [ecx+edx*8+4], 0

; 98   : 	//DebugPrintf("IR registered to 0x%X\n", i);
; 99   : 	return	0;

	xor	eax, eax
$LN5@i86_instal:
	pop	esi
$LN3@i86_instal:

; 100  : }

	ret	0
?i86_install_ir@@YAHIGGP6AXXZ@Z ENDP			; i86_install_ir
_TEXT	ENDS
PUBLIC	?i86_idt_initialize@@YAHG@Z			; i86_idt_initialize
EXTRN	?memset@@YAPAXPAXDI@Z:PROC			; memset
; Function compile flags: /Ogtpy
;	COMDAT ?i86_idt_initialize@@YAHG@Z
_TEXT	SEGMENT
_codeSel$ = 8						; size = 2
?i86_idt_initialize@@YAHG@Z PROC			; i86_idt_initialize, COMDAT

; 104  : int i86_idt_initialize (uint16_t codeSel) {

	push	esi
	push	edi

; 105  : 
; 106  : 	// set up idtr for processor
; 107  : 	_idtr.limit = sizeof (struct idt_descriptor) * I86_MAX_INTERRUPTS -1;

	mov	eax, 2047				; 000007ffH

; 108  : 	_idtr.base	= (uint32_t)&_idt[0];
; 109  : 
; 110  : 	// null out the idt
; 111  : 	memset ((void*)&_idt[0], 0, sizeof (idt_descriptor) * I86_MAX_INTERRUPTS-1);

	push	2047					; 000007ffH
	mov	WORD PTR __idtr, ax
	mov	eax, DWORD PTR __idt
	push	0
	push	eax
	mov	DWORD PTR __idtr+2, eax
	call	?memset@@YAPAXPAXDI@Z			; memset
	mov	eax, DWORD PTR __idt
	mov	di, WORD PTR _codeSel$[esp+16]

; 112  : 
; 113  : 	// register default handlers
; 114  : 	for (int i=0; i<I86_MAX_INTERRUPTS; i++)

	xor	esi, esi
	add	esp, 12					; 0000000cH
	add	eax, 4

; 115  : 		i86_install_ir (i, I86_IDT_DESC_PRESENT | I86_IDT_DESC_BIT32,
; 116  : 			codeSel, (I86_IRQ_HANDLER)i86_default_handler);

	cmp	esi, 256				; 00000100H
$LN14@i86_idt_in:
	ja	SHORT $LN2@i86_idt_in
	mov	ecx, OFFSET ?i86_default_handler@@YAXXZ	; i86_default_handler
	test	ecx, ecx
	je	SHORT $LN2@i86_idt_in
	mov	edx, OFFSET ?i86_default_handler@@YAXXZ	; i86_default_handler
	xor	ecx, ecx
	mov	WORD PTR [eax-4], dx
	shrd	edx, ecx, 16
	shr	ecx, 16					; 00000010H
	mov	WORD PTR [eax+2], dx
	mov	WORD PTR [eax], 36352			; 00008e00H
	mov	WORD PTR [eax-2], di
$LN2@i86_idt_in:

; 112  : 
; 113  : 	// register default handlers
; 114  : 	for (int i=0; i<I86_MAX_INTERRUPTS; i++)

	inc	esi
	add	eax, 8
	cmp	esi, 256				; 00000100H
	jl	SHORT $LN14@i86_idt_in

; 117  : 
; 118  : 	// install our idt
; 119  : 	idt_install ();

	lidt	FWORD PTR __idtr
	pop	edi

; 120  : 
; 121  : 	return 0;

	xor	eax, eax
	pop	esi

; 122  : }

	ret	0
?i86_idt_initialize@@YAHG@Z ENDP			; i86_idt_initialize
_TEXT	ENDS
PUBLIC	?i86_setup@@YA_NH@Z				; i86_setup
; Function compile flags: /Ogtpy
;	COMDAT ?i86_setup@@YA_NH@Z
_TEXT	SEGMENT
_loc$ = 8						; size = 4
?i86_setup@@YA_NH@Z PROC				; i86_setup, COMDAT

; 44   : {

	push	esi

; 45   : 	_idt = (idt_descriptor*)loc;

	mov	esi, DWORD PTR _loc$[esp]

; 46   : 	i86_idt_initialize(0x8);

	push	8
	mov	DWORD PTR __idt, esi
	call	?i86_idt_initialize@@YAHG@Z		; i86_idt_initialize
	add	esp, 4

; 47   : 	return ((int)_idt == loc);

	xor	eax, eax
	cmp	DWORD PTR __idt, esi
	pop	esi
	sete	al

; 48   : }

	ret	0
?i86_setup@@YA_NH@Z ENDP				; i86_setup
_TEXT	ENDS
END
