#include "HComm.h"
#include "IDT.h"
#include "PIT.h"
#include "PIC.h"
#include "VirtualDevice.h"
#include "FileSystem.h"
#include "pMemory.h"
#include "DebugDisplay.h"
void _cdecl outport(unsigned short portid, unsigned char value)
{
	_asm {
		mov		al, byte ptr [value]
		mov		dx, word ptr [portid]
		out		dx, al
	}
}
unsigned char _cdecl inport(unsigned short portid)
{
	_asm {
		mov		dx, word ptr [portid]
		in		al, dx
		mov		byte ptr [portid], al
	}
	return (unsigned char)portid;

}

void _cdecl outportW(unsigned short portid, unsigned int value)
{
	_asm {
		push eax
		mov		eax, value
		mov		dx, word ptr [portid]
		out	dx, eax
		pop eax
	}
}
unsigned int _cdecl inportW(unsigned short portid)
{
	unsigned int ret = 0;
	_asm {
		mov		dx, word ptr [portid]
		in		eax, dx
		mov		ret, eax
	}
	return ret;

}

inline void _cdecl	interruptdone (unsigned int intno) {

	// insure its a valid hardware irq
	if (intno > 16)
		return;

	// test if we need to send end-of-interrupt to second pic
	if (intno >= 8)
		pic_send_command (I86_PIC_OCW2_MASK_EOI, 1);

	// always send end-of-interrupt to primary pic
	pic_send_command (I86_PIC_OCW2_MASK_EOI, 0);
}

void _cdecl setint(int i, I86_IRQ_HANDLER h)
{
	i86_install_ir (i, I86_IDT_DESC_PRESENT | I86_IDT_DESC_BIT32, 0x8, h);
}

void sleep(int i)
{
	static int ticks = i + i86_pit_get_tick_count ();
	while (ticks > i86_pit_get_tick_count ())
		;

}

int getFileSize(char* file)
{
	FILE f = volOpenFile(file);
	if(f.flags&FS_INVALID == FS_INVALID) {return 0;};
	return f.fileLength;
}

bool loadFileToLoc(char* file, void* loc)
{
	FILE f = volOpenFile(file);
	if(f.flags == FS_INVALID) {return false;};
	unsigned char* buf = (unsigned char*)loc;
	int i = 0;
#ifdef DEBUG
	DebugPrintf("Filesize=%d", f.fileLength);
#endif
	while(f.eof != 1)
	{
		volReadFile(&f, buf + i*512, 512);
		i++;
	}
#ifdef DEBUG
	DebugPrintf("\ni=%d=>size=%d", i+1, (i+1)*512);
#endif
	volCloseFile(&f);
	return true;
}