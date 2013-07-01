bits	16
org 0x500
jmp	main				; go to start

%include "stdio.asm"
%include "video.asm"			; basic i/o routines
%include "GDT.asm"			; Gdt routines
%include "FAT12.asm"			; FAT12 driver
%include "Memory.asm"			; Memory Map and such!


LoadingMsg db 0x0D, 0x0A, "Loading LevOS Kernel...", 0x00
msgFailure db 0x0D, 0x0A, "*** FATAL: MISSING OR CURRUPT KRNL32.EXE. Press Any Key to Reboot", 0x0D, 0x0A, 0x0A, 0x00
msgTest db "Testing", 0

ImageName db "KRNL32  EXE"
ImageSize db 0

main:
	cli				; clear interrupts
	xor	ax, ax			; null segments
	mov	ds, ax
	mov	es, ax
	mov	ax, 0x0			; stack begins at 0x9000-0xffff
	mov	ss, ax
	mov	sp, 0xFFFF
	sti				; enable interrupts
	;mov     [boot_info+multiboot_info.bootDevice], dl
	call	InstallGDT		; install our GDT


	mov	al, 2	; set bit 2 (enable a20)
	out	0x92, al

	mov		eax, 0x0
	mov		ds, ax
	mov		di, 0x1000
	call	BiosGetMemoryMap

	mov		word [0x2000], bx
	mov		word [0x200A], ax
	
	mov	si, LoadingMsg
	call	Print
	
	; get font
	;mov ah, 10h ; function=read character map
	;xor al, al
	;int 10h ; bios video
	; es:bx = font
	mov [0x1990], es
	mov [0x199F], bx ; save them

	call	LoadRoot		; Load root directory table
	
	mov si, msgTest
	call Print
	;dies after
	mov	ebx, 0			; BX:BP points to buffer to load to
	mov	bp, 0x3000
	mov	si, ImageName		; our file to load
	call	LoadFile		; load our file
	mov	dword [ImageSize], ecx	; save size of kernel
	cmp	ax, 0			; Test for success
	je	EnterStage3		; yep--onto Stage 3!
	mov	si, msgFailure		; Nope--print error
	call	Print
	mov	ah, 0
	int     0x16                    ; await keypress
	int     0x19                    ; warm boot computer
	cli				; If we get here, something really went wong
	hlt

EnterStage3:
	
	cli				; clear interrupts
	mov	eax, cr0		; set bit 0 in cr0--enter pmode
	or	eax, 1
	mov	cr0, eax
	

	jmp	0x8:Stage3	; far jump to fix CS

bits 32

%include "paging.asm"			; higher half kernel:)

BadImage db "*** FATAL: Invalid KRNL. Halting system.", 0
msgPaging db "Paging enabled", 0

Stage3:


	mov	ax, 0x10	; set data segments to data selector (0x10)
	cmp edx, 0x1337 ; => we are returning to real mode!
	je returning
	mov	ds, ax
	mov	ss, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	esp, 90000h		; stack begins from 90000h
	
	;mov si, msgTest
	;call Print
	
	call	ClrScr
	
	;mov si, msgTest
	;call Print
	
	call EnablePaging
	
	;mov si, msgPaging
	;call Print

CopyImage:
  	 mov	eax, dword [ImageSize]
  	 movzx	ebx, word [bpbBytesPerSector]
  	 mul	ebx
  	 mov	ebx, 4
  	 div	ebx
   	 cld
   	 mov    esi, 0x3000
   	 mov	edi, 0xC0000000	; newaddr
   	 mov	ecx, eax
   	 rep	movsd                   ; copy image to its protected mode address

TestImage:
  	  mov    ebx, [0xC0000000+60] ; newaddr
  	  add    ebx, 0xC0000000   ; ebx now points to file sig (PE00) newaddr
  	  mov    esi, ebx
  	  mov    edi, ImageSig
  	  cmpsw
  	  je     EXECUTE
  	  mov	ebx, BadImage
  	  call	Puts
  	  cli
  	  hlt

ImageSig db 'PE'

EXECUTE:
	add		ebx, 24
	mov		eax, [ebx]			; _IMAGE_FILE_HEADER is 20 bytes + size of sig (4 bytes)
	add		ebx, 20-4			; address of entry point
	mov		ebp, dword [ebx]		; get entry point offset in code section	
	add		ebx, 12				; image base is offset 8 bytes from entry point
	mov		eax, dword [ebx]		; add image base
	add		ebp, eax
	cli
	
	mov	eax, 0x2BADB002		; multiboot specs say eax should be this
	mov	ebx, 0
	mov	edx, [ImageSize]
 
	;mov [0x1990], edx
	
	mov edx, 0x1337
	;jmp 0xC0001000
	call		ebp               	      ; Execute Kernel

    cli
	hlt
	
bits 16
; returning to REAL MODE!
returning:
	cli
	hlt

;-- header information format for PE files -------------------

;typedef struct _IMAGE_DOS_HEADER {  // DOS .EXE header
;    USHORT e_magic;         // Magic number (Should be MZ
;    USHORT e_cblp;          // Bytes on last page of file
;    USHORT e_cp;            // Pages in file
;    USHORT e_crlc;          // Relocations
;    USHORT e_cparhdr;       // Size of header in paragraphs
;    USHORT e_minalloc;      // Minimum extra paragraphs needed
;    USHORT e_maxalloc;      // Maximum extra paragraphs needed
;    USHORT e_ss;            // Initial (relative) SS value
;    USHORT e_sp;            // Initial SP value
;    USHORT e_csum;          // Checksum
;    USHORT e_ip;            // Initial IP value
;    USHORT e_cs;            // Initial (relative) CS value
;    USHORT e_lfarlc;        // File address of relocation table
;    USHORT e_ovno;          // Overlay number
;    USHORT e_res[4];        // Reserved words
;    USHORT e_oemid;         // OEM identifier (for e_oeminfo)
;    USHORT e_oeminfo;       // OEM information; e_oemid specific
;    USHORT e_res2[10];      // Reserved words
;    LONG   e_lfanew;        // File address of new exe header
;  } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;

;<<------ Real mode stub program -------->>

;<<------ Here is the file signiture, such as PE00 for NT --->>

;typedef struct _IMAGE_FILE_HEADER {
;    USHORT  Machine;
;    USHORT  NumberOfSections;
;    ULONG   TimeDateStamp;
;    ULONG   PointerToSymbolTable;
;    ULONG   NumberOfSymbols;
;    USHORT  SizeOfOptionalHeader;
;    USHORT  Characteristics;
;} IMAGE_FILE_HEADER, *PIMAGE_FILE_HEADER;

;struct _IMAGE_OPTIONAL_HEADER {
;    //
;    // Standard fields.
;    //
;    USHORT  Magic;
;    UCHAR   MajorLinkerVersion;
;    UCHAR   MinorLinkerVersion;
;    ULONG   SizeOfCode;
;    ULONG   SizeOfInitializedData;
;    ULONG   SizeOfUninitializedData;
;    ULONG   AddressOfEntryPoint;			
;    ULONG   BaseOfCode;
;    ULONG   BaseOfData;
;    //
;    // NT additional fields.
;    //
;    ULONG   ImageBase;
;    ULONG   SectionAlignment;
;    ULONG   FileAlignment;
;    USHORT  MajorOperatingSystemVersion;
;    USHORT  MinorOperatingSystemVersion;
;    USHORT  MajorImageVersion;
;    USHORT  MinorImageVersion;
;    USHORT  MajorSubsystemVersion;
;    USHORT  MinorSubsystemVersion;
;    ULONG   Reserved1;
;    ULONG   SizeOfImage;
;    ULONG   SizeOfHeaders;
;    ULONG   CheckSum;
;    USHORT  Subsystem;
;    USHORT  DllCharacteristics;
;    ULONG   SizeOfStackReserve;
;    ULONG   SizeOfStackCommit;
;    ULONG   SizeOfHeapReserve;
;    ULONG   SizeOfHeapCommit;
;    ULONG   LoaderFlags;
;    ULONG   NumberOfRvaAndSizes;
;    IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
;} IMAGE_OPTIONAL_HEADER, *PIMAGE_OPTIONAL_HEADER;

