; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\currentTest.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	??_C@_01HIHLOKLC@1?$AA@				; `string'
PUBLIC	?taskone@@YAXXZ					; taskone
EXTRN	?DebugPrintf@@YAHPBDZZ:PROC			; DebugPrintf
;	COMDAT ??_C@_01HIHLOKLC@1?$AA@
; File c:\dev\levos\kernel\kernel\currenttest.cpp
CONST	SEGMENT
??_C@_01HIHLOKLC@1?$AA@ DB '1', 00H			; `string'
; Function compile flags: /Ogtpy
CONST	ENDS
;	COMDAT ?taskone@@YAXXZ
_TEXT	SEGMENT
?taskone@@YAXXZ PROC					; taskone, COMDAT

; 5    : {

$LL2@taskone:

; 6    : 	while(1) {
; 7    : 		DebugPrintf("1");

	push	OFFSET ??_C@_01HIHLOKLC@1?$AA@
	call	?DebugPrintf@@YAHPBDZZ			; DebugPrintf
	add	esp, 4

; 8    : 		/*_asm mov al, '1'
; 9    : 		_asm out 0xE9, al*/
; 10   : 	}

	jmp	SHORT $LL2@taskone
?taskone@@YAXXZ ENDP					; taskone
_TEXT	ENDS
PUBLIC	??_C@_01FDFGLJHB@2?$AA@				; `string'
PUBLIC	?tasktwo@@YAXXZ					; tasktwo
;	COMDAT ??_C@_01FDFGLJHB@2?$AA@
CONST	SEGMENT
??_C@_01FDFGLJHB@2?$AA@ DB '2', 00H			; `string'
; Function compile flags: /Ogtpy
CONST	ENDS
;	COMDAT ?tasktwo@@YAXXZ
_TEXT	SEGMENT
?tasktwo@@YAXXZ PROC					; tasktwo, COMDAT

; 13   : {

$LL2@tasktwo:

; 14   : 	 while(1) {
; 15   : 		DebugPrintf("2");

	push	OFFSET ??_C@_01FDFGLJHB@2?$AA@
	call	?DebugPrintf@@YAHPBDZZ			; DebugPrintf
	add	esp, 4

; 16   : 		/* _asm mov al, '2'
; 17   : 		_asm out 0xE9, al*/
; 18   : 	}

	jmp	SHORT $LL2@tasktwo
?tasktwo@@YAXXZ ENDP					; tasktwo
_TEXT	ENDS
PUBLIC	??_C@_01EKENIIDA@3?$AA@				; `string'
PUBLIC	?taskthree@@YAXXZ				; taskthree
;	COMDAT ??_C@_01EKENIIDA@3?$AA@
CONST	SEGMENT
??_C@_01EKENIIDA@3?$AA@ DB '3', 00H			; `string'
; Function compile flags: /Ogtpy
CONST	ENDS
;	COMDAT ?taskthree@@YAXXZ
_TEXT	SEGMENT
?taskthree@@YAXXZ PROC					; taskthree, COMDAT

; 21   : {

$LL2@taskthree:

; 22   : 	 while(1) {
; 23   : 		DebugPrintf("3");

	push	OFFSET ??_C@_01EKENIIDA@3?$AA@
	call	?DebugPrintf@@YAHPBDZZ			; DebugPrintf
	add	esp, 4

; 24   : 		 /*_asm mov al, '3'
; 25   : 		_asm out 0xE9, al*/
; 26   : 	}

	jmp	SHORT $LL2@taskthree
?taskthree@@YAXXZ ENDP					; taskthree
_TEXT	ENDS
END
