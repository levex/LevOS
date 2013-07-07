#include "SystemCalls.h"
#include "DebugDisplay.h"
#include "ProcessManager.h"
#include "hw_keyboard.h"
#include "HComm.h"
#include "PELoader.h"
#include "RTC.h"
#include "FAT12.h"
#include "VGAdriver.h"
#include "hw_mouse.h"
#include "realmodewrapper.h"
#include "PCI.h"
#include "ACPI.h"

#include "error.h"

char* string = (char*)0;
char c = 0;
int id = 0;
int a=0,b=0, d=0, e=0;
int _ebx = 0;
char vgacol = 0;
char f = 0;
bool _b = 0;
char err = 0;
RTC_DATA* data = (RTC_DATA*)0;
regs_t regs;
void handleSysCall()
{
	_asm sti
	_asm {
		mov id, eax
	}
	KEYCODE key = KEY_UNKNOWN;
	switch(id)
	{
		case 0x01: // test
			_asm mov _ebx, ebx
			switch(_ebx)
			{
				case 0:
					for(;;);
					break;
				case 1:
					regs.ah = 0x00;
					regs.al = 0x00;
					doRealModeInterrupt(0x16, 0,0);
					break;
				case 2:
					PCI_test();
					break;
				case 3:
					//outportW( 0xB004, 0x0 | 0x2000 );
					ACPI_test();
					break;
			}
			break;
		case 0x02: // PrintString
			/*
				Prints a string
				EDX = address of string (char*)
			*/
			string = (char*)0;
			_asm
			{
				mov string, edx;
			}
			DebugPrintf("%s", string, string);
			break;
		case 0x03: // PrintChar
			/*
				Prints a character
				BL = character to print
			*/
			_asm
			{
				mov c, bl
			}
			DebugPutc(c);
			break;
		case 0x04: // Wait for keypress
			/*
				Waits for a keypress and returns it in DH
				RET -> DH (character retrieved)
			*/
			_asm xor dh, dh
			c = 0;
			key = KEY_UNKNOWN;
			/*while(key == KEY_UNKNOWN)*/ key = kkybrd_get_last_key();
			kkybrd_discard_last_key();
			c = kkybrd_key_to_ascii(key);
			//if(key == KEY_UNKNOWN) c=0;
			if(c==0x2) c = 0;
			_asm mov dh, c
			break;
		case 0x05: // load file to specified address
			/*
				Load file to specified address
				EBX = address
				EDX = filename (char*)

				RET -> DL (error code or 0 if success)
			*/
			char* filename;
			char* address;
			_asm {
				mov filename, edx
				mov address, ebx
			}
			if((err = loadFileToLoc(filename, address)) != ERR_SUCCESS) {_asm {mov dl, err}break;}
			_asm {
				mov dl, ERR_SUCCESS
			}
			break;
		case 0x06: // display utilites
			/*
				Display utilities
				EBX = Function
					EBX == 0x01
						Move cursor
						DL = Y coordinate change
						DH = X coordinate change
					EBX == 0x02
						Clear screen
			*/
			_ebx = 0;
			_asm mov _ebx, ebx
			switch(_ebx)
			{
				case 0x01:
					signed char dex;
					signed char dey;
					_asm
					{
						mov dex, dh
						mov dey, dl
					}
					DebugGotoRXY(dex, dey);
					break;
				case 0x02:
					DebugClrScr(0x17);
					break;
			}
			break;
		case 0x07: //execute application
			/*
				EBX == 0x01
					Executes the PE executable at the given address
					EDX = address of filename
						Returns:
							DL (error code)
				EBX == 0x02
					Dumps the PE executable at the given address
					EDX = adress of filename
						Returns:
							EDX
								1 = SUCCESS
								0 = FILE NOT FOUND
								2 = OTHER FAILURE
			*/
			_asm mov _ebx, ebx
			switch(_ebx)
			{
				case 0x01:
					_asm mov filename, edx
					err = PE_mapApp(filename, 0x1000000);
					_asm mov dl, err
					break;
				case 0x02:
					_asm mov filename, edx
					_b = PE_dumpApp(filename,0x1000000);
					if(_b){ _asm { mov edx, 1} break;}
					_asm xor edx, edx
					break;
			}
			break;
		case 0x08: // printNumber
			/*
				Prints a number
				EDX = number to print
			*/
			int i;
			_asm mov i, edx
			DebugPrintf("%i", i);
			break;
		case 0x09: // get RTC struct
			/*
				Queries an RTC struct at a give address
				EDX = address to write RTC_STRUCT to. (Refer to RTC.h)
			*/
			int _i;
			_asm mov _i, edx
			data = (RTC_DATA*) _i;
			//DebugPrintf("---->0x%X<----", data);
			data->DayOfMonth = rtc_getDayOfMonth();
			data->Hour = rtc_getHour();
			data->Minute = rtc_getMinute();
			data->Month = rtc_getMonth();
			data->Second = rtc_getSecond();
			data->WeekDay = rtc_getWeekday();
			data->Year = rtc_getYear();
			break;
		case 0x0A: // print hexadecimal
			/*
				Prints a number in base 16
				EDX = number to print
			*/
			_asm mov _ebx, edx
			DebugPrintf("%x", _ebx);
			break;
		case 0x0B: // fsys utils
			/*
				Provides an interface to the FAT12 filesystem!
				EBX = function
					EBX = 0x01
						Returns filenames in ROOT directory
						EDX = pointer to filenames (terminates with \0)
					EBX = 0x02
						Returns the number of files in ROOT directory
						EDX = number of files
			*/
			_asm mov _ebx, ebx
			switch(_ebx)
			{
				case 0x01: // get filenames
					fsysFatGetFilesInRoot(string);
					_asm mov edx, string
					return;
				case 0x02: // get # of files
					id = fsysFatGetNumberOfFilesInRoot();
					_asm mov edx, id
			}
		case 0x0C: //vga utils
			/*
				VGA utilities
				EBX = function
					EBX = 0x01
						Switches on VGA(320x200x1Byte)
					EBX = 0x02
						ECX = X coordinate
						ESI = Y coordinate
						DL = color
							Puts a pixel at (ECX, ESI) = DL
					EBX = 0x03
						Clears the screen
					EBX = 0x04
						EDX = pointer to filename
						ESI = X coordinate
						EDI = Y coordinate
						Loads a .BMP file and displays at given coordinates ( ESI, EDI )
					EBX = 0x05
						Deinitializes VGA and returns to text mode
					EBX = 0x06
						ESI = char* to string
						ECX = X coordinate
						EDX = Y coordinate
						Prints a string at (ECX, EDX)
					EBX = 0x07
						ESI = X coordinate
						EDI = Y coordinate
						CL = character
						CH = color
						Print a character at (ESI, EDI)=CL (CH)
					EBX = 0x08
						ESI = X0 coordinate
						EDI = Y0 coordinate
						ECX = X1 coordinate
						EDX = Y1 coordinate
						Draws a line from (ESI, EDI) to (ECX, EDX)
					EBX = 0x09
						ESI = X0 coordinate
						EDI = Y0 coordinate
						ECX = X1 coordinate
						EDX = Y1 coordinate
						Draws a rectangle from (ESI, EDI) to (ECX, EDX)
					EBX = 0x0A
						CL = color
						Sets the draw color to CL
					EBX = 0x0B
						Returns the color in CL
						
			*/
			_asm mov _ebx, ebx
			switch(_ebx)
			{	
				case 0x01: // switch on VGA
					VGA_init(320, 200, 256);
					break;
				case 0x02: // put pixel (cx,dx)
					_asm {
						mov a, ecx
						mov b, esi
						mov c, dl
					}
					VGA_put_pixel(a, b, c);
					break;
				case 0x03: // clear screen
					VGA_clear_screen();
					break;
				case 0x04: // load bmp file
					_asm {
						mov filename, edx
						mov a, esi
						mov b, edi
					}
					VGA_put_image(a, b, filename);
					break;
				case 0x05: //vga deinit
					VGA_deinit();
					break;
				case 0x06: // vga putStr
					_asm {
						mov filename, esi
						mov a, ecx
						mov b, edx
					}
					VGA_put_string(a,b,filename, vgacol);
					break;
				case 0x07: // vga putchar
					_asm {
						mov a, esi
						mov b, edi
						mov c, cl
						mov f, ch
					}
					VGA_put_char(a, b, c, f);
					break;
				case 0x08: //vga putline
					_asm {
						mov a, esi
						mov b, edi
						mov d, ecx
						mov e, edx
					}
					VGA_put_line(a, b, d, e, vgacol);
					break;
				case 0x09: //vga putrect
					_asm {
						mov a, esi
						mov b, edi
						mov d, ecx
						mov e, edx
					}
					VGA_put_rectangle(a, b, d, e, vgacol);
					break;
				case 0x0A: // vga setcolor
					_asm {
						mov vgacol, cl
					}
					break;
				case 0x0B:
					_asm {
						mov cl, vgacol
					}
					break;
			}
		case 0x0D: // fill mouse info
			/*
			EDX = pointer to MOUSE_STATE structure
			Fill the (EDX) with mouse data
			*/
			_asm mov a, edx
			//MOUSE_STATE* m = (MOUSE_STATE*)a;
			fillMouseState((MOUSE_STATE*)a);
			break;
	}
}