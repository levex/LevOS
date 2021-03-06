; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\hw_keyboard.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

_BSS	SEGMENT
__kkybrd_error DD 01H DUP (?)
__kkybrd_bat_res DB 01H DUP (?)
	ALIGN	4

__kkybrd_diag_res DB 01H DUP (?)
	ALIGN	4

__kkybrd_resend_res DB 01H DUP (?)
	ALIGN	4

__kkybrd_disable DB 01H DUP (?)
_BSS	ENDS
_DATA	SEGMENT
__kkybrd_scancode_std DD 04012H
	DD	01001H
	DD	031H
	DD	032H
	DD	033H
	DD	034H
	DD	035H
	DD	036H
	DD	037H
	DD	038H
	DD	039H
	DD	030H
	DD	02dH
	DD	03dH
	DD	08H
	DD	04000H
	DD	071H
	DD	077H
	DD	065H
	DD	072H
	DD	074H
	DD	079H
	DD	075H
	DD	069H
	DD	06fH
	DD	070H
	DD	05bH
	DD	05dH
	DD	0dH
	DD	04003H
	DD	061H
	DD	073H
	DD	064H
	DD	066H
	DD	067H
	DD	068H
	DD	06aH
	DD	06bH
	DD	06cH
	DD	03bH
	DD	027H
	DD	060H
	DD	04002H
	DD	05cH
	DD	07aH
	DD	078H
	DD	063H
	DD	076H
	DD	062H
	DD	06eH
	DD	06dH
	DD	02cH
	DD	02eH
	DD	02fH
	DD	04006H
	DD	02aH
	DD	04008H
	DD	020H
	DD	04001H
	DD	01201H
	DD	01202H
	DD	01203H
	DD	01204H
	DD	01205H
	DD	01206H
	DD	01207H
	DD	01208H
	DD	01209H
	DD	0120aH
	DD	0300fH
	DD	04010H
	DD	0400cH
	DD	038H
	DD	0400eH
	DD	032H
	DD	033H
	DD	030H
	DD	02eH
	DD	04012H
	DD	04012H
	DD	04012H
	DD	0120bH
	DD	0120bH
_DATA	ENDS
PUBLIC	?kybrd_ctrl_read_status@@YAEXZ			; kybrd_ctrl_read_status
EXTRN	?inport@@YAEG@Z:PROC				; inport
; Function compile flags: /Ogtpy
; File c:\dev\levos\kernel\kernel\hw_keyboard.cpp
;	COMDAT ?kybrd_ctrl_read_status@@YAEXZ
_TEXT	SEGMENT
?kybrd_ctrl_read_status@@YAEXZ PROC			; kybrd_ctrl_read_status, COMDAT

; 220  : 
; 221  : 	return inport (KYBRD_CTRL_STATS_REG);

	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4

; 222  : }

	ret	0
?kybrd_ctrl_read_status@@YAEXZ ENDP			; kybrd_ctrl_read_status
_TEXT	ENDS
PUBLIC	?kybrd_ctrl_send_cmd@@YAXE@Z			; kybrd_ctrl_send_cmd
EXTRN	?outport@@YAXGE@Z:PROC				; outport
; Function compile flags: /Ogtpy
;	COMDAT ?kybrd_ctrl_send_cmd@@YAXE@Z
_TEXT	SEGMENT
_cmd$ = 8						; size = 1
?kybrd_ctrl_send_cmd@@YAXE@Z PROC			; kybrd_ctrl_send_cmd, COMDAT

; 225  : void kybrd_ctrl_send_cmd (uint8_t cmd) {

$LL3@kybrd_ctrl:

; 226  : 
; 227  : 	// wait for kkybrd controller input buffer to be clear
; 228  : 	while (1)
; 229  : 		if ( (kybrd_ctrl_read_status () & KYBRD_CTRL_STATS_MASK_IN_BUF) == 0)

	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL3@kybrd_ctrl

; 230  : 			break;
; 231  : 
; 232  : 	outport (KYBRD_CTRL_CMD_REG, cmd);

	mov	eax, DWORD PTR _cmd$[esp-4]
	push	eax
	push	100					; 00000064H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 233  : }

	ret	0
?kybrd_ctrl_send_cmd@@YAXE@Z ENDP			; kybrd_ctrl_send_cmd
_TEXT	ENDS
PUBLIC	?kybrd_enc_read_buf@@YAEXZ			; kybrd_enc_read_buf
; Function compile flags: /Ogtpy
;	COMDAT ?kybrd_enc_read_buf@@YAEXZ
_TEXT	SEGMENT
?kybrd_enc_read_buf@@YAEXZ PROC				; kybrd_enc_read_buf, COMDAT

; 237  : 
; 238  : 	return inport (KYBRD_ENC_INPUT_BUF);

	push	96					; 00000060H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4

; 239  : }

	ret	0
?kybrd_enc_read_buf@@YAEXZ ENDP				; kybrd_enc_read_buf
_TEXT	ENDS
PUBLIC	?kybrd_enc_send_cmd@@YAXE@Z			; kybrd_enc_send_cmd
; Function compile flags: /Ogtpy
;	COMDAT ?kybrd_enc_send_cmd@@YAXE@Z
_TEXT	SEGMENT
_cmd$ = 8						; size = 1
?kybrd_enc_send_cmd@@YAXE@Z PROC			; kybrd_enc_send_cmd, COMDAT

; 242  : void kybrd_enc_send_cmd (uint8_t cmd) {

$LL3@kybrd_enc_:

; 243  : 
; 244  : 	// wait for kkybrd controller input buffer to be clear
; 245  : 	while (1)
; 246  : 		if ( (kybrd_ctrl_read_status () & KYBRD_CTRL_STATS_MASK_IN_BUF) == 0)

	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL3@kybrd_enc_

; 247  : 			break;
; 248  : 
; 249  : 	// send command byte to kybrd encoder
; 250  : 	outport (KYBRD_ENC_CMD_REG, cmd);

	mov	eax, DWORD PTR _cmd$[esp-4]
	push	eax
	push	96					; 00000060H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 251  : }

	ret	0
?kybrd_enc_send_cmd@@YAXE@Z ENDP			; kybrd_enc_send_cmd
_TEXT	ENDS
PUBLIC	?kkybrd_get_scroll_lock@@YA_NXZ			; kkybrd_get_scroll_lock
_BSS	SEGMENT
	ALIGN	4

__scrolllock DB	01H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_get_scroll_lock@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_scroll_lock@@YA_NXZ PROC			; kkybrd_get_scroll_lock, COMDAT

; 396  : 
; 397  : 	return _scrolllock;

	mov	al, BYTE PTR __scrolllock

; 398  : }

	ret	0
?kkybrd_get_scroll_lock@@YA_NXZ ENDP			; kkybrd_get_scroll_lock
_TEXT	ENDS
PUBLIC	?kkybrd_get_numlock@@YA_NXZ			; kkybrd_get_numlock
_BSS	SEGMENT
	ALIGN	4

__numlock DB	01H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_get_numlock@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_numlock@@YA_NXZ PROC			; kkybrd_get_numlock, COMDAT

; 402  : 
; 403  : 	return _numlock;

	mov	al, BYTE PTR __numlock

; 404  : }

	ret	0
?kkybrd_get_numlock@@YA_NXZ ENDP			; kkybrd_get_numlock
_TEXT	ENDS
PUBLIC	?kkybrd_get_capslock@@YA_NXZ			; kkybrd_get_capslock
_BSS	SEGMENT
	ALIGN	4

__capslock DB	01H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_get_capslock@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_capslock@@YA_NXZ PROC			; kkybrd_get_capslock, COMDAT

; 408  : 
; 409  : 	return _capslock;

	mov	al, BYTE PTR __capslock

; 410  : }

	ret	0
?kkybrd_get_capslock@@YA_NXZ ENDP			; kkybrd_get_capslock
_TEXT	ENDS
PUBLIC	?kkybrd_get_ctrl@@YA_NXZ			; kkybrd_get_ctrl
_BSS	SEGMENT
	ALIGN	4

__ctrl	DB	01H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_get_ctrl@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_ctrl@@YA_NXZ PROC				; kkybrd_get_ctrl, COMDAT

; 414  : 
; 415  : 	return _ctrl;

	mov	al, BYTE PTR __ctrl

; 416  : }

	ret	0
?kkybrd_get_ctrl@@YA_NXZ ENDP				; kkybrd_get_ctrl
_TEXT	ENDS
PUBLIC	?kkybrd_get_alt@@YA_NXZ				; kkybrd_get_alt
_BSS	SEGMENT
	ALIGN	4

__alt	DB	01H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_get_alt@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_alt@@YA_NXZ PROC				; kkybrd_get_alt, COMDAT

; 420  : 
; 421  : 	return _alt;

	mov	al, BYTE PTR __alt

; 422  : }

	ret	0
?kkybrd_get_alt@@YA_NXZ ENDP				; kkybrd_get_alt
_TEXT	ENDS
PUBLIC	?kkybrd_get_shift@@YA_NXZ			; kkybrd_get_shift
_BSS	SEGMENT
	ALIGN	4

__shift	DB	01H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_get_shift@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_shift@@YA_NXZ PROC				; kkybrd_get_shift, COMDAT

; 426  : 
; 427  : 	return _shift;

	mov	al, BYTE PTR __shift

; 428  : }

	ret	0
?kkybrd_get_shift@@YA_NXZ ENDP				; kkybrd_get_shift
_TEXT	ENDS
PUBLIC	?kkybrd_ignore_resend@@YAXXZ			; kkybrd_ignore_resend
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_ignore_resend@@YAXXZ
_TEXT	SEGMENT
?kkybrd_ignore_resend@@YAXXZ PROC			; kkybrd_ignore_resend, COMDAT

; 432  : 
; 433  : 	_kkybrd_resend_res = false;

	mov	BYTE PTR __kkybrd_resend_res, 0

; 434  : }

	ret	0
?kkybrd_ignore_resend@@YAXXZ ENDP			; kkybrd_ignore_resend
_TEXT	ENDS
PUBLIC	?kkybrd_check_resend@@YA_NXZ			; kkybrd_check_resend
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_check_resend@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_check_resend@@YA_NXZ PROC			; kkybrd_check_resend, COMDAT

; 438  : 
; 439  : 	return _kkybrd_resend_res;

	mov	al, BYTE PTR __kkybrd_resend_res

; 440  : }

	ret	0
?kkybrd_check_resend@@YA_NXZ ENDP			; kkybrd_check_resend
_TEXT	ENDS
PUBLIC	?kkybrd_get_diagnostic_res@@YA_NXZ		; kkybrd_get_diagnostic_res
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_get_diagnostic_res@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_diagnostic_res@@YA_NXZ PROC			; kkybrd_get_diagnostic_res, COMDAT

; 444  : 
; 445  : 	return _kkybrd_diag_res;

	mov	al, BYTE PTR __kkybrd_diag_res

; 446  : }

	ret	0
?kkybrd_get_diagnostic_res@@YA_NXZ ENDP			; kkybrd_get_diagnostic_res
_TEXT	ENDS
PUBLIC	?kkybrd_get_bat_res@@YA_NXZ			; kkybrd_get_bat_res
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_get_bat_res@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_get_bat_res@@YA_NXZ PROC			; kkybrd_get_bat_res, COMDAT

; 450  : 
; 451  : 	return _kkybrd_bat_res;

	mov	al, BYTE PTR __kkybrd_bat_res

; 452  : }

	ret	0
?kkybrd_get_bat_res@@YA_NXZ ENDP			; kkybrd_get_bat_res
_TEXT	ENDS
PUBLIC	?kkybrd_get_last_scan@@YAEXZ			; kkybrd_get_last_scan
_BSS	SEGMENT
	ALIGN	4

__scancode DB	01H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_get_last_scan@@YAEXZ
_TEXT	SEGMENT
?kkybrd_get_last_scan@@YAEXZ PROC			; kkybrd_get_last_scan, COMDAT

; 456  : 
; 457  : 	return _scancode;

	mov	al, BYTE PTR __scancode

; 458  : }

	ret	0
?kkybrd_get_last_scan@@YAEXZ ENDP			; kkybrd_get_last_scan
_TEXT	ENDS
PUBLIC	?kkybrd_set_leds@@YAX_N00@Z			; kkybrd_set_leds
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_set_leds@@YAX_N00@Z
_TEXT	SEGMENT
_data$ = 8						; size = 1
_num$ = 8						; size = 1
_caps$ = 12						; size = 1
_scroll$ = 16						; size = 1
?kkybrd_set_leds@@YAX_N00@Z PROC			; kkybrd_set_leds, COMDAT

; 462  : 
; 463  : 	uint8_t data = 0;
; 464  : 
; 465  : 	// set or clear the bit
; 466  : 	data = (scroll) ? (data | 1) : (data & 1);
; 467  : 	data = (num) ? (num | 2) : (num & 2);
; 468  : 	data = (caps) ? (num | 4) : (num & 4);

	cmp	BYTE PTR _caps$[esp-4], 0
	je	SHORT $LN7@kkybrd_set
	mov	al, BYTE PTR _num$[esp-4]
	or	al, 4
	mov	BYTE PTR _data$[esp-4], al
	jmp	SHORT $LL11@kkybrd_set
$LN7@kkybrd_set:
	mov	cl, BYTE PTR _num$[esp-4]
	and	cl, 4
	mov	BYTE PTR _data$[esp-4], cl
	npad	2

; 469  : 
; 470  : 	// send the command -- update keyboard Light Emetting Diods (LEDs)
; 471  : 	kybrd_enc_send_cmd (KYBRD_ENC_CMD_SET_LED);

$LL11@kkybrd_set:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL11@kkybrd_set
	push	237					; 000000edH
	push	96					; 00000060H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8
	npad	3

; 472  : 	kybrd_enc_send_cmd (data);

$LL18@kkybrd_set:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL18@kkybrd_set
	mov	edx, DWORD PTR _data$[esp-4]
	push	edx
	push	96					; 00000060H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 473  : }

	ret	0
?kkybrd_set_leds@@YAX_N00@Z ENDP			; kkybrd_set_leds
_TEXT	ENDS
PUBLIC	?kkybrd_discard_last_key@@YAXXZ			; kkybrd_discard_last_key
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_discard_last_key@@YAXXZ
_TEXT	SEGMENT
?kkybrd_discard_last_key@@YAXXZ PROC			; kkybrd_discard_last_key, COMDAT

; 495  : 
; 496  : 	_scancode = INVALID_SCANCODE;

	mov	BYTE PTR __scancode, 0

; 497  : }

	ret	0
?kkybrd_discard_last_key@@YAXXZ ENDP			; kkybrd_discard_last_key
_TEXT	ENDS
PUBLIC	?kkybrd_key_to_ascii@@YADW4KEYCODE@@@Z		; kkybrd_key_to_ascii
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_key_to_ascii@@YADW4KEYCODE@@@Z
_TEXT	SEGMENT
_code$ = 8						; size = 4
?kkybrd_key_to_ascii@@YADW4KEYCODE@@@Z PROC		; kkybrd_key_to_ascii, COMDAT

; 501  : 
; 502  : 	uint8_t key = code;

	mov	eax, DWORD PTR _code$[esp-4]

; 503  : 	if(code == KEY_UNKNOWN) return 0;

	cmp	eax, 16402				; 00004012H
	je	$LN32@kkybrd_key

; 504  : 
; 505  : 	// insure key is an ascii character
; 506  : 	if (isascii (key)) {

	cmp	al, 127					; 0000007fH
	ja	$LN32@kkybrd_key

; 507  : 
; 508  : 		// if shift key is down or caps lock is on, make the key uppercase
; 509  : 		if (_shift || _capslock)

	mov	cl, BYTE PTR __shift
	mov	dl, BYTE PTR __capslock
	test	cl, cl
	jne	SHORT $LN30@kkybrd_key
	test	dl, dl
	je	$LN34@kkybrd_key
$LN30@kkybrd_key:

; 510  : 			if (key >= 'a' && key <= 'z')

	cmp	al, 97					; 00000061H
	jb	SHORT $LN29@kkybrd_key
	cmp	al, 122					; 0000007aH
	ja	SHORT $LN29@kkybrd_key

; 511  : 				key -= 32;

	sub	al, 32					; 00000020H
$LN29@kkybrd_key:

; 512  : 
; 513  : 		if (_shift && !_capslock)

	test	cl, cl
	je	SHORT $LN34@kkybrd_key
	test	dl, dl
	jne	SHORT $LN34@kkybrd_key

; 514  : 			if (key >= '0' && key <= '9')

	lea	ecx, DWORD PTR [eax-48]
	cmp	cl, 9

; 515  : 				switch (key) {

	movzx	ecx, al
	ja	SHORT $LN27@kkybrd_key
	add	ecx, -48				; ffffffd0H
	cmp	ecx, 9
	ja	SHORT $LN34@kkybrd_key
	jmp	DWORD PTR $LN37@kkybrd_key[ecx*4]
$LN24@kkybrd_key:

; 516  : 
; 517  : 					case '0':
; 518  : 						key = KEY_RIGHTPARENTHESIS;

	mov	al, 41					; 00000029H

; 603  : }

	ret	0
$LN23@kkybrd_key:

; 519  : 						break;
; 520  : 					case '1':
; 521  : 						key = KEY_EXCLAMATION;

	mov	al, 33					; 00000021H

; 603  : }

	ret	0
$LN22@kkybrd_key:

; 522  : 						break;
; 523  : 					case '2':
; 524  : 						key = KEY_AT;

	mov	al, 64					; 00000040H

; 603  : }

	ret	0
$LN20@kkybrd_key:

; 525  : 						break;
; 526  : 					case '3':
; 527  : 						key = KEY_EXCLAMATION;
; 528  : 						break;
; 529  : 					case '4':
; 530  : 						key = KEY_HASH;

	mov	al, 35					; 00000023H

; 603  : }

	ret	0
$LN19@kkybrd_key:

; 531  : 						break;
; 532  : 					case '5':
; 533  : 						key = KEY_PERCENT;

	mov	al, 37					; 00000025H

; 603  : }

	ret	0
$LN18@kkybrd_key:

; 534  : 						break;
; 535  : 					case '6':
; 536  : 						key = KEY_CARRET;

	mov	al, 94					; 0000005eH

; 603  : }

	ret	0
$LN17@kkybrd_key:

; 537  : 						break;
; 538  : 					case '7':
; 539  : 						key = KEY_AMPERSAND;

	mov	al, 38					; 00000026H

; 603  : }

	ret	0
$LN16@kkybrd_key:

; 540  : 						break;
; 541  : 					case '8':
; 542  : 						key = KEY_ASTERISK;

	mov	al, 42					; 0000002aH

; 603  : }

	ret	0
$LN15@kkybrd_key:

; 543  : 						break;
; 544  : 					case '9':
; 545  : 						key = KEY_LEFTPARENTHESIS;

	mov	al, 40					; 00000028H

; 603  : }

	ret	0
$LN27@kkybrd_key:

; 546  : 						break;
; 547  : 				}
; 548  : 			else {
; 549  : 
; 550  : 				switch (key) {

	add	ecx, -39				; ffffffd9H
	cmp	ecx, 57					; 00000039H
	ja	SHORT $LN34@kkybrd_key
	movzx	edx, BYTE PTR $LN36@kkybrd_key[ecx]
	jmp	DWORD PTR $LN38@kkybrd_key[edx*4]
$LN11@kkybrd_key:

; 551  : 					case KEY_COMMA:
; 552  : 						key = KEY_LESS;

	mov	al, 60					; 0000003cH

; 603  : }

	ret	0
$LN10@kkybrd_key:

; 553  : 						break;
; 554  : 
; 555  : 					case KEY_DOT:
; 556  : 						key = KEY_GREATER;

	mov	al, 62					; 0000003eH

; 603  : }

	ret	0
$LN9@kkybrd_key:

; 557  : 						break;
; 558  : 
; 559  : 					case KEY_SLASH:
; 560  : 						key = KEY_QUESTION;

	mov	al, 63					; 0000003fH

; 603  : }

	ret	0
$LN8@kkybrd_key:

; 561  : 						break;
; 562  : 
; 563  : 					case KEY_SEMICOLON:
; 564  : 						key = KEY_COLON;

	mov	al, 58					; 0000003aH

; 603  : }

	ret	0
$LN7@kkybrd_key:

; 565  : 						break;
; 566  : 
; 567  : 					case KEY_QUOTE:
; 568  : 						key = KEY_QUOTEDOUBLE;

	mov	al, 34					; 00000022H

; 603  : }

	ret	0
$LN6@kkybrd_key:

; 569  : 						break;
; 570  : 
; 571  : 					case KEY_LEFTBRACKET :
; 572  : 						key = KEY_LEFTCURL;

	mov	al, 123					; 0000007bH

; 603  : }

	ret	0
$LN5@kkybrd_key:

; 573  : 						break;
; 574  : 
; 575  : 					case KEY_RIGHTBRACKET :
; 576  : 						key = KEY_RIGHTCURL;

	mov	al, 125					; 0000007dH

; 603  : }

	ret	0
$LN4@kkybrd_key:

; 577  : 						break;
; 578  : 
; 579  : 					case KEY_GRAVE:
; 580  : 						key = KEY_TILDE;

	mov	al, 126					; 0000007eH

; 603  : }

	ret	0
$LN3@kkybrd_key:

; 581  : 						break;
; 582  : 
; 583  : 					case KEY_MINUS:
; 584  : 						key = KEY_UNDERSCORE;

	mov	al, 95					; 0000005fH

; 603  : }

	ret	0
$LN2@kkybrd_key:

; 585  : 						break;
; 586  : 
; 587  : 					case KEY_PLUS:
; 588  : 						key = KEY_EQUAL;

	mov	al, 61					; 0000003dH

; 603  : }

	ret	0
$LN1@kkybrd_key:

; 589  : 						break;
; 590  : 
; 591  : 					case KEY_BACKSLASH:
; 592  : 						key = KEY_BAR;

	mov	al, 124					; 0000007cH

; 603  : }

	ret	0
$LN32@kkybrd_key:

; 593  : 						break;
; 594  : 				}
; 595  : 			}
; 596  : 
; 597  : 		// return the key
; 598  : 		return key;
; 599  : 	}
; 600  : 
; 601  : 	// scan code != a valid ascii char so no convertion is possible
; 602  : 	return 0;

	xor	al, al
$LN34@kkybrd_key:

; 603  : }

	ret	0
$LN37@kkybrd_key:
	DD	$LN24@kkybrd_key
	DD	$LN23@kkybrd_key
	DD	$LN22@kkybrd_key
	DD	$LN23@kkybrd_key
	DD	$LN20@kkybrd_key
	DD	$LN19@kkybrd_key
	DD	$LN18@kkybrd_key
	DD	$LN17@kkybrd_key
	DD	$LN16@kkybrd_key
	DD	$LN15@kkybrd_key
$LN38@kkybrd_key:
	DD	$LN7@kkybrd_key
	DD	$LN2@kkybrd_key
	DD	$LN11@kkybrd_key
	DD	$LN3@kkybrd_key
	DD	$LN10@kkybrd_key
	DD	$LN9@kkybrd_key
	DD	$LN8@kkybrd_key
	DD	$LN6@kkybrd_key
	DD	$LN1@kkybrd_key
	DD	$LN5@kkybrd_key
	DD	$LN4@kkybrd_key
	DD	$LN34@kkybrd_key
$LN36@kkybrd_key:
	DB	0
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	1
	DB	2
	DB	3
	DB	4
	DB	5
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	6
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	7
	DB	8
	DB	9
	DB	11					; 0000000bH
	DB	11					; 0000000bH
	DB	10					; 0000000aH
?kkybrd_key_to_ascii@@YADW4KEYCODE@@@Z ENDP		; kkybrd_key_to_ascii
_TEXT	ENDS
PUBLIC	?kkybrd_disable@@YAXXZ				; kkybrd_disable
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_disable@@YAXXZ
_TEXT	SEGMENT
?kkybrd_disable@@YAXXZ PROC				; kkybrd_disable, COMDAT

; 607  : 
; 608  : 	kybrd_ctrl_send_cmd (KYBRD_CTRL_CMD_DISABLE);

$LL5@kkybrd_dis:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL5@kkybrd_dis
	push	173					; 000000adH
	push	100					; 00000064H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 609  : 	_kkybrd_disable = true;

	mov	BYTE PTR __kkybrd_disable, 1

; 610  : }

	ret	0
?kkybrd_disable@@YAXXZ ENDP				; kkybrd_disable
_TEXT	ENDS
PUBLIC	?kkybrd_enable@@YAXXZ				; kkybrd_enable
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_enable@@YAXXZ
_TEXT	SEGMENT
?kkybrd_enable@@YAXXZ PROC				; kkybrd_enable, COMDAT

; 614  : 
; 615  : 	kybrd_ctrl_send_cmd (KYBRD_CTRL_CMD_ENABLE);

$LL5@kkybrd_ena:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL5@kkybrd_ena
	push	174					; 000000aeH
	push	100					; 00000064H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 616  : 	_kkybrd_disable = false;

	mov	BYTE PTR __kkybrd_disable, 0

; 617  : }

	ret	0
?kkybrd_enable@@YAXXZ ENDP				; kkybrd_enable
_TEXT	ENDS
PUBLIC	?kkybrd_is_disabled@@YA_NXZ			; kkybrd_is_disabled
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_is_disabled@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_is_disabled@@YA_NXZ PROC			; kkybrd_is_disabled, COMDAT

; 621  : 
; 622  : 	return _kkybrd_disable;

	mov	al, BYTE PTR __kkybrd_disable

; 623  : }

	ret	0
?kkybrd_is_disabled@@YA_NXZ ENDP			; kkybrd_is_disabled
_TEXT	ENDS
PUBLIC	?kkybrd_reset_system@@YAXXZ			; kkybrd_reset_system
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_reset_system@@YAXXZ
_TEXT	SEGMENT
?kkybrd_reset_system@@YAXXZ PROC			; kkybrd_reset_system, COMDAT

; 627  : 
; 628  : 	// writes 11111110 to the output port (sets reset system line low)
; 629  : 	kybrd_ctrl_send_cmd (KYBRD_CTRL_CMD_WRITE_OUT_PORT);

$LL5@kkybrd_res:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL5@kkybrd_res
	push	209					; 000000d1H
	push	100					; 00000064H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8
	npad	3

; 630  : 	kybrd_enc_send_cmd (0xfe);

$LL12@kkybrd_res:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL12@kkybrd_res
	push	254					; 000000feH
	push	96					; 00000060H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 631  : }

	ret	0
?kkybrd_reset_system@@YAXXZ ENDP			; kkybrd_reset_system
_TEXT	ENDS
PUBLIC	?kkybrd_self_test@@YA_NXZ			; kkybrd_self_test
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_self_test@@YA_NXZ
_TEXT	SEGMENT
?kkybrd_self_test@@YA_NXZ PROC				; kkybrd_self_test, COMDAT

; 635  : 
; 636  : 	// send command
; 637  : 	kybrd_ctrl_send_cmd (KYBRD_CTRL_CMD_SELF_TEST);

$LL8@kkybrd_sel:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL8@kkybrd_sel
	push	170					; 000000aaH
	push	100					; 00000064H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8
	npad	3
$LL3@kkybrd_sel:

; 638  : 
; 639  : 	// wait for output buffer to be full
; 640  : 	while (1)
; 641  : 		if (kybrd_ctrl_read_status () & KYBRD_CTRL_STATS_MASK_OUT_BUF)

	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 1
	je	SHORT $LL3@kkybrd_sel

; 642  : 			break;
; 643  : 
; 644  : 	// if output buffer == 0x55, test passed
; 645  : 	return (kybrd_enc_read_buf () == 0x55) ? true : false;

	push	96					; 00000060H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	cmp	al, 85					; 00000055H
	sete	al

; 646  : }

	ret	0
?kkybrd_self_test@@YA_NXZ ENDP				; kkybrd_self_test
_TEXT	ENDS
PUBLIC	?kkybrd_read_key@@YAXXZ				; kkybrd_read_key
;	COMDAT ?_extended@?1??kkybrd_read_key@@YAXXZ@4_NA
_BSS	SEGMENT
?_extended@?1??kkybrd_read_key@@YAXXZ@4_NA DB 01H DUP (?) ; `kkybrd_read_key'::`2'::_extended
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_read_key@@YAXXZ
_TEXT	SEGMENT
?kkybrd_read_key@@YAXXZ PROC				; kkybrd_read_key, COMDAT

; 255  : 	
; 256  : 	static bool _extended = false;
; 257  : 
; 258  : 	int code = 0;
; 259  : 
; 260  : 	// read scan code only if the kkybrd controller output buffer is full (scan code is in it)
; 261  : 	if (kybrd_ctrl_read_status () & KYBRD_CTRL_STATS_MASK_OUT_BUF) {

	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 1
	je	$LN4@kkybrd_rea

; 262  : 
; 263  : 		// read the scan code
; 264  : 		code = kybrd_enc_read_buf ();

	push	ebx
	push	96					; 00000060H
	call	?inport@@YAEG@Z				; inport
	movzx	ebx, al
	add	esp, 4

; 265  : 
; 266  : 		// is this an extended code? If so, set it and return
; 267  : 		if (code == 0xE0 || code == 0xE1)

	cmp	ebx, 224				; 000000e0H
	je	$LN22@kkybrd_rea
	cmp	ebx, 225				; 000000e1H
	je	$LN22@kkybrd_rea

; 269  : 		else {
; 270  : 
; 271  : 			// either the second byte of an extended scan code or a single byte scan code
; 272  : 			_extended = false;

	mov	BYTE PTR ?_extended@?1??kkybrd_read_key@@YAXXZ@4_NA, 0

; 273  : 
; 274  : 			// test if this is a break code (Original XT Scan Code Set specific)
; 275  : 			if (code & 0x80) {	//test bit 7

	test	bl, bl
	jns	SHORT $LN20@kkybrd_rea

; 276  : 
; 277  : 				// covert the break code into its make code equivelant
; 278  : 				code -= 0x80;
; 279  : 
; 280  : 				// grab the key
; 281  : 				int key = _kkybrd_scancode_std [code];
; 282  : 
; 283  : 				// test if a special key has been released & set it
; 284  : 				switch (key) {

	mov	eax, DWORD PTR __kkybrd_scancode_std[ebx*4-512]
	add	ebx, -128				; ffffff80H
	add	eax, -16386				; ffffbffeH
	cmp	eax, 6
	ja	$LN12@kkybrd_rea
	jmp	DWORD PTR $LN34@kkybrd_rea[eax*4]
$LN17@kkybrd_rea:

; 285  : 
; 286  : 					case KEY_LCTRL:
; 287  : 					case KEY_RCTRL:
; 288  : 						_ctrl = false;

	mov	BYTE PTR __ctrl, 0

; 289  : 						break;

	jmp	$LN12@kkybrd_rea
$LN16@kkybrd_rea:

; 290  : 
; 291  : 					case KEY_LSHIFT:
; 292  : 					case KEY_RSHIFT:
; 293  : 						_shift = false;

	mov	BYTE PTR __shift, 0

; 294  : 						break;

	jmp	$LN12@kkybrd_rea
$LN15@kkybrd_rea:

; 295  : 
; 296  : 					case KEY_LALT:
; 297  : 					case KEY_RALT:
; 298  : 						_alt = false;

	mov	BYTE PTR __alt, 0

; 299  : 						break;
; 300  : 				}
; 301  : 			}
; 302  : 			else {

	jmp	$LN12@kkybrd_rea
$LN20@kkybrd_rea:

; 303  : 
; 304  : 				// this is a make code - set the scan code
; 305  : 				_scancode = code;
; 306  : 				//fifo_write(&FIFO, &_scancode, sizeof(_scancode));
; 307  : 
; 308  : 				// grab the key
; 309  : 				int key = _kkybrd_scancode_std [code];

	mov	eax, DWORD PTR __kkybrd_scancode_std[ebx*4]
	mov	BYTE PTR __scancode, bl

; 310  : 
; 311  : 				// test if user is holding down any special keys & set it
; 312  : 				switch (key) {

	cmp	eax, 16385				; 00004001H
	jg	SHORT $LN27@kkybrd_rea
	je	SHORT $LN8@kkybrd_rea
	cmp	eax, 12303				; 0000300fH
	jne	$LN12@kkybrd_rea

; 333  : 
; 334  : 					case KEY_KP_NUMLOCK:
; 335  : 						_numlock = (_numlock) ? false : true;

	cmp	BYTE PTR __numlock, 0

; 336  : 						kkybrd_set_leds (_numlock, _capslock, _scrolllock);

	movzx	ecx, BYTE PTR __scrolllock
	movzx	edx, BYTE PTR __capslock
	sete	al
	mov	BYTE PTR __numlock, al
	push	ecx
	movzx	eax, al
	push	edx
	push	eax
	call	?kkybrd_set_leds@@YAX_N00@Z		; kkybrd_set_leds
	add	esp, 12					; 0000000cH

; 337  : 						break;

	jmp	$LN12@kkybrd_rea
$LN8@kkybrd_rea:

; 328  : 
; 329  : 					case KEY_CAPSLOCK:
; 330  : 						_capslock = (_capslock) ? false : true;

	cmp	BYTE PTR __capslock, 0

; 331  : 						kkybrd_set_leds (_numlock, _capslock, _scrolllock);

	movzx	ecx, BYTE PTR __scrolllock
	sete	al
	movzx	edx, al
	mov	BYTE PTR __capslock, al
	movzx	eax, BYTE PTR __numlock
	push	ecx
	push	edx
	push	eax
	call	?kkybrd_set_leds@@YAX_N00@Z		; kkybrd_set_leds
	add	esp, 12					; 0000000cH

; 332  : 						break;

	jmp	SHORT $LN12@kkybrd_rea
$LN27@kkybrd_rea:

; 310  : 
; 311  : 				// test if user is holding down any special keys & set it
; 312  : 				switch (key) {

	sub	eax, 16386				; 00004002H
	cmp	eax, 14					; 0000000eH
	ja	SHORT $LN12@kkybrd_rea
	movzx	ecx, BYTE PTR $LN32@kkybrd_rea[eax]
	jmp	DWORD PTR $LN35@kkybrd_rea[ecx*4]
$LN11@kkybrd_rea:

; 313  : 
; 314  : 					case KEY_LCTRL:
; 315  : 					case KEY_RCTRL:
; 316  : 						_ctrl = true;

	mov	BYTE PTR __ctrl, 1

; 317  : 						break;

	jmp	SHORT $LN12@kkybrd_rea
$LN10@kkybrd_rea:

; 318  : 
; 319  : 					case KEY_LSHIFT:
; 320  : 					case KEY_RSHIFT:
; 321  : 						_shift = true;

	mov	BYTE PTR __shift, 1

; 322  : 						break;

	jmp	SHORT $LN12@kkybrd_rea
$LN9@kkybrd_rea:

; 323  : 
; 324  : 					case KEY_LALT:
; 325  : 					case KEY_RALT:
; 326  : 						_alt = true;

	mov	BYTE PTR __alt, 1

; 327  : 						break;

	jmp	SHORT $LN12@kkybrd_rea
$LN6@kkybrd_rea:

; 338  : 
; 339  : 					case KEY_SCROLLLOCK:
; 340  : 						_scrolllock = (_scrolllock) ? false : true;

	cmp	BYTE PTR __scrolllock, 0

; 341  : 						kkybrd_set_leds (_numlock, _capslock, _scrolllock);

	movzx	ecx, BYTE PTR __numlock
	sete	al
	movzx	edx, al
	mov	BYTE PTR __scrolllock, al
	movzx	eax, BYTE PTR __capslock
	push	edx
	push	eax
	push	ecx
	call	?kkybrd_set_leds@@YAX_N00@Z		; kkybrd_set_leds
	add	esp, 12					; 0000000cH

; 342  : 						break;

	jmp	SHORT $LN12@kkybrd_rea
$LN22@kkybrd_rea:

; 268  : 			_extended = true;

	mov	BYTE PTR ?_extended@?1??kkybrd_read_key@@YAXXZ@4_NA, 1
$LN12@kkybrd_rea:

; 343  : 				}
; 344  : 			}
; 345  : 		}
; 346  : 
; 347  : 		// watch for errors
; 348  : 		switch (code) {

	sub	ebx, 252				; 000000fcH
	je	SHORT $LN3@kkybrd_rea
	dec	ebx
	je	SHORT $LN2@kkybrd_rea
	dec	ebx
	jne	SHORT $LN33@kkybrd_rea

; 356  : 				break;
; 357  : 
; 358  : 			case KYBRD_ERR_RESEND_CMD:
; 359  : 				_kkybrd_resend_res = true;

	mov	BYTE PTR __kkybrd_resend_res, 1
	pop	ebx

; 360  : 				break;
; 361  : 		}
; 362  : 	}
; 363  : }

	ret	0
$LN2@kkybrd_rea:

; 352  : 				break;
; 353  : 
; 354  : 			case KYBRD_ERR_DIAG_FAILED:
; 355  : 				_kkybrd_diag_res = false;

	mov	BYTE PTR __kkybrd_diag_res, 0
	pop	ebx

; 360  : 				break;
; 361  : 		}
; 362  : 	}
; 363  : }

	ret	0
$LN3@kkybrd_rea:

; 349  : 
; 350  : 			case KYBRD_ERR_BAT_FAILED:
; 351  : 				_kkybrd_bat_res = false;

	mov	BYTE PTR __kkybrd_bat_res, 0
$LN33@kkybrd_rea:
	pop	ebx
$LN4@kkybrd_rea:

; 360  : 				break;
; 361  : 		}
; 362  : 	}
; 363  : }

	ret	0
$LN34@kkybrd_rea:
	DD	$LN16@kkybrd_rea
	DD	$LN17@kkybrd_rea
	DD	$LN15@kkybrd_rea
	DD	$LN12@kkybrd_rea
	DD	$LN16@kkybrd_rea
	DD	$LN17@kkybrd_rea
	DD	$LN15@kkybrd_rea
$LN35@kkybrd_rea:
	DD	$LN10@kkybrd_rea
	DD	$LN11@kkybrd_rea
	DD	$LN9@kkybrd_rea
	DD	$LN6@kkybrd_rea
	DD	$LN12@kkybrd_rea
$LN32@kkybrd_rea:
	DB	0
	DB	1
	DB	2
	DB	4
	DB	0
	DB	1
	DB	2
	DB	4
	DB	4
	DB	4
	DB	4
	DB	4
	DB	4
	DB	4
	DB	3
?kkybrd_read_key@@YAXXZ ENDP				; kkybrd_read_key
_TEXT	ENDS
PUBLIC	?i86_kybrd_irq@@YAXXZ				; i86_kybrd_irq
EXTRN	?interruptdone@@YAXI@Z:PROC			; interruptdone
; Function compile flags: /Ogtpy
;	COMDAT ?i86_kybrd_irq@@YAXXZ
_TEXT	SEGMENT
?i86_kybrd_irq@@YAXXZ PROC				; i86_kybrd_irq, COMDAT

; 366  : void _cdecl i86_kybrd_irq () {

	push	ebx
	push	esi
	push	edi

; 367  : 
; 368  : 	_asm add esp, 12

	add	esp, 12					; 0000000cH

; 369  : 	_asm pushad

	pushad

; 370  : 	_asm cli

	cli

; 371  : 
; 372  : 	//DebugPrintf("kbIRQ");
; 373  : 
; 374  : 	kkybrd_read_key();

	call	?kkybrd_read_key@@YAXXZ			; kkybrd_read_key

; 375  : 
; 376  : 	/*_buffer[_bufferp] = _scancode;
; 377  : 	_bufferp --;
; 378  : 	_buffernum ++;*/
; 379  : 	//if(_scancode != 0 && _scancode != INVALID_SCANCODE) {
; 380  : 	//	char k = 0;
; 381  : 	/*	fifo_read(&FIFO, &k, 1);
; 382  : 		DebugPrintf("\nPut 0x%x to FIFO, reread: 0x%x", _scancode, k);
; 383  : 	}*/
; 384  : 
; 385  : 	// tell hal we are done
; 386  : 	interruptdone(0);

	push	0
	call	?interruptdone@@YAXI@Z			; interruptdone
	add	esp, 4

; 387  : 
; 388  : 	// return from interrupt handler
; 389  : 	_asm sti

	sti

; 390  : 	_asm popad

	popad

; 391  : 	_asm iretd

	iretd

; 392  : }

	pop	edi
	pop	esi
	pop	ebx
	ret	0
?i86_kybrd_irq@@YAXXZ ENDP				; i86_kybrd_irq
_TEXT	ENDS
PUBLIC	?kkybrd_get_last_key@@YA?AW4KEYCODE@@XZ		; kkybrd_get_last_key
; Function compile flags: /Ogtpy
;	COMDAT ?kkybrd_get_last_key@@YA?AW4KEYCODE@@XZ
_TEXT	SEGMENT
?kkybrd_get_last_key@@YA?AW4KEYCODE@@XZ PROC		; kkybrd_get_last_key, COMDAT

; 477  : 
; 478  : 	/*if(_bufferp>0) {
; 479  : 		return ((KEYCODE)_kkybrd_scancode_std [_buffer[_bufferp--]]);
; 480  : 	}
; 481  : 	return KEY_UNKNOWN;*/
; 482  : 	//char r = 0;
; 483  : 	/*fifo_read(&FIFO, &_scancode, sizeof(_scancode));
; 484  : 	char _r = kybrd_enc_read_buf();
; 485  : 	_scancode = _r;*/
; 486  : 	kkybrd_read_key();

	call	?kkybrd_read_key@@YAXXZ			; kkybrd_read_key

; 487  : 	//fifo_write(&FIFO, &_r, sizeof(_r));
; 488  : 	//if(_scancode != 0)DebugPrintf("0x%X", _scancode);
; 489  : 	//fifo_write(&FIFO, _buf, inport(0x60));
; 490  : 	return (_scancode!=INVALID_SCANCODE) ? ((KEYCODE)_kkybrd_scancode_std[_scancode]) : (KEY_UNKNOWN);

	mov	al, BYTE PTR __scancode
	test	al, al
	je	SHORT $LN3@kkybrd_get
	movsx	eax, al
	mov	eax, DWORD PTR __kkybrd_scancode_std[eax*4]

; 491  : }

	ret	0
$LN3@kkybrd_get:

; 487  : 	//fifo_write(&FIFO, &_r, sizeof(_r));
; 488  : 	//if(_scancode != 0)DebugPrintf("0x%X", _scancode);
; 489  : 	//fifo_write(&FIFO, _buf, inport(0x60));
; 490  : 	return (_scancode!=INVALID_SCANCODE) ? ((KEYCODE)_kkybrd_scancode_std[_scancode]) : (KEY_UNKNOWN);

	mov	eax, 16402				; 00004012H

; 491  : }

	ret	0
?kkybrd_get_last_key@@YA?AW4KEYCODE@@XZ ENDP		; kkybrd_get_last_key
_TEXT	ENDS
PUBLIC	?kkybrd_install@@YAXH@Z				; kkybrd_install
EXTRN	?setint@@YAXHP6AXXZ@Z:PROC			; setint
EXTRN	?fifo_init@@YAXPAUfifo_t@@PADH@Z:PROC		; fifo_init
_BSS	SEGMENT
	ALIGN	4

_FIFO	DB	010H DUP (?)
__buf	DB	0200H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?kkybrd_install@@YAXH@Z
_TEXT	SEGMENT
_irq$ = 8						; size = 4
?kkybrd_install@@YAXH@Z PROC				; kkybrd_install, COMDAT

; 649  : void kkybrd_install (int irq) {

	push	ebx

; 650  : 
; 651  : 	fifo_init(&FIFO, _buf, 512);

	push	512					; 00000200H
	push	OFFSET __buf
	push	OFFSET _FIFO
	call	?fifo_init@@YAXPAUfifo_t@@PADH@Z	; fifo_init

; 652  : 
; 653  : 	// Install our interrupt handler (irq 1 uses interrupt 33)
; 654  : 	setint (irq, i86_kybrd_irq);

	mov	eax, DWORD PTR _irq$[esp+12]
	push	OFFSET ?i86_kybrd_irq@@YAXXZ		; i86_kybrd_irq
	push	eax
	call	?setint@@YAXHP6AXXZ@Z			; setint
	add	esp, 20					; 00000014H

; 655  : 
; 656  : 	// assume BAT test is good. If there is a problem, the IRQ handler where catch the error
; 657  : 	_kkybrd_bat_res = true;
; 658  : 	_scancode = 0;

	xor	ebx, ebx
	mov	BYTE PTR __kkybrd_bat_res, 1
	mov	BYTE PTR __scancode, bl

; 659  : 
; 660  : 	// set lock keys and led lights
; 661  : 	_numlock = _scrolllock = _capslock = false;

	mov	BYTE PTR __capslock, bl
	mov	BYTE PTR __scrolllock, bl
	mov	BYTE PTR __numlock, bl

; 662  : 	kkybrd_set_leds (false, false, false);

$LL13@kkybrd_ins:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL13@kkybrd_ins
	push	237					; 000000edH
	push	96					; 00000060H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8
$LL20@kkybrd_ins:
	push	100					; 00000064H
	call	?inport@@YAEG@Z				; inport
	add	esp, 4
	test	al, 2
	jne	SHORT $LL20@kkybrd_ins
	push	ebx
	push	96					; 00000060H
	call	?outport@@YAXGE@Z			; outport
	add	esp, 8

; 663  : 
; 664  : 	// shift, ctrl, and alt keys
; 665  : 	_shift = _alt = _ctrl = false;

	mov	BYTE PTR __ctrl, bl
	mov	BYTE PTR __alt, bl
	mov	BYTE PTR __shift, bl
	pop	ebx

; 666  : }

	ret	0
?kkybrd_install@@YAXH@Z ENDP				; kkybrd_install
_TEXT	ENDS
END
