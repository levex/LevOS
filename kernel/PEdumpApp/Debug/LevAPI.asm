; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Users\Levex\Desktop\newLevOS\TerminalApp\LevAPI.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	?print@@YAXPAD@Z				; print
; Function compile flags: /Odtp /ZI
; File c:\users\levex\desktop\newlevos\terminalapp\levapi.cpp
;	COMDAT ?print@@YAXPAD@Z
_TEXT	SEGMENT
_s$ = 8							; size = 4
?print@@YAXPAD@Z PROC					; print, COMDAT

; 8    : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 9    : 	//API_BEGIN;
; 10   : 	//_asm mov ecx, [s]
; 11   : 	_asm {
; 12   : 		mov edx, s

	mov	edx, DWORD PTR _s$[ebp]

; 13   : 		mov eax, 0x02

	mov	eax, 2

; 14   : 		int 0x2F

	int	47					; 0000002fH

; 15   : 	}
; 16   : 	//API_END;
; 17   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?print@@YAXPAD@Z ENDP					; print
_TEXT	ENDS
PUBLIC	?printchar@@YAXD@Z				; printchar
; Function compile flags: /Odtp /ZI
;	COMDAT ?printchar@@YAXD@Z
_TEXT	SEGMENT
_c$ = 8							; size = 1
?printchar@@YAXD@Z PROC					; printchar, COMDAT

; 20   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 21   : 	_asm{
; 22   : 		mov eax, 0x03

	mov	eax, 3

; 23   : 		mov bl, c

	mov	bl, BYTE PTR _c$[ebp]

; 24   : 		int 0x2F

	int	47					; 0000002fH

; 25   : 	}
; 26   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?printchar@@YAXD@Z ENDP					; printchar
_TEXT	ENDS
PUBLIC	?printNumber@@YAXH@Z				; printNumber
; Function compile flags: /Odtp /ZI
;	COMDAT ?printNumber@@YAXH@Z
_TEXT	SEGMENT
_i$ = 8							; size = 4
?printNumber@@YAXH@Z PROC				; printNumber, COMDAT

; 28   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 29   : 	_asm {
; 30   : 		mov eax, 0x08

	mov	eax, 8

; 31   : 		mov edx, i

	mov	edx, DWORD PTR _i$[ebp]

; 32   : 		int 0x2F

	int	47					; 0000002fH

; 33   : 	}
; 34   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?printNumber@@YAXH@Z ENDP				; printNumber
_TEXT	ENDS
PUBLIC	?printHexa@@YAXH@Z				; printHexa
; Function compile flags: /Odtp /ZI
;	COMDAT ?printHexa@@YAXH@Z
_TEXT	SEGMENT
_i$ = 8							; size = 4
?printHexa@@YAXH@Z PROC					; printHexa, COMDAT

; 36   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 37   : 	_asm {
; 38   : 		mov eax, 0x0A

	mov	eax, 10					; 0000000aH

; 39   : 		mov edx, i

	mov	edx, DWORD PTR _i$[ebp]

; 40   : 		int 0x2F

	int	47					; 0000002fH

; 41   : 	}
; 42   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?printHexa@@YAXH@Z ENDP					; printHexa
_TEXT	ENDS
PUBLIC	?halt@@YAXXZ					; halt
; Function compile flags: /Odtp /ZI
;	COMDAT ?halt@@YAXXZ
_TEXT	SEGMENT
?halt@@YAXXZ PROC					; halt, COMDAT

; 45   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 46   : 	_asm {
; 47   : 		xor eax,eax

	xor	eax, eax

; 48   : 		int 0x2F

	int	47					; 0000002fH

; 49   : 	}
; 50   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?halt@@YAXXZ ENDP					; halt
_TEXT	ENDS
PUBLIC	?getInputChar@@YADXZ				; getInputChar
; Function compile flags: /Odtp /ZI
;	COMDAT ?getInputChar@@YADXZ
_TEXT	SEGMENT
_r$ = -1						; size = 1
?getInputChar@@YADXZ PROC				; getInputChar, COMDAT

; 53   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 68					; 00000044H
	push	ebx
	push	esi
	push	edi

; 54   : 	char r = 0;

	mov	BYTE PTR _r$[ebp], 0

; 55   : 	_asm {
; 56   : 		mov eax, 0x4

	mov	eax, 4

; 57   : 		int 0x2F

	int	47					; 0000002fH

; 58   : 		mov r, dh

	mov	BYTE PTR _r$[ebp], dh

; 59   : 	}
; 60   : 	return r;

	mov	al, BYTE PTR _r$[ebp]

; 61   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?getInputChar@@YADXZ ENDP				; getInputChar
_TEXT	ENDS
PUBLIC	?loadFileToLoc@@YA_NPAD0@Z			; loadFileToLoc
; Function compile flags: /Odtp /ZI
;	COMDAT ?loadFileToLoc@@YA_NPAD0@Z
_TEXT	SEGMENT
__c$ = -4						; size = 4
_filename$ = 8						; size = 4
_address$ = 12						; size = 4
?loadFileToLoc@@YA_NPAD0@Z PROC				; loadFileToLoc, COMDAT

; 63   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 68					; 00000044H
	push	ebx
	push	esi
	push	edi

; 64   : 	_asm {
; 65   : 		mov ebx, address

	mov	ebx, DWORD PTR _address$[ebp]

; 66   : 		mov edx, filename

	mov	edx, DWORD PTR _filename$[ebp]

; 67   : 		mov eax, 0x05

	mov	eax, 5

; 68   : 		int 0x2F

	int	47					; 0000002fH

; 69   : 	}
; 70   : 	int _c = 0;

	mov	DWORD PTR __c$[ebp], 0

; 71   : 	_asm mov _c, edx

	mov	DWORD PTR __c$[ebp], edx

; 72   : 	return (_c==1);

	xor	eax, eax
	cmp	DWORD PTR __c$[ebp], 1
	sete	al

; 73   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?loadFileToLoc@@YA_NPAD0@Z ENDP				; loadFileToLoc
_TEXT	ENDS
PUBLIC	?moveCursorRelative@@YAXDD@Z			; moveCursorRelative
; Function compile flags: /Odtp /ZI
;	COMDAT ?moveCursorRelative@@YAXDD@Z
_TEXT	SEGMENT
_rx$ = 8						; size = 1
_ry$ = 12						; size = 1
?moveCursorRelative@@YAXDD@Z PROC			; moveCursorRelative, COMDAT

; 75   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 76   : 	_asm {
; 77   : 		mov dh, rx

	mov	dh, BYTE PTR _rx$[ebp]

; 78   : 		mov dl, ry

	mov	dl, BYTE PTR _ry$[ebp]

; 79   : 		mov eax, 0x06

	mov	eax, 6

; 80   : 		mov ebx, 0x01

	mov	ebx, 1

; 81   : 		int 0x2F

	int	47					; 0000002fH

; 82   : 	}
; 83   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?moveCursorRelative@@YAXDD@Z ENDP			; moveCursorRelative
_TEXT	ENDS
PUBLIC	?executePE32@@YAXPAD@Z				; executePE32
; Function compile flags: /Odtp /ZI
;	COMDAT ?executePE32@@YAXPAD@Z
_TEXT	SEGMENT
_filename$ = 8						; size = 4
?executePE32@@YAXPAD@Z PROC				; executePE32, COMDAT

; 85   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 86   : 	_asm {
; 87   : 		mov edx, filename

	mov	edx, DWORD PTR _filename$[ebp]

; 88   : 		mov eax, 0x07

	mov	eax, 7

; 89   : 		int 0x2F

	int	47					; 0000002fH

; 90   : 	}
; 91   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?executePE32@@YAXPAD@Z ENDP				; executePE32
_TEXT	ENDS
PUBLIC	?clearScreen@@YAXXZ				; clearScreen
; Function compile flags: /Odtp /ZI
;	COMDAT ?clearScreen@@YAXXZ
_TEXT	SEGMENT
?clearScreen@@YAXXZ PROC				; clearScreen, COMDAT

; 93   : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 94   : 	_asm {
; 95   : 		mov eax, 0x06 // display utils

	mov	eax, 6

; 96   : 		mov ebx, 0x02 // clear screen

	mov	ebx, 2

; 97   : 		int 0x2F // invoke levos kernel

	int	47					; 0000002fH

; 98   : 	}
; 99   : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?clearScreen@@YAXXZ ENDP				; clearScreen
_TEXT	ENDS
PUBLIC	?fillRTC@@YAXH@Z				; fillRTC
; Function compile flags: /Odtp /ZI
;	COMDAT ?fillRTC@@YAXH@Z
_TEXT	SEGMENT
_data$ = 8						; size = 4
?fillRTC@@YAXH@Z PROC					; fillRTC, COMDAT

; 101  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 102  : 	_asm {
; 103  : 		mov eax, 0x09

	mov	eax, 9

; 104  : 		mov edx, data

	mov	edx, DWORD PTR _data$[ebp]

; 105  : 		int 0x2F

	int	47					; 0000002fH

; 106  : 	}
; 107  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?fillRTC@@YAXH@Z ENDP					; fillRTC
_TEXT	ENDS
PUBLIC	?getNumberOfFilesInRoot@@YAHXZ			; getNumberOfFilesInRoot
; Function compile flags: /Odtp /ZI
;	COMDAT ?getNumberOfFilesInRoot@@YAHXZ
_TEXT	SEGMENT
_ret$ = -4						; size = 4
?getNumberOfFilesInRoot@@YAHXZ PROC			; getNumberOfFilesInRoot, COMDAT

; 109  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 68					; 00000044H
	push	ebx
	push	esi
	push	edi

; 110  : 	int ret = 0;

	mov	DWORD PTR _ret$[ebp], 0

; 111  : 	_asm {
; 112  : 		mov eax, 0x0B

	mov	eax, 11					; 0000000bH

; 113  : 		mov ebx, 0x02

	mov	ebx, 2

; 114  : 		int 0x2F

	int	47					; 0000002fH

; 115  : 		mov ret, edx

	mov	DWORD PTR _ret$[ebp], edx

; 116  : 	}
; 117  : 	return ret;

	mov	eax, DWORD PTR _ret$[ebp]

; 118  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?getNumberOfFilesInRoot@@YAHXZ ENDP			; getNumberOfFilesInRoot
_TEXT	ENDS
PUBLIC	?getFilesInRoot@@YAPADXZ			; getFilesInRoot
; Function compile flags: /Odtp /ZI
;	COMDAT ?getFilesInRoot@@YAPADXZ
_TEXT	SEGMENT
_ret$ = -4						; size = 4
?getFilesInRoot@@YAPADXZ PROC				; getFilesInRoot, COMDAT

; 120  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 68					; 00000044H
	push	ebx
	push	esi
	push	edi

; 121  : 	char* ret;
; 122  : 	_asm 
; 123  : 	{
; 124  : 		mov eax, 0x0B

	mov	eax, 11					; 0000000bH

; 125  : 		mov ebx, 0x01

	mov	ebx, 1

; 126  : 		int 0x2F

	int	47					; 0000002fH

; 127  : 		mov ret, edx

	mov	DWORD PTR _ret$[ebp], edx

; 128  : 	}
; 129  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?getFilesInRoot@@YAPADXZ ENDP				; getFilesInRoot
_TEXT	ENDS
PUBLIC	?VGA_init@@YAXXZ				; VGA_init
; Function compile flags: /Odtp /ZI
;	COMDAT ?VGA_init@@YAXXZ
_TEXT	SEGMENT
?VGA_init@@YAXXZ PROC					; VGA_init, COMDAT

; 131  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 132  : 	_asm {
; 133  : 		mov eax, 0x0C

	mov	eax, 12					; 0000000cH

; 134  : 		mov ebx, 0x01

	mov	ebx, 1

; 135  : 		int 0x2F

	int	47					; 0000002fH

; 136  : 	}
; 137  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?VGA_init@@YAXXZ ENDP					; VGA_init
_TEXT	ENDS
PUBLIC	?VGA_clear@@YAXXZ				; VGA_clear
; Function compile flags: /Odtp /ZI
;	COMDAT ?VGA_clear@@YAXXZ
_TEXT	SEGMENT
?VGA_clear@@YAXXZ PROC					; VGA_clear, COMDAT

; 139  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 140  : 	_asm {
; 141  : 		mov eax, 0x0C

	mov	eax, 12					; 0000000cH

; 142  : 		mov ebx, 0x03

	mov	ebx, 3

; 143  : 		int 0x2F

	int	47					; 0000002fH

; 144  : 	}
; 145  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?VGA_clear@@YAXXZ ENDP					; VGA_clear
_TEXT	ENDS
PUBLIC	?VGA_putpixel@@YAXHHD@Z				; VGA_putpixel
; Function compile flags: /Odtp /ZI
;	COMDAT ?VGA_putpixel@@YAXHHD@Z
_TEXT	SEGMENT
_x$ = 8							; size = 4
_y$ = 12						; size = 4
_color$ = 16						; size = 1
?VGA_putpixel@@YAXHHD@Z PROC				; VGA_putpixel, COMDAT

; 147  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 148  : 	_asm {
; 149  : 		mov eax, 0x0C //vga

	mov	eax, 12					; 0000000cH

; 150  : 		mov ebx, 0x02 //putpixel

	mov	ebx, 2

; 151  : 		mov ecx, x

	mov	ecx, DWORD PTR _x$[ebp]

; 152  : 		mov esi, y

	mov	esi, DWORD PTR _y$[ebp]

; 153  : 		mov DL, color

	mov	dl, BYTE PTR _color$[ebp]

; 154  : 		int 0x2F

	int	47					; 0000002fH

; 155  : 	}
; 156  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?VGA_putpixel@@YAXHHD@Z ENDP				; VGA_putpixel
_TEXT	ENDS
PUBLIC	?VGA_putimage@@YAXHHPAD@Z			; VGA_putimage
; Function compile flags: /Odtp /ZI
;	COMDAT ?VGA_putimage@@YAXHHPAD@Z
_TEXT	SEGMENT
_x$ = 8							; size = 4
_y$ = 12						; size = 4
_filename$ = 16						; size = 4
?VGA_putimage@@YAXHHPAD@Z PROC				; VGA_putimage, COMDAT

; 158  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 159  : 	_asm {
; 160  : 		mov eax, 0x0C //vga

	mov	eax, 12					; 0000000cH

; 161  : 		mov ebx, 0x04 //putimage

	mov	ebx, 4

; 162  : 		mov esi, x

	mov	esi, DWORD PTR _x$[ebp]

; 163  : 		mov edi, y

	mov	edi, DWORD PTR _y$[ebp]

; 164  : 		mov edx, filename

	mov	edx, DWORD PTR _filename$[ebp]

; 165  : 		int 0x2F

	int	47					; 0000002fH

; 166  : 	}
; 167  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?VGA_putimage@@YAXHHPAD@Z ENDP				; VGA_putimage
_TEXT	ENDS
PUBLIC	?VGA_deinit@@YAXXZ				; VGA_deinit
; Function compile flags: /Odtp /ZI
;	COMDAT ?VGA_deinit@@YAXXZ
_TEXT	SEGMENT
?VGA_deinit@@YAXXZ PROC					; VGA_deinit, COMDAT

; 169  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 170  : 		_asm
; 171  : 		{
; 172  : 			mov eax, 0x0C

	mov	eax, 12					; 0000000cH

; 173  : 			mov ebx, 0x05

	mov	ebx, 5

; 174  : 			int 0x2f

	int	47					; 0000002fH

; 175  : 		}
; 176  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?VGA_deinit@@YAXXZ ENDP					; VGA_deinit
_TEXT	ENDS
PUBLIC	?VGA_putstring@@YAXHHPAD@Z			; VGA_putstring
; Function compile flags: /Odtp /ZI
;	COMDAT ?VGA_putstring@@YAXHHPAD@Z
_TEXT	SEGMENT
_x$ = 8							; size = 4
_y$ = 12						; size = 4
_str$ = 16						; size = 4
?VGA_putstring@@YAXHHPAD@Z PROC				; VGA_putstring, COMDAT

; 178  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 179  : 		_asm{
; 180  : 			mov eax, 0x0C

	mov	eax, 12					; 0000000cH

; 181  : 			mov ebx, 0x06

	mov	ebx, 6

; 182  : 			mov esi, str

	mov	esi, DWORD PTR _str$[ebp]

; 183  : 			mov ecx, x

	mov	ecx, DWORD PTR _x$[ebp]

; 184  : 			mov edx, y

	mov	edx, DWORD PTR _y$[ebp]

; 185  : 			int 0x2F

	int	47					; 0000002fH

; 186  : 		}
; 187  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?VGA_putstring@@YAXHHPAD@Z ENDP				; VGA_putstring
_TEXT	ENDS
PUBLIC	?VGA_putchar@@YAXHHD@Z				; VGA_putchar
; Function compile flags: /Odtp /ZI
;	COMDAT ?VGA_putchar@@YAXHHD@Z
_TEXT	SEGMENT
_x$ = 8							; size = 4
_y$ = 12						; size = 4
_c$ = 16						; size = 1
?VGA_putchar@@YAXHHD@Z PROC				; VGA_putchar, COMDAT

; 190  : {

	push	ebp
	mov	ebp, esp
	sub	esp, 64					; 00000040H
	push	ebx
	push	esi
	push	edi

; 191  : 	_asm {
; 192  : 		mov eax, 0x0C

	mov	eax, 12					; 0000000cH

; 193  : 		mov ebx, 0x07

	mov	ebx, 7

; 194  : 		mov esi, x

	mov	esi, DWORD PTR _x$[ebp]

; 195  : 		mov edi, y

	mov	edi, DWORD PTR _y$[ebp]

; 196  : 		mov cl, c

	mov	cl, BYTE PTR _c$[ebp]

; 197  : 		int 0x2f

	int	47					; 0000002fH

; 198  : 	}
; 199  : }

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
?VGA_putchar@@YAXHHD@Z ENDP				; VGA_putchar
_TEXT	ENDS
END
