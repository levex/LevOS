; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\Math.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	?math_abs@@YAIH@Z				; math_abs
; Function compile flags: /Ogtpy
; File c:\dev\levos\kernel\kernel\math.cpp
;	COMDAT ?math_abs@@YAIH@Z
_TEXT	SEGMENT
_a$ = 8							; size = 4
?math_abs@@YAIH@Z PROC					; math_abs, COMDAT

; 5    : 	if(a >= 0) return a;

	mov	eax, DWORD PTR _a$[esp-4]
	test	eax, eax
	jns	SHORT $LN1@math_abs

; 6    : 	else return -a;

	neg	eax
$LN1@math_abs:

; 7    : }

	ret	0
?math_abs@@YAIH@Z ENDP					; math_abs
_TEXT	ENDS
END
