#include "realmodewrapper.h"
#include "DebugDisplay.h"
#include "HComm.h"
#include "PIC.h"

void _cdecl doRealModeInterrupt(char i, char _ah, char _al)
{
	DebugPrintf("\nGoin' to Real Mode! Bye good life! :)  I mean not yet! :3");

	loadFileToLoc("RMODE.SYS", (void*)0x7C00);
	pic_initialize(0x08, 0x70);
	_asm mov eax, 0x7C00
	_asm jmp eax
}