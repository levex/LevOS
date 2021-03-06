; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\buf_fifo.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

PUBLIC	?fifo_init@@YAXPAUfifo_t@@PADH@Z		; fifo_init
; Function compile flags: /Ogtpy
; File c:\dev\levos\kernel\kernel\buf_fifo.cpp
;	COMDAT ?fifo_init@@YAXPAUfifo_t@@PADH@Z
_TEXT	SEGMENT
_f$ = 8							; size = 4
_buf$ = 12						; size = 4
_size$ = 16						; size = 4
?fifo_init@@YAXPAUfifo_t@@PADH@Z PROC			; fifo_init, COMDAT

; 4    :      f->head = 0;

	mov	eax, DWORD PTR _f$[esp-4]

; 5    :      f->tail = 0;
; 6    :      f->size = size;
; 7    :      f->buf = buf;

	mov	edx, DWORD PTR _buf$[esp-4]
	xor	ecx, ecx
	mov	DWORD PTR [eax+4], ecx
	mov	DWORD PTR [eax+8], ecx
	mov	ecx, DWORD PTR _size$[esp-4]
	mov	DWORD PTR [eax+12], ecx
	mov	DWORD PTR [eax], edx

; 8    : }

	ret	0
?fifo_init@@YAXPAUfifo_t@@PADH@Z ENDP			; fifo_init
_TEXT	ENDS
PUBLIC	?fifo_read@@YAHPAUfifo_t@@PADH@Z		; fifo_read
; Function compile flags: /Ogtpy
;	COMDAT ?fifo_read@@YAHPAUfifo_t@@PADH@Z
_TEXT	SEGMENT
_f$ = 8							; size = 4
_buf$ = 12						; size = 4
_nbytes$ = 16						; size = 4
?fifo_read@@YAHPAUfifo_t@@PADH@Z PROC			; fifo_read, COMDAT

; 9    : int fifo_read(fifo_t * f, char * buf, int nbytes){

	push	ebx
	push	ebp

; 10   :      int i;
; 11   :      char * p;
; 12   :      p = buf;
; 13   :      for(i=0; i < nbytes; i++){

	mov	ebp, DWORD PTR _nbytes$[esp+4]
	xor	eax, eax
	push	esi
	test	ebp, ebp
	jle	SHORT $LN4@fifo_read
	mov	ecx, DWORD PTR _f$[esp+8]
	mov	esi, DWORD PTR _buf$[esp+8]
$LL6@fifo_read:

; 14   :           if( f->tail != f->head ){ //see if any data is available

	mov	edx, DWORD PTR [ecx+8]
	cmp	edx, DWORD PTR [ecx+4]
	je	SHORT $LN7@fifo_read

; 15   :                *p = f->buf[f->tail];  //grab a byte from the buffer

	mov	ebx, DWORD PTR [ecx]
	mov	dl, BYTE PTR [edx+ebx]
	mov	BYTE PTR [esi], dl

; 16   :                f->tail++;  //increment the tail

	inc	DWORD PTR [ecx+8]
	mov	edx, DWORD PTR [ecx+8]

; 17   :                if( f->tail == f->size ){  //check for wrap-around

	cmp	edx, DWORD PTR [ecx+12]
	jne	SHORT $LN5@fifo_read

; 18   :                     f->tail = 0;

	mov	DWORD PTR [ecx+8], 0
$LN5@fifo_read:

; 10   :      int i;
; 11   :      char * p;
; 12   :      p = buf;
; 13   :      for(i=0; i < nbytes; i++){

	inc	eax
	cmp	eax, ebp
	jl	SHORT $LL6@fifo_read
$LN4@fifo_read:

; 19   :                }
; 20   :           } else {
; 21   :                return i; //number of bytes read 
; 22   :           }
; 23   :      }
; 24   :      return nbytes;

	mov	eax, ebp
$LN7@fifo_read:
	pop	esi
	pop	ebp
	pop	ebx

; 25   : }

	ret	0
?fifo_read@@YAHPAUfifo_t@@PADH@Z ENDP			; fifo_read
_TEXT	ENDS
PUBLIC	?fifo_write@@YAHPAUfifo_t@@PBDH@Z		; fifo_write
; Function compile flags: /Ogtpy
;	COMDAT ?fifo_write@@YAHPAUfifo_t@@PBDH@Z
_TEXT	SEGMENT
_f$ = 8							; size = 4
_buf$ = 12						; size = 4
tv172 = 16						; size = 4
_nbytes$ = 16						; size = 4
?fifo_write@@YAHPAUfifo_t@@PBDH@Z PROC			; fifo_write, COMDAT

; 27   : int fifo_write(fifo_t * f, const char * buf, int nbytes){

	push	ebx
	push	ebp

; 28   :      int i;
; 29   :      const char * p;
; 30   :      p = buf;
; 31   :      for(i=0; i < nbytes; i++){

	mov	ebp, DWORD PTR _nbytes$[esp+4]
	push	esi
	xor	eax, eax
	push	edi
	test	ebp, ebp
	jle	SHORT $LN4@fifo_write
	mov	ecx, DWORD PTR _f$[esp+12]
	mov	ebx, DWORD PTR _buf$[esp+12]
$LL6@fifo_write:

; 32   :            //first check to see if there is space in the buffer
; 33   :            if( (f->head + 1 == f->tail) ||
; 34   :                 ( (f->head + 1 == f->size) && (f->tail == 0) ) ){

	mov	esi, DWORD PTR [ecx+4]
	mov	edi, DWORD PTR [ecx+8]
	lea	edx, DWORD PTR [esi+1]
	cmp	edx, edi
	je	SHORT $LN7@fifo_write
	cmp	edx, DWORD PTR [ecx+12]
	jne	SHORT $LN3@fifo_write
	test	edi, edi
	je	SHORT $LN7@fifo_write
$LN3@fifo_write:

; 35   :                  return i; //no more room
; 36   :            } else {
; 37   :                f->buf[f->head] = *p++;

	mov	edx, DWORD PTR [ecx]
	mov	DWORD PTR tv172[esp+12], ecx
	mov	cl, BYTE PTR [eax+ebx]
	inc	eax
	mov	BYTE PTR [esi+edx], cl
	mov	ecx, DWORD PTR tv172[esp+12]
	cmp	eax, ebp
	jl	SHORT $LL6@fifo_write
$LN4@fifo_write:

; 38   :            }
; 39   :      }
; 40   :      return nbytes;

	mov	eax, ebp
$LN7@fifo_write:
	pop	edi
	pop	esi
	pop	ebp
	pop	ebx

; 41   : }

	ret	0
?fifo_write@@YAHPAUfifo_t@@PBDH@Z ENDP			; fifo_write
_TEXT	ENDS
END
