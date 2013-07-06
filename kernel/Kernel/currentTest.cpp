#include "currentTest.h"
#include "DebugDisplay.h"

void taskone()
{
	while(1) {
		DebugPrintf("1");
		/*_asm mov al, '1'
		_asm out 0xE9, al*/
	}
}
void tasktwo()
{
	 while(1) {
		DebugPrintf("2");
		/* _asm mov al, '2'
		_asm out 0xE9, al*/
	}
}
void taskthree()
{
	 while(1) {
		DebugPrintf("3");
		 /*_asm mov al, '3'
		_asm out 0xE9, al*/
	}
}