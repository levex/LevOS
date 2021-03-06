; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\GFXApp\WindowManager.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	?initWindowManager@@YAXXZ			; initWindowManager
_BSS	SEGMENT
_wList	DD	010H DUP (?)
; Function compile flags: /Odtp /ZI
; File c:\dev\levos\kernel\gfxapp\windowmanager.cpp
_BSS	ENDS
;	COMDAT ?initWindowManager@@YAXXZ
_TEXT	SEGMENT
_i$2557 = -4						; size = 4
?initWindowManager@@YAXXZ PROC				; initWindowManager, COMDAT

; 6    : {

	push	ebp
	mov	ebp, esp
	sub	esp, 68					; 00000044H
	push	ebx
	push	esi
	push	edi

; 7    : 	for(int i = 0; i < 16; i++)

	mov	DWORD PTR _i$2557[ebp], 0
	jmp	SHORT $LN3@initWindow
$LN2@initWindow:
	mov	eax, DWORD PTR _i$2557[ebp]
	add	eax, 1
	mov	DWORD PTR _i$2557[ebp], eax
$LN3@initWindow:
	cmp	DWORD PTR _i$2557[ebp], 16		; 00000010H
	jge	SHORT $LN4@initWindow

; 8    : 	{
; 9    : 		wList[i]->isValid = false;

	mov	eax, DWORD PTR _i$2557[ebp]
	mov	ecx, DWORD PTR _wList[eax*4]
	mov	BYTE PTR [ecx+12], 0

; 10   : 	}

	jmp	SHORT $LN2@initWindow
$LN4@initWindow:

; 11   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?initWindowManager@@YAXXZ ENDP				; initWindowManager
_TEXT	ENDS
PUBLIC	?findFirstFreeSlot@@YAHXZ			; findFirstFreeSlot
; Function compile flags: /Odtp /ZI
;	COMDAT ?findFirstFreeSlot@@YAHXZ
_TEXT	SEGMENT
_i$2563 = -4						; size = 4
?findFirstFreeSlot@@YAHXZ PROC				; findFirstFreeSlot, COMDAT

; 14   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 68					; 00000044H
	push	ebx
	push	esi
	push	edi

; 15   : 	for(int i = 0; i < 16; i++)

	mov	DWORD PTR _i$2563[ebp], 0
	jmp	SHORT $LN4@findFirstF
$LN3@findFirstF:
	mov	eax, DWORD PTR _i$2563[ebp]
	add	eax, 1
	mov	DWORD PTR _i$2563[ebp], eax
$LN4@findFirstF:
	cmp	DWORD PTR _i$2563[ebp], 16		; 00000010H
	jge	SHORT $LN2@findFirstF

; 16   : 	{
; 17   : 		if(!wList[i]->isValid) return i;

	mov	eax, DWORD PTR _i$2563[ebp]
	mov	ecx, DWORD PTR _wList[eax*4]
	movzx	edx, BYTE PTR [ecx+12]
	test	edx, edx
	jne	SHORT $LN1@findFirstF
	mov	eax, DWORD PTR _i$2563[ebp]
	jmp	SHORT $LN5@findFirstF
$LN1@findFirstF:

; 18   : 	}

	jmp	SHORT $LN3@findFirstF
$LN2@findFirstF:

; 19   : 	return -1;

	or	eax, -1
$LN5@findFirstF:

; 20   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?findFirstFreeSlot@@YAHXZ ENDP				; findFirstFreeSlot
_TEXT	ENDS
PUBLIC	?addWindow@@YAHPAUWINDOW@@@Z			; addWindow
; Function compile flags: /Odtp /ZI
;	COMDAT ?addWindow@@YAHPAUWINDOW@@@Z
_TEXT	SEGMENT
_w$ = 8							; size = 4
?addWindow@@YAHPAUWINDOW@@@Z PROC			; addWindow, COMDAT

; 23   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 24   : 	if(!w->isValid) return -1;

	mov	eax, DWORD PTR _w$[ebp]
	movzx	ecx, BYTE PTR [eax+12]
	test	ecx, ecx
	jne	SHORT $LN2@addWindow
	or	eax, -1
	jmp	SHORT $LN3@addWindow
$LN2@addWindow:

; 25   : 	w->windowId = findFirstFreeSlot();

	call	?findFirstFreeSlot@@YAHXZ		; findFirstFreeSlot
	mov	ecx, DWORD PTR _w$[ebp]
	mov	BYTE PTR [ecx+29], al

; 26   : 	if(w->windowId == -1) return -1;

	mov	eax, DWORD PTR _w$[ebp]
	movsx	ecx, BYTE PTR [eax+29]
	cmp	ecx, -1
	jne	SHORT $LN1@addWindow
	or	eax, -1
	jmp	SHORT $LN3@addWindow
$LN1@addWindow:

; 27   : 	wList[w->windowId] = w;

	mov	eax, DWORD PTR _w$[ebp]
	movsx	ecx, BYTE PTR [eax+29]
	mov	edx, DWORD PTR _w$[ebp]
	mov	DWORD PTR _wList[ecx*4], edx

; 28   : 	return w->windowId;

	mov	eax, DWORD PTR _w$[ebp]
	movsx	eax, BYTE PTR [eax+29]
$LN3@addWindow:

; 29   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?addWindow@@YAHPAUWINDOW@@@Z ENDP			; addWindow
_TEXT	ENDS
PUBLIC	?repaintScreen@@YAXXZ				; repaintScreen
; Function compile flags: /Odtp /ZI
;	COMDAT ?repaintScreen@@YAXXZ
_TEXT	SEGMENT
_i$2575 = -4						; size = 4
?repaintScreen@@YAXXZ PROC				; repaintScreen, COMDAT

; 32   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 68					; 00000044H
	push	ebx
	push	esi
	push	edi

; 33   : 	for(int i = 0; i < 16; i++)

	mov	DWORD PTR _i$2575[ebp], 0
	jmp	SHORT $LN4@repaintScr
$LN3@repaintScr:
	mov	eax, DWORD PTR _i$2575[ebp]
	add	eax, 1
	mov	DWORD PTR _i$2575[ebp], eax
$LN4@repaintScr:
	cmp	DWORD PTR _i$2575[ebp], 16		; 00000010H
	jge	SHORT $LN5@repaintScr

; 34   : 	{
; 35   : 		if(!wList[i]->isValid)continue;

	mov	eax, DWORD PTR _i$2575[ebp]
	mov	ecx, DWORD PTR _wList[eax*4]
	movzx	edx, BYTE PTR [ecx+12]
	test	edx, edx
	jne	SHORT $LN1@repaintScr
	jmp	SHORT $LN3@repaintScr
$LN1@repaintScr:

; 36   : 		wList[i]->paint(wList[i]);

	mov	eax, DWORD PTR _i$2575[ebp]
	mov	ecx, DWORD PTR _wList[eax*4]
	push	ecx
	mov	edx, DWORD PTR _i$2575[ebp]
	mov	eax, DWORD PTR _wList[edx*4]
	mov	ecx, DWORD PTR [eax]
	call	ecx
	add	esp, 4

; 37   : 	}

	jmp	SHORT $LN3@repaintScr
$LN5@repaintScr:

; 38   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?repaintScreen@@YAXXZ ENDP				; repaintScreen
_TEXT	ENDS
PUBLIC	?getWindowById@@YAPAUWINDOW@@D@Z		; getWindowById
; Function compile flags: /Odtp /ZI
;	COMDAT ?getWindowById@@YAPAUWINDOW@@D@Z
_TEXT	SEGMENT
_id$ = 8						; size = 1
?getWindowById@@YAPAUWINDOW@@D@Z PROC			; getWindowById, COMDAT

; 41   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 42   : 	return wList[id];

	movsx	eax, BYTE PTR _id$[ebp]
	mov	eax, DWORD PTR _wList[eax*4]

; 43   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?getWindowById@@YAPAUWINDOW@@D@Z ENDP			; getWindowById
_TEXT	ENDS
PUBLIC	?removeWindow@@YAXD@Z				; removeWindow
; Function compile flags: /Odtp /ZI
;	COMDAT ?removeWindow@@YAXD@Z
_TEXT	SEGMENT
_id$ = 8						; size = 1
?removeWindow@@YAXD@Z PROC				; removeWindow, COMDAT

; 46   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 47   : 	wList[id]->isValid = false;

	movsx	eax, BYTE PTR _id$[ebp]
	mov	ecx, DWORD PTR _wList[eax*4]
	mov	BYTE PTR [ecx+12], 0

; 48   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?removeWindow@@YAXD@Z ENDP				; removeWindow
_TEXT	ENDS
END
