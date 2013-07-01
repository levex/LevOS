; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\RTC.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	?rtc_getYear@@YAHXZ				; rtc_getYear
EXTRN	?inport@@YAEG@Z:PROC				; inport
EXTRN	?outport@@YAXGE@Z:PROC				; outport
; Function compile flags: /Ogtpy
; File c:\dev\levos\kernel\kernel\rtc.cpp
;	COMDAT ?rtc_getYear@@YAHXZ
_TEXT	SEGMENT
?rtc_getYear@@YAHXZ PROC				; rtc_getYear, COMDAT

; 5    : 	outport(0x70, 0x09);

	push	9
	push	112					; 00000070H
	call	?outport@@YAXGE@Z			; outport

; 6    : 	//sleep(1);
; 7    : 	int year = inport(0x71);

	push	113					; 00000071H
	call	?inport@@YAEG@Z				; inport
	add	esp, 12					; 0000000cH

; 8    : 	return year;

	movzx	eax, al

; 9    : }

	ret	0
?rtc_getYear@@YAHXZ ENDP				; rtc_getYear
_TEXT	ENDS
PUBLIC	?rtc_getMonth@@YAHXZ				; rtc_getMonth
; Function compile flags: /Ogtpy
;	COMDAT ?rtc_getMonth@@YAHXZ
_TEXT	SEGMENT
?rtc_getMonth@@YAHXZ PROC				; rtc_getMonth, COMDAT

; 13   : 	outport(0x70, 0x08);

	push	8
	push	112					; 00000070H
	call	?outport@@YAXGE@Z			; outport

; 14   : 	//sleep(1);
; 15   : 	int year = inport(0x71);

	push	113					; 00000071H
	call	?inport@@YAEG@Z				; inport
	add	esp, 12					; 0000000cH

; 16   : 	return year;

	movzx	eax, al

; 17   : }

	ret	0
?rtc_getMonth@@YAHXZ ENDP				; rtc_getMonth
_TEXT	ENDS
PUBLIC	?rtc_getDayOfMonth@@YAHXZ			; rtc_getDayOfMonth
; Function compile flags: /Ogtpy
;	COMDAT ?rtc_getDayOfMonth@@YAHXZ
_TEXT	SEGMENT
?rtc_getDayOfMonth@@YAHXZ PROC				; rtc_getDayOfMonth, COMDAT

; 21   : 	outport(0x70, 0x07);

	push	7
	push	112					; 00000070H
	call	?outport@@YAXGE@Z			; outport

; 22   : 	//sleep(1);
; 23   : 	int year = inport(0x71);

	push	113					; 00000071H
	call	?inport@@YAEG@Z				; inport
	add	esp, 12					; 0000000cH

; 24   : 	return year;

	movzx	eax, al

; 25   : }

	ret	0
?rtc_getDayOfMonth@@YAHXZ ENDP				; rtc_getDayOfMonth
_TEXT	ENDS
PUBLIC	?rtc_getWeekday@@YAHXZ				; rtc_getWeekday
; Function compile flags: /Ogtpy
;	COMDAT ?rtc_getWeekday@@YAHXZ
_TEXT	SEGMENT
?rtc_getWeekday@@YAHXZ PROC				; rtc_getWeekday, COMDAT

; 30   : 	outport(0x70, 0x06);

	push	6
	push	112					; 00000070H
	call	?outport@@YAXGE@Z			; outport

; 31   : 	//sleep(1);
; 32   : 	int year = inport(0x71);

	push	113					; 00000071H
	call	?inport@@YAEG@Z				; inport
	add	esp, 12					; 0000000cH

; 33   : 	return year;

	movzx	eax, al

; 34   : }

	ret	0
?rtc_getWeekday@@YAHXZ ENDP				; rtc_getWeekday
_TEXT	ENDS
PUBLIC	?rtc_getHour@@YAHXZ				; rtc_getHour
; Function compile flags: /Ogtpy
;	COMDAT ?rtc_getHour@@YAHXZ
_TEXT	SEGMENT
?rtc_getHour@@YAHXZ PROC				; rtc_getHour, COMDAT

; 38   : 	outport(0x70, 0x04);

	push	4
	push	112					; 00000070H
	call	?outport@@YAXGE@Z			; outport

; 39   : 	//sleep(1);
; 40   : 	int year = inport(0x71);

	push	113					; 00000071H
	call	?inport@@YAEG@Z				; inport
	add	esp, 12					; 0000000cH

; 41   : 	return year;

	movzx	eax, al

; 42   : }

	ret	0
?rtc_getHour@@YAHXZ ENDP				; rtc_getHour
_TEXT	ENDS
PUBLIC	?rtc_getMinute@@YAHXZ				; rtc_getMinute
; Function compile flags: /Ogtpy
;	COMDAT ?rtc_getMinute@@YAHXZ
_TEXT	SEGMENT
?rtc_getMinute@@YAHXZ PROC				; rtc_getMinute, COMDAT

; 46   : 	outport(0x70, 0x02);

	push	2
	push	112					; 00000070H
	call	?outport@@YAXGE@Z			; outport

; 47   : 	//sleep(1);
; 48   : 	int year = inport(0x71);

	push	113					; 00000071H
	call	?inport@@YAEG@Z				; inport
	add	esp, 12					; 0000000cH

; 49   : 	return year;

	movzx	eax, al

; 50   : }

	ret	0
?rtc_getMinute@@YAHXZ ENDP				; rtc_getMinute
_TEXT	ENDS
PUBLIC	?rtc_getSecond@@YAHXZ				; rtc_getSecond
; Function compile flags: /Ogtpy
;	COMDAT ?rtc_getSecond@@YAHXZ
_TEXT	SEGMENT
?rtc_getSecond@@YAHXZ PROC				; rtc_getSecond, COMDAT

; 54   : 	outport(0x70, 0x00);

	push	0
	push	112					; 00000070H
	call	?outport@@YAXGE@Z			; outport

; 55   : 	//sleep(1);
; 56   : 	int year = inport(0x71);

	push	113					; 00000071H
	call	?inport@@YAEG@Z				; inport
	add	esp, 12					; 0000000cH

; 57   : 	return year;

	movzx	eax, al

; 58   : }

	ret	0
?rtc_getSecond@@YAHXZ ENDP				; rtc_getSecond
_TEXT	ENDS
END