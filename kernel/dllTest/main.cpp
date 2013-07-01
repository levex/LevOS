//extern "C" __declspec(dllimport) void print(char* s);

#define DLLIMPORT extern "C" __declspec(dllimport)

#include "LevAPI\lev_text.h"
#include "LevAPI\lev_input.h"
#include "LevAPI\lev_vga.h"
#include "LevAPI\lev_misc.h"


void main()
{
	print("\nAPI is now in the DLL!");
	halt();
	waitForKeyPress();
	return;
}