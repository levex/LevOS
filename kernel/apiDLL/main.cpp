#define DLLEXPORT extern "C" __declspec(dllexport)

#include "lev_futils.h"
#include "lev_input.h"
#include "lev_misc.h"
#include "lev_text.h"
#include "lev_time.h"
#include "lev_vga.h"

void _cdecl print(char* s)
{
	//API_BEGIN;
	//_asm mov ecx, [s]
	_asm {
		mov edx, s
		mov eax, 0x02
		int 0x2F
	}
	if(0) ;
	//API_END;
}

void _cdecl printchar(char c)
{
	_asm{
		mov eax, 0x03
		mov bl, c
		int 0x2F
	}
}
void _cdecl printNumber(int i)
{
	_asm {
		mov eax, 0x08
		mov edx, i
		int 0x2F
	}
}
void _cdecl printHexa(int i)
{
	_asm {
		mov eax, 0x0A
		mov edx, i
		int 0x2F
	}
}

void _cdecl halt()
{
	_asm {
		xor eax,eax
		int 0x2F
	}
}

char _cdecl getInputChar()
{
	char r = 0;
	_asm {
		mov eax, 0x4
		int 0x2F
		mov r, dh
	}
	return r;
}

void _cdecl waitForKeyPress()
{
	while(getInputChar() == 0);
	return;
}

char* _cdecl omgRelocPl0x()
{
	return "Relocation is working.";
}

bool _cdecl loadFileToLoc(char* filename, char* address)
{
	_asm {
		mov ebx, address
		mov edx, filename
		mov eax, 0x05
		int 0x2F
	}
	int _c = 0;
	_asm mov _c, edx
	return (_c==1);
}
void _cdecl moveCursorRelative(char rx, char ry)
{
	_asm {
		mov dh, rx
		mov dl, ry
		mov eax, 0x06
		mov ebx, 0x01
		int 0x2F
	}
}
bool _cdecl executePE32(char* filename)
{
	_asm {
		mov edx, filename
		mov ebx, 0x01
		mov eax, 0x07
		int 0x2F
	}
	int _c = 0;
	_asm mov _c, edx
	return (_c==1);
}
bool _cdecl dumpPE32(char* filename)
{
	_asm {
		mov eax, 0x07
		mov ebx, 0x02
		mov edx, filename
		int 0x2F
	}
	int _c = 0;
	_asm mov _c, edx
	return (_c==1);
}
void _cdecl clearScreen()
{
	_asm {
		mov eax, 0x06 // display utils
		mov ebx, 0x02 // clear screen
		int 0x2F // invoke levos kernel
	}
}
void _cdecl fillRTC(int data)
{
	_asm {
		mov eax, 0x09
		mov edx, data
		int 0x2F
	}
}
int getNumberOfFilesInRoot()
{
	int ret = 0;
	_asm {
		mov eax, 0x0B
		mov ebx, 0x02
		int 0x2F
		mov ret, edx
	}
	return ret;
}
char* getFilesInRoot()
{
	char* ret;
	_asm 
	{
		mov eax, 0x0B
		mov ebx, 0x01
		int 0x2F
		mov ret, edx
	}
}
void _cdecl VGA_init()
{
	_asm {
		mov eax, 0x0C
		mov ebx, 0x01
		int 0x2F
	}
}
void _cdecl VGA_clear()
{
	_asm {
		mov eax, 0x0C
		mov ebx, 0x03
		int 0x2F
	}
}
void _cdecl VGA_putpixel(int x, int y, char color)
{
	_asm {
		mov eax, 0x0C //vga
		mov ebx, 0x02 //putpixel
		mov ecx, x
		mov esi, y
		mov DL, color
		int 0x2F
	}
}
void _cdecl VGA_putimage(int x, int y, char* filename)
{
	_asm {
		mov eax, 0x0C //vga
		mov ebx, 0x04 //putimage
		mov esi, x
		mov edi, y
		mov edx, filename
		int 0x2F
	}
}
void _cdecl VGA_deinit()
{
		_asm
		{
			mov eax, 0x0C
			mov ebx, 0x05
			int 0x2f
		}
}
void _cdecl VGA_putstring(int x, int y, char* str)
{
		_asm{
			mov eax, 0x0C
			mov ebx, 0x06
			mov esi, str
			mov ecx, x
			mov edx, y
			int 0x2F
		}
}

void _cdecl VGA_putchar(int x, int y, char c)
{
	_asm {
		mov eax, 0x0C
		mov ebx, 0x07
		mov esi, x
		mov edi, y
		mov cl, c
		int 0x2f
	}
}
void _cdecl VGA_putline(int x0, int y0, int x1, int y1)
{
	_asm 
	{
		mov eax, 0x0C
		mov ebx, 0x08
		mov esi, x0
		mov edi, y0
		mov ecx, x1
		mov edx, y1
		int 0x2F
	}
}
void _cdecl VGA_putrect(int x0, int y0, int x1, int y1)
{
	_asm 
	{
		mov eax, 0x0C
		mov ebx, 0x09
		mov esi, x0
		mov edi, y0
		mov ecx, x1
		mov edx, y1
		int 0x2F
	}
}
void _cdecl VGA_setcolor(char c)
{
	_asm {
		mov eax, 0x0C
		mov ebx, 0x0A
		mov cl, c
		int 0x2F
	}
}
void _cdecl fillMouseState(MOUSE_STATE* m)
{
	_asm 
	{
		mov eax, 0x0D
		mov edx, m
		int 0x2F
	}
}