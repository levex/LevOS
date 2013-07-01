; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\DMA.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	?dma_mask_channel@@YAXE@Z			; dma_mask_channel
EXTRN	?outport@@YAXGE@Z:PROC				; outport
; Function compile flags: /Ogtpy
; File c:\dev\levos\kernel\kernel\dma.cpp
;	COMDAT ?dma_mask_channel@@YAXE@Z
_TEXT	SEGMENT
_channel$ = 8						; size = 1
?dma_mask_channel@@YAXE@Z PROC				; dma_mask_channel, COMDAT

; 6    : 
; 7    : 	if (channel <= 4)

	mov	al, BYTE PTR _channel$[esp-4]

; 8    : 		outport(DMA0_CHANMASK_REG, (1 << (channel-1)));

	movzx	ecx, al
	cmp	al, 4
	ja	SHORT $LN2@dma_mask_c
	dec	ecx
	mov	al, 1
	shl	al, cl
	movzx	ecx, al
	push	ecx
	push	10					; 0000000aH

; 9    : 	else
; 10   : 		outport(DMA1_CHANMASK_REG, (1 << (channel-5)));

	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 11   : }

	ret	0
$LN2@dma_mask_c:

; 9    : 	else
; 10   : 		outport(DMA1_CHANMASK_REG, (1 << (channel-5)));

	sub	ecx, 5
	mov	dl, 1
	shl	dl, cl
	movzx	eax, dl
	push	eax
	push	212					; 000000d4H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 11   : }

	ret	0
?dma_mask_channel@@YAXE@Z ENDP				; dma_mask_channel
_TEXT	ENDS
PUBLIC	?dma_unmask_channel@@YAXE@Z			; dma_unmask_channel
; Function compile flags: /Ogtpy
;	COMDAT ?dma_unmask_channel@@YAXE@Z
_TEXT	SEGMENT
_channel$ = 8						; size = 1
?dma_unmask_channel@@YAXE@Z PROC			; dma_unmask_channel, COMDAT

; 15   : 
; 16   : 	if (channel <= 4)

	mov	eax, DWORD PTR _channel$[esp-4]

; 17   : 		outport(DMA0_CHANMASK_REG, channel);

	push	eax
	cmp	al, 4
	ja	SHORT $LN2@dma_unmask
	push	10					; 0000000aH

; 18   : 	else
; 19   : 		outport(DMA1_CHANMASK_REG, channel);

	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 20   : }

	ret	0
$LN2@dma_unmask:

; 18   : 	else
; 19   : 		outport(DMA1_CHANMASK_REG, channel);

	push	212					; 000000d4H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 20   : }

	ret	0
?dma_unmask_channel@@YAXE@Z ENDP			; dma_unmask_channel
_TEXT	ENDS
PUBLIC	?dma_unmask_all@@YAXH@Z				; dma_unmask_all
; Function compile flags: /Ogtpy
;	COMDAT ?dma_unmask_all@@YAXH@Z
_TEXT	SEGMENT
_dma$ = 8						; size = 4
?dma_unmask_all@@YAXH@Z PROC				; dma_unmask_all, COMDAT

; 24   : 
; 25   : 	// it doesnt matter what is written to this register
; 26   : 	outport(DMA1_UNMASK_ALL_REG, 0xff);

	push	255					; 000000ffH
	push	220					; 000000dcH
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 27   : }

	ret	0
?dma_unmask_all@@YAXH@Z ENDP				; dma_unmask_all
_TEXT	ENDS
PUBLIC	?dma_reset@@YAXH@Z				; dma_reset
; Function compile flags: /Ogtpy
;	COMDAT ?dma_reset@@YAXH@Z
_TEXT	SEGMENT
_dma$ = 8						; size = 4
?dma_reset@@YAXH@Z PROC					; dma_reset, COMDAT

; 31   : 
; 32   : 	// it doesnt matter what is written to this register
; 33   : 	outport(DMA0_TEMP_REG, 0xff);

	push	255					; 000000ffH
	push	13					; 0000000dH
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 34   : }

	ret	0
?dma_reset@@YAXH@Z ENDP					; dma_reset
_TEXT	ENDS
PUBLIC	?dma_reset_flipflop@@YAXH@Z			; dma_reset_flipflop
; Function compile flags: /Ogtpy
;	COMDAT ?dma_reset_flipflop@@YAXH@Z
_TEXT	SEGMENT
_dma$ = 8						; size = 4
?dma_reset_flipflop@@YAXH@Z PROC			; dma_reset_flipflop, COMDAT

; 38   : 
; 39   : 	if (dma < 2)

	mov	eax, DWORD PTR _dma$[esp-4]
	cmp	eax, 2
	jl	SHORT $LN2@dma_reset_

; 40   : 		return;
; 41   : 
; 42   : 	// it doesnt matter what is written to this register
; 43   : 	outport( (dma==0) ? DMA0_CLEARBYTE_FLIPFLOP_REG : DMA1_CLEARBYTE_FLIPFLOP_REG, 0xff);

	neg	eax
	sbb	eax, eax
	and	eax, 204				; 000000ccH
	add	eax, 12					; 0000000cH
	push	255					; 000000ffH
	push	eax
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8
$LN2@dma_reset_:

; 44   : }

	ret	0
?dma_reset_flipflop@@YAXH@Z ENDP			; dma_reset_flipflop
_TEXT	ENDS
PUBLIC	?dma_set_address@@YAXEEE@Z			; dma_set_address
; Function compile flags: /Ogtpy
;	COMDAT ?dma_set_address@@YAXEEE@Z
_TEXT	SEGMENT
_channel$ = 8						; size = 1
_low$ = 12						; size = 1
_high$ = 16						; size = 1
?dma_set_address@@YAXEEE@Z PROC				; dma_set_address, COMDAT

; 48   : 
; 49   : 	if ( channel > 8 )

	mov	al, BYTE PTR _channel$[esp-4]
	cmp	al, 8
	ja	SHORT $LN12@dma_set_ad

; 50   : 		return;
; 51   : 
; 52   : 	unsigned short port = 0;
; 53   : 	switch ( channel ) {

	movzx	eax, al
	push	esi
	xor	esi, esi
	cmp	eax, 7
	ja	SHORT $LN9@dma_set_ad
	jmp	DWORD PTR $LN14@dma_set_ad[eax*4]
$LN8@dma_set_ad:

; 54   : 
; 55   : 		case 0: {port = DMA0_CHAN0_ADDR_REG; break;}

	xor	esi, esi
	jmp	SHORT $LN9@dma_set_ad
$LN7@dma_set_ad:

; 56   : 		case 1: {port = DMA0_CHAN1_ADDR_REG; break;}

	mov	esi, 2
	jmp	SHORT $LN9@dma_set_ad
$LN6@dma_set_ad:

; 57   : 		case 2: {port = DMA0_CHAN2_ADDR_REG; break;}

	mov	esi, 4
	jmp	SHORT $LN9@dma_set_ad
$LN5@dma_set_ad:

; 58   : 		case 3: {port = DMA0_CHAN3_ADDR_REG; break;}

	mov	esi, 6
	jmp	SHORT $LN9@dma_set_ad
$LN4@dma_set_ad:

; 59   : 		case 4: {port = DMA1_CHAN4_ADDR_REG; break;}

	mov	esi, 192				; 000000c0H
	jmp	SHORT $LN9@dma_set_ad
$LN3@dma_set_ad:

; 60   : 		case 5: {port = DMA1_CHAN5_ADDR_REG; break;}

	mov	esi, 196				; 000000c4H
	jmp	SHORT $LN9@dma_set_ad
$LN2@dma_set_ad:

; 61   : 		case 6: {port = DMA1_CHAN6_ADDR_REG; break;}

	mov	esi, 200				; 000000c8H
	jmp	SHORT $LN9@dma_set_ad
$LN1@dma_set_ad:

; 62   : 		case 7: {port = DMA1_CHAN7_ADDR_REG; break;}

	mov	esi, 204				; 000000ccH
$LN9@dma_set_ad:

; 63   : 	}
; 64   : 
; 65   : 	outport(port, low);

	mov	eax, DWORD PTR _low$[esp]
	push	eax
	push	esi
	call	?outport@@YAXGE@Z			; outport

; 66   : 	outport(port, high);

	mov	ecx, DWORD PTR _high$[esp+8]
	push	ecx
	push	esi
	call	?outport@@YAXGE@Z			; outport
	add	esp, 16					; 00000010H
	pop	esi
$LN12@dma_set_ad:

; 67   : }

	ret	0
$LN14@dma_set_ad:
	DD	$LN8@dma_set_ad
	DD	$LN7@dma_set_ad
	DD	$LN6@dma_set_ad
	DD	$LN5@dma_set_ad
	DD	$LN4@dma_set_ad
	DD	$LN3@dma_set_ad
	DD	$LN2@dma_set_ad
	DD	$LN1@dma_set_ad
?dma_set_address@@YAXEEE@Z ENDP				; dma_set_address
_TEXT	ENDS
PUBLIC	?dma_set_count@@YAXEEE@Z			; dma_set_count
; Function compile flags: /Ogtpy
;	COMDAT ?dma_set_count@@YAXEEE@Z
_TEXT	SEGMENT
_channel$ = 8						; size = 1
_low$ = 12						; size = 1
_high$ = 16						; size = 1
?dma_set_count@@YAXEEE@Z PROC				; dma_set_count, COMDAT

; 71   : 
; 72   : 	if ( channel > 8 )

	mov	al, BYTE PTR _channel$[esp-4]
	cmp	al, 8
	ja	SHORT $LN12@dma_set_co

; 73   : 		return;
; 74   : 
; 75   : 	unsigned short port = 0;
; 76   : 	switch ( channel ) {

	movzx	eax, al
	push	esi
	xor	esi, esi
	cmp	eax, 7
	ja	SHORT $LN9@dma_set_co
	jmp	DWORD PTR $LN14@dma_set_co[eax*4]
$LN8@dma_set_co:

; 77   : 
; 78   : 		case 0: {port = DMA0_CHAN0_COUNT_REG; break;}

	mov	esi, 1
	jmp	SHORT $LN9@dma_set_co
$LN7@dma_set_co:

; 79   : 		case 1: {port = DMA0_CHAN1_COUNT_REG; break;}

	mov	esi, 3
	jmp	SHORT $LN9@dma_set_co
$LN6@dma_set_co:

; 80   : 		case 2: {port = DMA0_CHAN2_COUNT_REG; break;}

	mov	esi, 5
	jmp	SHORT $LN9@dma_set_co
$LN5@dma_set_co:

; 81   : 		case 3: {port = DMA0_CHAN3_COUNT_REG; break;}

	mov	esi, 7
	jmp	SHORT $LN9@dma_set_co
$LN4@dma_set_co:

; 82   : 		case 4: {port = DMA1_CHAN4_COUNT_REG; break;}

	mov	esi, 194				; 000000c2H
	jmp	SHORT $LN9@dma_set_co
$LN3@dma_set_co:

; 83   : 		case 5: {port = DMA1_CHAN5_COUNT_REG; break;}

	mov	esi, 198				; 000000c6H
	jmp	SHORT $LN9@dma_set_co
$LN2@dma_set_co:

; 84   : 		case 6: {port = DMA1_CHAN6_COUNT_REG; break;}

	mov	esi, 202				; 000000caH
	jmp	SHORT $LN9@dma_set_co
$LN1@dma_set_co:

; 85   : 		case 7: {port = DMA1_CHAN7_COUNT_REG; break;}

	mov	esi, 206				; 000000ceH
$LN9@dma_set_co:

; 86   : 	}
; 87   : 
; 88   : 	outport(port, low);

	mov	eax, DWORD PTR _low$[esp]
	push	eax
	push	esi
	call	?outport@@YAXGE@Z			; outport

; 89   : 	outport(port, high);

	mov	ecx, DWORD PTR _high$[esp+8]
	push	ecx
	push	esi
	call	?outport@@YAXGE@Z			; outport
	add	esp, 16					; 00000010H
	pop	esi
$LN12@dma_set_co:

; 90   : }

	ret	0
	npad	1
$LN14@dma_set_co:
	DD	$LN8@dma_set_co
	DD	$LN7@dma_set_co
	DD	$LN6@dma_set_co
	DD	$LN5@dma_set_co
	DD	$LN4@dma_set_co
	DD	$LN3@dma_set_co
	DD	$LN2@dma_set_co
	DD	$LN1@dma_set_co
?dma_set_count@@YAXEEE@Z ENDP				; dma_set_count
_TEXT	ENDS
PUBLIC	?dma_set_mode@@YAXEE@Z				; dma_set_mode
; Function compile flags: /Ogtpy
;	COMDAT ?dma_set_mode@@YAXEE@Z
_TEXT	SEGMENT
_channel$ = 8						; size = 1
_mode$ = 12						; size = 1
?dma_set_mode@@YAXEE@Z PROC				; dma_set_mode, COMDAT

; 93   : 
; 94   : 	int dma = (channel < 4) ? 0 : 1;

	mov	cl, BYTE PTR _channel$[esp-4]

; 95   : 	int chan = (dma==0) ? channel : channel-4;

	movzx	eax, cl
	push	ebx
	mov	ebx, eax
	cmp	cl, 4
	jb	SHORT $LN14@dma_set_mo
	lea	ebx, DWORD PTR [eax-4]

; 96   : 
; 97   : 	dma_mask_channel (channel);

	ja	SHORT $LN6@dma_set_mo
$LN14@dma_set_mo:
	lea	ecx, DWORD PTR [eax-1]
	mov	al, 1
	shl	al, cl
	movzx	ecx, al
	push	ecx
	push	10					; 0000000aH
	jmp	SHORT $LN15@dma_set_mo
$LN6@dma_set_mo:
	lea	ecx, DWORD PTR [eax-5]
	mov	dl, 1
	shl	dl, cl
	movzx	eax, dl
	push	eax
	push	212					; 000000d4H
$LN15@dma_set_mo:
	call	?outport@@YAXGE@Z			; outport

; 98   : 	outport ( (channel < 4) ? (DMA0_MODE_REG) : DMA1_MODE_REG, chan | (mode) );

	or	bl, BYTE PTR _mode$[esp+8]
	add	esp, 8
	cmp	BYTE PTR _channel$[esp], 4
	movzx	ecx, bl
	sbb	edx, edx
	and	edx, -203				; ffffff35H
	push	ecx
	add	edx, 214				; 000000d6H
	push	edx
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8
	pop	ebx

; 99   : 	dma_unmask_all ( dma );

	mov	DWORD PTR _mode$[esp-4], 255		; 000000ffH
	mov	DWORD PTR _channel$[esp-4], 220		; 000000dcH
	jmp	?outport@@YAXGE@Z			; outport
?dma_set_mode@@YAXEE@Z ENDP				; dma_set_mode
_TEXT	ENDS
PUBLIC	?dma_set_read@@YAXE@Z				; dma_set_read
; Function compile flags: /Ogtpy
;	COMDAT ?dma_set_read@@YAXE@Z
_TEXT	SEGMENT
_channel$ = 8						; size = 1
?dma_set_read@@YAXE@Z PROC				; dma_set_read, COMDAT

; 104  : 
; 105  : 	dma_set_mode (channel,	DMA_MODE_READ_TRANSFER | DMA_MODE_TRANSFER_SINGLE);

	mov	eax, DWORD PTR _channel$[esp-4]
	push	68					; 00000044H
	push	eax
	call	?dma_set_mode@@YAXEE@Z			; dma_set_mode
	add	esp, 8

; 106  : }

	ret	0
?dma_set_read@@YAXE@Z ENDP				; dma_set_read
_TEXT	ENDS
PUBLIC	?dma_set_write@@YAXE@Z				; dma_set_write
; Function compile flags: /Ogtpy
;	COMDAT ?dma_set_write@@YAXE@Z
_TEXT	SEGMENT
_channel$ = 8						; size = 1
?dma_set_write@@YAXE@Z PROC				; dma_set_write, COMDAT

; 110  : 
; 111  : 	dma_set_mode (channel,
; 112  : 		DMA_MODE_WRITE_TRANSFER | DMA_MODE_TRANSFER_SINGLE);

	mov	eax, DWORD PTR _channel$[esp-4]
	push	72					; 00000048H
	push	eax
	call	?dma_set_mode@@YAXEE@Z			; dma_set_mode
	add	esp, 8

; 113  : }

	ret	0
?dma_set_write@@YAXE@Z ENDP				; dma_set_write
_TEXT	ENDS
PUBLIC	?dma_set_external_page_register@@YAXEE@Z	; dma_set_external_page_register
; Function compile flags: /Ogtpy
;	COMDAT ?dma_set_external_page_register@@YAXEE@Z
_TEXT	SEGMENT
_reg$ = 8						; size = 1
_val$ = 12						; size = 1
?dma_set_external_page_register@@YAXEE@Z PROC		; dma_set_external_page_register, COMDAT

; 117  : 
; 118  : 	if (reg > 14)

	mov	cl, BYTE PTR _reg$[esp-4]
	cmp	cl, 14					; 0000000eH
	ja	SHORT $LN11@dma_set_ex

; 119  : 		return;
; 120  : 
; 121  : 	unsigned short port = 0;
; 122  : 	switch ( reg ) {

	movzx	ecx, cl
	dec	ecx
	xor	eax, eax
	cmp	ecx, 6
	ja	SHORT $LN8@dma_set_ex
	jmp	DWORD PTR $LN14@dma_set_ex[ecx*4]
$LN7@dma_set_ex:

; 123  : 
; 124  : 		case 1: {port = DMA_PAGE_CHAN1_ADDRBYTE2; break;}

	mov	eax, 131				; 00000083H

; 131  : 	}
; 132  : 
; 133  : 	outport(port, val);

	mov	DWORD PTR _reg$[esp-4], eax
	jmp	?outport@@YAXGE@Z			; outport
$LN6@dma_set_ex:

; 125  : 		case 2: {port = DMA_PAGE_CHAN2_ADDRBYTE2; break;}

	mov	eax, 129				; 00000081H

; 131  : 	}
; 132  : 
; 133  : 	outport(port, val);

	mov	DWORD PTR _reg$[esp-4], eax
	jmp	?outport@@YAXGE@Z			; outport
$LN5@dma_set_ex:

; 126  : 		case 3: {port = DMA_PAGE_CHAN3_ADDRBYTE2; break;}

	mov	eax, 130				; 00000082H

; 131  : 	}
; 132  : 
; 133  : 	outport(port, val);

	mov	DWORD PTR _reg$[esp-4], eax
	jmp	?outport@@YAXGE@Z			; outport
$LN3@dma_set_ex:

; 127  : 		case 4: {return;}// nothing should ever write to register 4
; 128  : 		case 5: {port = DMA_PAGE_CHAN5_ADDRBYTE2; break;}

	mov	eax, 137				; 00000089H

; 131  : 	}
; 132  : 
; 133  : 	outport(port, val);

	mov	DWORD PTR _reg$[esp-4], eax
	jmp	?outport@@YAXGE@Z			; outport
$LN2@dma_set_ex:

; 129  : 		case 6: {port = DMA_PAGE_CHAN6_ADDRBYTE2; break;}

	mov	eax, 135				; 00000087H

; 131  : 	}
; 132  : 
; 133  : 	outport(port, val);

	mov	DWORD PTR _reg$[esp-4], eax
	jmp	?outport@@YAXGE@Z			; outport
$LN1@dma_set_ex:

; 130  : 		case 7: {port = DMA_PAGE_CHAN7_ADDRBYTE2; break;}

	mov	eax, 136				; 00000088H
$LN8@dma_set_ex:

; 131  : 	}
; 132  : 
; 133  : 	outport(port, val);

	mov	DWORD PTR _reg$[esp-4], eax
	jmp	?outport@@YAXGE@Z			; outport
$LN11@dma_set_ex:

; 134  : }

	ret	0
$LN14@dma_set_ex:
	DD	$LN7@dma_set_ex
	DD	$LN6@dma_set_ex
	DD	$LN5@dma_set_ex
	DD	$LN11@dma_set_ex
	DD	$LN3@dma_set_ex
	DD	$LN2@dma_set_ex
	DD	$LN1@dma_set_ex
?dma_set_external_page_register@@YAXEE@Z ENDP		; dma_set_external_page_register
_TEXT	ENDS
END
