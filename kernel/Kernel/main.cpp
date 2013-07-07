#include <stdint.h>

#include "DebugDisplay.h"
#include "pMemory.h"
#include "vMemory.h"
#include "GDT.h"
#include "IDT.h"
#include "SystemCalls.h"
#include "PIC.h"
#include "hw_keyboard.h"
#include "hw_mouse.h"
#include "HComm.h"
#include "Exception.h"
#include "PIT.h"
#include "VirtualDevice.h"
#include "FAT12.h"
#include "ProcessManager.h"
#include "VGAdriver.h"

#include "string.h"

#include "PE.h"
#include "PELoader.h"

#include "currentTest.h"


#define KERNEL_VERSION "060713"
#define KERNEL_BASE "0xC0000000"
#define KERNEL_SIZE 4096*5

#define IMAGE_BASE 0xC00000

static DATADEVICE currentData;

//#define DEBUG

void test()
{
	DebugPrintf("WORKS");
	for(;;);
}
void loop();

KEYCODE	getch () {
	//DebugPrintf("Getch");
	KEYCODE key = KEY_UNKNOWN;

	// wait for a keypress
	while (key==KEY_UNKNOWN)
		key = kkybrd_get_last_key ();

	// discard last keypress (we handled it) and return
	kkybrd_discard_last_key ();
	return key;
}

int getEntryPoint(int base)
{
	int PE_HEADER_LOCATION = *(int*)(base + 0x3C); // location of PE HEADER start.
	PE_HEADER_LOCATION += base;
	int OPTIONAL_HEADER_LOCATION = PE_HEADER_LOCATION + 24;
	int VIRTUAL_ENTRY_POINT = *(int*)(OPTIONAL_HEADER_LOCATION + 16);
	int NUMBER_OF_DIRECTORYHEADERS = *(int*)(OPTIONAL_HEADER_LOCATION + 92);
	int TEXT_HEADER_LOCATION = OPTIONAL_HEADER_LOCATION + 96 + NUMBER_OF_DIRECTORYHEADERS*8;
	int VIRTUAL_ADDRESS = *(int*)(TEXT_HEADER_LOCATION + 12);
	int POINTER_TO_RAW_DATA = *(int*)(TEXT_HEADER_LOCATION+20);
	return (base + VIRTUAL_ENTRY_POINT - VIRTUAL_ADDRESS + POINTER_TO_RAW_DATA);
}
inline void fillProcess(PROCESS p,int base)
{
	/*int PE_HEADER_LOCATION = *(int*)(base + 0x3C);
	PE_HEADER_LOCATION += base;
	int OPTIONAL_HEADER_LOCATION = PE_HEADER_LOCATION + 24;
	p.BaseOfCode = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 20);
	p.BaseOfData = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 24);
	//DebugPrintf("BaseOfData=0x%X", p.BaseOfData);
	p.SizeOfCode = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 4);
	p.SizeOfInitializedData = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 8);*/
}

#ifdef DEBUG
void cmd_read_sect () {

	uint32_t sectornum = 0;
	char sectornumbuf [4];
	uint8_t* sector = 0;
	sectornum = 0;

	DebugPrintf ("\n\rSector %i contents:\n\n\r", sectornum);

	// read sector from disk
	sector = currentData.read_sector ( sectornum );

	// display sector
	if (sector!=0) {

		int i = 0;
		for ( int c = 0; c < 4; c++ ) {

			for (int j = 0; j < 128; j++)
				DebugPrintf ("0x%x ", sector[ i + j ]);
			i += 128;

			DebugPrintf("\n\rPress any key to continue\n\r");
			getch ();
		}
	}
	else
		DebugPrintf ("\n\r*** Error reading sector from disk");

	DebugPrintf ("\n\rDone.");
}

#endif

static PROCESS p;
static PROCESS p2;

void _cdecl main () {

	int i=0x12;

	DebugClrScr (0x18);
	DebugSetColor (0x17);
	bool retur = false;
	int _ts = 0;
	_asm mov _ts, edx
	if(_ts == 0x1337) { retur = true; goto returning;}

	DebugPrintf ("LevOS2 loading Kernel Version: %s\n", KERNEL_VERSION);
	DebugPrintf ("Loading Physical Memory Manager: %s\n", (pm_setup((char*)(KERNEL_BASE+KERNEL_SIZE+4096)) ? "OK":"ERROR"));
#ifdef DEBUG
	DebugPrintf ("   HEAP start: 0x%X\n", KERNEL_BASE+KERNEL_SIZE+4096);
	DebugPrintf ("Testing malloc: 0x%x", (int)malloc(1));
	DebugPrintf ("; 0x%x", (int)malloc(1));
	DebugPrintf ("; 0x%x\n", (int)malloc(1));
#endif
	int pagestart = (((unsigned int)malloc_ps((char*)0x400000,4*1024*1024)));
	DebugPrintf ("Loading Virtual Memory Manager: %s\n", (vm_setup((int*)(pagestart)) ? "OK":"ERROR"));
#ifdef DEBUG
	DebugPrintf ("   PAGE start: 0x%X\n", pagestart);
	DebugPrintf ("   malloc failure test: 0x%x\n", (int)malloc(1));
#endif
returning: /***************/
	if(!retur)DebugPrintf ("Setting up Paging: ");
	vm_map_virt_to_phys(0, 0); // 0-4mb
	vm_map_virt_to_phys(1, 0x400000); //4mb - 8mb
	vm_map_virt_to_phys(2, 0x800000); // 8-12
	vm_map_virt_to_phys(3, 0xC00000); // 12-16
	vm_map_virt_to_phys(4, 0x1000000); // 16-18
	vm_map_virt_to_phys(767, 0x1400000); // process stack reserve start: 0xBFC00000 - 0xC0000000 (4mb)
	vm_map_virt_to_phys(768, 0x100000); // 3gb+ 
	if(!retur)DebugPrintf ("OK\n");
	if(!retur)DebugPrintf ("Enabling Paging: %s\n", vm_enable_paging()?"OK":"ERROR");
	//int GDTstart = (int)malloc(sizeof(struct gdt_descriptor)*MAX_DESCRIPTORS);
	int GDTstart = 0x400;
	if(!retur)DebugPrintf ("Setting up GDT: %s\n", i86_gdt_setup(GDTstart)?"OK":"ERROR");
#ifdef DEBUG 
		DebugPrintf ("   GDT start: 0x%X\n", GDTstart);
		DebugPrintf ("   malloc failure test: 0x%x\n", (int)malloc(1));
#endif
	int IDTstart = (int)malloc(sizeof(struct idt_descriptor)*I86_MAX_INTERRUPTS);
	if(!retur)DebugPrintf ("Setting up IDT: %s\n", i86_setup(IDTstart)?"OK":"ERROR");
#ifdef DEBUG 
		DebugPrintf ("   IDT start: 0x%X\n", IDTstart);
		DebugPrintf ("   malloc failure test: 0x%x\n", (int)malloc(1));
#endif
	i86_install_ir (0x2F, I86_IDT_DESC_PRESENT | I86_IDT_DESC_BIT32, 0x8, (I86_IRQ_HANDLER)handleSysCall); // install SystemCall
	if(!retur)DebugPrintf ("Setting up PICs: %s\n",  pic_initialize(0x20, 0x28)?"OK":"ERROR");
	setint (0,(void (__cdecl &)(void))divide_by_zero_fault);
	setint (1,(void (__cdecl &)(void))single_step_trap);
	setint (2,(void (__cdecl &)(void))nmi_trap);
	setint (3,(void (__cdecl &)(void))breakpoint_trap);
	setint (4,(void (__cdecl &)(void))overflow_trap);
	setint (5,(void (__cdecl &)(void))bounds_check_fault);
	setint (6,(void (__cdecl &)(void))invalid_opcode_fault);
	setint (7,(void (__cdecl &)(void))no_device_fault);
	setint (8,(void (__cdecl &)(void))double_fault_abort);
	setint (10,(void (__cdecl &)(void))invalid_tss_fault);
	setint (11,(void (__cdecl &)(void))no_segment_fault);
	setint (12,(void (__cdecl &)(void))stack_fault);
	setint (13,(void (__cdecl &)(void))general_protection_fault);
	setint (14,(void (__cdecl &)(void))page_fault);
	setint (16,(void (__cdecl &)(void))fpu_fault);
	setint (17,(void (__cdecl &)(void))alignment_check_fault);
	setint (18,(void (__cdecl &)(void))machine_check_abort);
	setint (19,(void (__cdecl &)(void))simd_fpu_fault);
	if(!retur)DebugPrintf ("Setting up PIT: %s\n", i86_pit_initialize()?"OK":"ERROR");
	i86_pit_start_counter (200,I86_PIT_OCW_COUNTER_0, I86_PIT_OCW_MODE_SQUAREWAVEGEN);
	if(!retur)DebugPrintf ("Enabling Exceptions & IRQs: ");
	_asm sti
	if(!retur)DebugPrintf ("OK\n");
	//setint (0x20, irq0handler);
	if(!retur)DebugPrintf ("Setting up Keyboard: ");
	kkybrd_install(33);
	kkybrd_enable();
	if(!retur)DebugPrintf ("OK\n");
	DebugPrintf("Setting up Mouse: %s\n", mice_install()?"OK":"DISABLED");
	DebugPrintf ("Setting up drives: %s\n", vd_populate()?"OK":"ERROR");
	if(!retur)currentData = vd_getCurrentDataDevice();
#ifdef DEBUG
	DebugPrintf ("Testing VD_READ: OK\n");
	//cmd_read_sect();
#endif
	DebugPrintf ("Mounting FAT12: ");
	if(!retur)fsysFatInitialize(currentData);
#ifdef DEBUG
	FILE file = volOpenFile ("test.txt");
	while (file.eof != 1) {

		// read cluster
		unsigned char buf[512];
		volReadFile ( &file, buf, 512);

		// display file
		for (int i=0; i<512; i++)
			DebugPutc(buf[i]);

		// wait for input to continue if not EOF
		if (file.eof != 1) {
			DebugPrintf ("\n\r------[Press a key to continue]------");
			getch ();
			DebugPrintf ("\r"); //clear last line
		}
	}
#endif
	if(!retur)DebugPrintf("OK\n");
	if(!retur)DebugPrintf("Saving font: ");
	char* _font = (char*)malloc(8192);
	/*short _es;
	short _bx;
	_asm mov _es, [0x1990]
	_asm mov _bx, [0x199F]
	char* loc = (char*)(_es * 0x10 + _bx);
	memcpy(loc, _font, 8192);
	VGA_setfont(_font);*/
	_asm {
		;clear even/odd
		mov			dx, 03ceh
		mov			ax, 5
		out			dx, ax
		;map VGA memory to 0A0000h
		mov			ax, 0406h
		out			dx, ax
		;set bitplane 2
		mov			dx, 03c4h
		mov			ax, 0402h
		out			dx, ax
		;clear even/odd mode
		mov			ax, 0604h
		out			dx, ax
		mov			esi, 0A0000h
		mov			ecx, 256
		mov			edi, _font
		cld
		;copy 16 bytes to bitmap
lol:	movsd
		movsd
		movsd
		movsd
		;skip another 16 bytes
		add			esi, 16
		loop			lol
		;restore VGA state to normal operation
		mov			ax, 0302h
		out			dx, ax
		mov			ax, 0204h
		out			dx, ax
		mov			dx, 03ceh
		mov			ax, 1005h
		out			dx, ax
		mov			ax, 0E06h
		out			dx, ax
	}
	VGA_setfont(_font);
	DebugPrintf("OK\n");
	//DebugSetColor(0x17);
	if(!retur)DebugPrintf("Press any key to continue to the terminal...");
	if(!retur)getch();
	//DebugPrintf("\nMultitasking Testing has been enabled!");
	//startMultitask();
	//for(;;);
	DebugPrintf("\nMultitasking Testing has been disabled!");
	initProcessManager();

	//p = (PROCESS*)malloc(sizeof(PROCESS));
	getch();
	p.valid = true;
	p.ran = false;
	p.eip = (int)taskone;
	allocStack(&p);
	//addProcess(&p);
	//getch();

	//p2 = (PROCESS*)malloc(sizeof(PROCESS));
	p2.valid = true;
	p2.ran = false;
	p2.eip = (int)tasktwo;
	allocStack(&p2);
	//addProcess(&p2);
	//getch();

	PROCESS p3;
	p3.valid = true;
	p3.ran = false;
	p3.eip = (int)taskthree;
	allocStack(&p3);
	//addProcess(&p3);
	//getch();

	setCurrentProc(&p);

	//startMultitask();
	/*int a = p.regs.esp;
	_asm mov esp, a
	a = p.regs.ebp;
	_asm mov ebp, a*/
	//taskone();
	/*int a = 0;
	a = p.regs->eip;
	_asm call a*/

	//for(;;);
	if(!retur)DebugPrintf("\nLoading up shell: ");
	/*DebugPrintf("\nFiles in root: \n");
	char* files = fsysFatGetFilesInRoot();
	char num = fsysFatGetNumberOfFilesInRoot();
	char name[11];
	for(int i = 0; i < num; i++)
	{
			for(int j = 0; j < 11; j++)
			{
				DebugPutc(*(files + j + i *11));
			}
			DebugPutc('\n');
	}
	getch();*/
	//memcpy((char*)0x100000,(char*)0xB8000, 32768); //fixme
	//loadFileToLoc("cmd.exe", (void*)IMAGE_BASE);
	char err = PE_mapApp("cmd.exe", IMAGE_BASE);
	for(;;);
	//DebugPrintf("\nError code: 0x%x");
	/*char* test = (char*)0x800000;
	DebugPrintf(test);*/
	/*int* AddressOfEntryPoint = (int*)IMAGE_BASE+ 0xC0 + 0x18 + 0x12;
	int* SizeOfCode = (int*)0xC000d4;
	int* BaseOfCode = (int*)0xC000e4;
	int* BaseOfData = (int*)0xC000e8;
	int* textVirtualAddress = (int*)0xC001c4;
	int* textPointerToRawData = (int*)0xC001c8;
	//	int* SizeOfCode = (int*)0xC000d4;
	int* SizeOfInitializedData = (int*)0xC000d8;
	DebugPrintf("Address=0x%x, size=0x%x, base=0x%x, base-size=0x%x => fileaddr=0x%x\n", *AddressOfEntryPoint, *BaseOfCode, *SizeOfCode, *BaseOfCode - *SizeOfCode, *AddressOfEntryPoint - *BaseOfCode + *SizeOfCode );*/
	//char* entryPoint = (char*)(0x1070 + 0x400 + 0xC00000 - 0x1000);
	unsigned int ientryPoint = 0;
	ientryPoint = getEntryPoint(IMAGE_BASE);
	/*DebugPrintf("Entrypoint = 0x%x\n", ientryPoint);
	PROCESS p;
		//fillProcess(p, IMAGE_BASE);
		p.pid = 1;
		int PE_HEADER_LOCATION = *(int*)(IMAGE_BASE + 0x3C);
		PE_HEADER_LOCATION += IMAGE_BASE;
		int OPTIONAL_HEADER_LOCATION = PE_HEADER_LOCATION + 24;
		p.BaseOfCode = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 20);
		p.BaseOfData = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 24);
		//DebugPrintf("BaseOfData=0x%X", p.BaseOfData);
		p.SizeOfCode = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 4);
		p.SizeOfInitializedData = *(unsigned int*)(OPTIONAL_HEADER_LOCATION + 8);
	setCurrentProc(p);*/
	/*_asm {
		mov ax, 0x08
		mov     ds, ax
        mov     es, ax
        mov     fs, ax
        mov     gs, ax
	}*/
	//for(;;);
	//_asm jmp ientryPoint
	//for(;;);
	loop();
}


void loop()
{
	DebugPrintf("\n[LevOS-KRNL]~#");
	KEYCODE key;
	//geninterrupt(0x21);
	while(true)
	{
		key = getch();
		char c = kkybrd_key_to_ascii(key);
		if(c!=0)DebugPutc(c);
	}
}