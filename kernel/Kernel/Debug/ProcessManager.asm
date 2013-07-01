; Listing generated by Microsoft (R) Optimizing Compiler Version 16.00.30319.01 

	TITLE	C:\Dev\LevOS\kernel\Kernel\ProcessManager.cpp
	.686P
	.XMM
	include listing.inc
	.model	flat

INCLUDELIB MSVCRT
INCLUDELIB OLDNAMES

_BSS	SEGMENT
_numberOfProcesses DD 01H DUP (?)
_currentProcessId DD 01H DUP (?)
__ism	DB	01H DUP (?)
	ALIGN	4

_kEBP	DD	01H DUP (?)
_kESP	DD	01H DUP (?)
_BSS	ENDS
PUBLIC	?saveKernelStack@@YAXXZ				; saveKernelStack
; Function compile flags: /Ogtp
; File c:\dev\levos\kernel\kernel\processmanager.cpp
;	COMDAT ?saveKernelStack@@YAXXZ
_TEXT	SEGMENT
?saveKernelStack@@YAXXZ PROC				; saveKernelStack, COMDAT

; 19   : 	_asm mov kEBP, ebp

	mov	DWORD PTR _kEBP, ebp

; 20   : 	_asm mov kESP, esp

	mov	DWORD PTR _kESP, esp

; 21   : }

	ret	0
?saveKernelStack@@YAXXZ ENDP				; saveKernelStack
_TEXT	ENDS
PUBLIC	?restoreKernelStack@@YAXXZ			; restoreKernelStack
; Function compile flags: /Ogtpy
;	COMDAT ?restoreKernelStack@@YAXXZ
_TEXT	SEGMENT
?restoreKernelStack@@YAXXZ PROC				; restoreKernelStack, COMDAT

; 25   : 	_asm mov ebp, kEBP

	mov	ebp, DWORD PTR _kEBP

; 26   : 	_asm mov esp, kESP

	mov	esp, DWORD PTR _kESP

; 27   : }

	ret	0
?restoreKernelStack@@YAXXZ ENDP				; restoreKernelStack
_TEXT	ENDS
PUBLIC	?getCurrentProc@@YA?AU__PROCESS@@XZ		; getCurrentProc
_BSS	SEGMENT
__currentP DB	01aH DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?getCurrentProc@@YA?AU__PROCESS@@XZ
_TEXT	SEGMENT
$T2887 = 8						; size = 4
?getCurrentProc@@YA?AU__PROCESS@@XZ PROC		; getCurrentProc, COMDAT

; 31   : 	return _currentP;

	mov	eax, DWORD PTR $T2887[esp-4]
	push	esi
	push	edi
	mov	ecx, 6
	mov	esi, OFFSET __currentP
	mov	edi, eax
	rep movsd
	movsw
	pop	edi
	pop	esi

; 32   : }

	ret	0
?getCurrentProc@@YA?AU__PROCESS@@XZ ENDP		; getCurrentProc
_TEXT	ENDS
PUBLIC	?setCurrentProc@@YAXU__PROCESS@@@Z		; setCurrentProc
; Function compile flags: /Ogtpy
;	COMDAT ?setCurrentProc@@YAXU__PROCESS@@@Z
_TEXT	SEGMENT
_p$ = 8							; size = 26
?setCurrentProc@@YAXU__PROCESS@@@Z PROC			; setCurrentProc, COMDAT

; 34   : {

	push	esi
	push	edi

; 35   : 	_currentP = p;

	mov	ecx, 6
	lea	esi, DWORD PTR _p$[esp+4]
	mov	edi, OFFSET __currentP
	rep movsd
	movsw
	pop	edi
	pop	esi

; 36   : }

	ret	0
?setCurrentProc@@YAXU__PROCESS@@@Z ENDP			; setCurrentProc
_TEXT	ENDS
PUBLIC	?addProcess@@YAXU__PROCESS@@@Z			; addProcess
_BSS	SEGMENT
	ALIGN	4

_processList DB	0d0H DUP (?)
; Function compile flags: /Ogtpy
_BSS	ENDS
;	COMDAT ?addProcess@@YAXU__PROCESS@@@Z
_TEXT	SEGMENT
_p$ = 8							; size = 26
?addProcess@@YAXU__PROCESS@@@Z PROC			; addProcess, COMDAT

; 40   : 	if(p.pid >= MAX_NUMBER_OF_PROCESSES) return;

	mov	al, BYTE PTR _p$[esp-4]
	cmp	al, 8
	jae	SHORT $LN2@addProcess

; 41   : 	//DebugPrintf("adding process");
; 42   : 	processList[p.pid] = p;

	push	esi
	push	edi
	movzx	edi, al
	imul	edi, 26					; 0000001aH
	add	edi, OFFSET _processList

; 43   : 	numberOfProcesses++;

	inc	DWORD PTR _numberOfProcesses
	mov	ecx, 6
	lea	esi, DWORD PTR _p$[esp+4]
	rep movsd
	movsw
	pop	edi
	pop	esi
$LN2@addProcess:

; 44   : }

	ret	0
?addProcess@@YAXU__PROCESS@@@Z ENDP			; addProcess
_TEXT	ENDS
PUBLIC	?startMultitask@@YAXXZ				; startMultitask
; Function compile flags: /Ogtpy
;	COMDAT ?startMultitask@@YAXXZ
_TEXT	SEGMENT
?startMultitask@@YAXXZ PROC				; startMultitask, COMDAT

; 48   : 	_ism = true;

	mov	BYTE PTR __ism, 1

; 49   : }

	ret	0
?startMultitask@@YAXXZ ENDP				; startMultitask
_TEXT	ENDS
PUBLIC	?switchTasks@@YAXH@Z				; switchTasks
; Function compile flags: /Ogtpy
;	COMDAT ?switchTasks@@YAXH@Z
_TEXT	SEGMENT
_eip$ = 8						; size = 4
?switchTasks@@YAXH@Z PROC				; switchTasks, COMDAT

; 53   : 	//_asm cli
; 54   : 	//if(!_ism)return;
; 55   : 	//DebugPrintf("EIP=0x%x\n", eip);
; 56   : 	//return;
; 57   : 	return;
; 58   : 	if(numberOfProcesses<=1)return;
; 59   : 	_currentP = processList[0];
; 60   : 	_asm xchg bx, bx
; 61   : 	// first step, save registers!
; 62   : 	_currentP.regs->eip = eip;
; 63   : 	int d = 0;
; 64   : 	_asm mov d, eax
; 65   : 	_currentP.regs->eax = d;
; 66   : 	_asm mov d, ebx
; 67   : 	_currentP.regs->ebx = d;
; 68   : 	_asm mov d, ecx
; 69   : 	_currentP.regs->ecx = d;
; 70   : 	_asm mov d, edx
; 71   : 	_currentP.regs->edx = d;
; 72   : 	_asm mov d, esi
; 73   : 	_currentP.regs->esi = d;
; 74   : 	_asm mov d, edi
; 75   : 	_currentP.regs->edi = d;
; 76   : 	//second step, save stack 
; 77   : 	_asm mov d, ebp
; 78   : 	_currentP.regs->esp = d;
; 79   : 	_currentP.stackBase = (unsigned char*)d;
; 80   : 	_asm mov d, esp
; 81   : 	_currentP.stackPointer = (unsigned char*)d;
; 82   : 	_currentP.regs->esp = d;
; 83   : 	// now that we have saved the process, lets setup the enviroment for the next process
; 84   : 	processList[currentProcessId] = _currentP;
; 85   : 	currentProcessId = (currentProcessId + 1)%numberOfProcesses;
; 86   : 	_currentP = processList[currentProcessId];
; 87   : 	// restore their registers
; 88   : 	d = _currentP.regs->eax;
; 89   : 	_asm mov eax, d
; 90   : 	d = _currentP.regs->ebx;
; 91   : 	_asm mov ebx, d
; 92   : 	d = _currentP.regs->ecx;
; 93   : 	_asm mov ecx, d
; 94   : 	d = _currentP.regs->edx;
; 95   : 	_asm mov edx, d
; 96   : 	d = _currentP.regs->esi;
; 97   : 	_asm mov esi, d
; 98   : 	d = _currentP.regs->edi;
; 99   : 	_asm mov edi, d
; 100  : 	//d = _currentP.regs->ebp;
; 101  : 	// restore their stack!
; 102  : 	//_asm mov ebp, d
; 103  : 	//d = _currentP.regs->esp;
; 104  : 	//_asm mov esp, d
; 105  : 	d = _currentP.regs->eip;
; 106  : 	_asm mov eax, d
; 107  : 	//_asm sti
; 108  : 	interruptdone(0);
; 109  : 	_asm pushfd
; 110  : 	_asm push cs
; 111  : 	_asm push eax
; 112  : 	_asm iret
; 113  : }

	ret	0
?switchTasks@@YAXH@Z ENDP				; switchTasks
_TEXT	ENDS
END
