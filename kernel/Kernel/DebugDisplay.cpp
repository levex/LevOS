#include <stdarg.h>
#include <string.h>
#include "DebugDisplay.h"
#include "pMemory.h"
#include "VGAdriver.h"
#define VID_MEMORY	0xB8000
#define COLS 80
#define LINE 25

static unsigned int _xPos=0, _yPos=0;
static unsigned _startX=0, _startY=0;

// current color
static unsigned _color=0;

#ifdef _MSC_VER
#pragma warning (disable:4244)
#endif

int DebugGetX()
{
	return _xPos/2;
}

int DebugGetY()
{
	return _yPos/2;
}

void DebugReset()
{
	_xPos = 0;
	_yPos = 0;
	_startX = 0;
	_startY = 0;
	DebugClrScr(0x17);
}

void DebugGotoRXY (unsigned x, unsigned y) {

	// reposition starting vectors for next text to follow
	// multiply by 2 do to the video modes 2byte per character layout
	_xPos = _xPos + x;
	_yPos = _yPos + y;
}

void DebugPutc (unsigned char c) {

	if (c==0)
		return;

	if (c == '\n'||c=='\r') {	/* start new line */
		_yPos+=2;
		_xPos=_startX;
		return;
	}

	if (_xPos > 79) {			/* start new line */
		_yPos+=2;
		_xPos=_startX;
		return;
	}
	if(_yPos >= 49)
	{
		DebugScrollUp();
	}
	if(isVGA()) {
		VGA_put_char(_xPos++ * 8, _yPos * 8, c, 1);
		return;
	}
	/* draw the character */
	unsigned char* p = (unsigned char*)VID_MEMORY + (_xPos++)*2 + _yPos * 80;
	*p++ = c;
	*p =_color;
}

void DebugNextline()
{
		_yPos+=2;
		_xPos=_startX;
		return;
}

char tbuf[32];
char bchars[] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

void itoa(unsigned i,unsigned base,char* buf) {
   int pos = 0;
   int opos = 0;
   int top = 0;

   if (i == 0 || base > 16) {
      buf[0] = '0';
      buf[1] = '\0';
      return;
   }

   while (i != 0) {
      tbuf[pos] = bchars[i % base];
      pos++;
      i /= base;
   }
   top=pos--;
   for (opos=0; opos<top; pos--,opos++) {
      buf[opos] = tbuf[pos];
   }
   buf[opos] = 0;
}

void itoa_s(int i,unsigned base,char* buf) {
   if (base > 16) return;
   if (i < 0) {
      *buf++ = '-';
      i *= -1;
   }
   itoa(i,base,buf);
}

unsigned DebugSetColor (const unsigned c) {

	unsigned t=_color;
	_color=c;
	return t;
}

void DebugGotoXY (unsigned x, unsigned y) {

	// reposition starting vectors for next text to follow
	// multiply by 2 do to the video modes 2byte per character layout
	_xPos = x*2;
	_yPos = y*2;
	_startX=_xPos;
	_startY=_yPos;
}

void DebugClrScr (const unsigned short c) {

	unsigned char* p = (unsigned char*)VID_MEMORY;
	//if(c == 0x00) c = _color;

	for (int i=0; i<160*30; i+=2) {

		p[i] = ' ';  /* Need to watch out for MSVC++ optomization memset() call */
		p[i+1] = c;
	}

	// go to start of previous set vector
	_xPos=_startX;_yPos=_startY;
}

char getPixel(short x, short y)
{
	volatile unsigned char* p = (unsigned char*)VID_MEMORY;
	int lin = x + y * COLS;
	return p[lin*2];
}

void setPixel(short x, short y, char c)
{
	volatile unsigned char* p = (unsigned char*)VID_MEMORY;
	int lin = x + y * COLS;
	p[lin*2] = c;
}

extern void DebugScrollUp()
{
	volatile unsigned char* p = (unsigned char*)VID_MEMORY;
	for(int y = 0; y < LINE; y++)
	{
		memcpy((char*)(VID_MEMORY + y*COLS*2+COLS*2), (char*)(VID_MEMORY + y*COLS*2), COLS*2);
		//memset((char*)(VID_MEMORY + y*COLS*2+COLS*2), COLS*2, ' ');
	}
	_yPos -= 2;
	//DebugGotoXY(_startX/2,_startY/2-1);
}

void DebugPuts (char* str) {

	if (!str)
		return;

	for (size_t i=0; i<strlen (str); i++)
		DebugPutc (str[i]);
}

int DebugPrintf (const char* str, ...) {

	if(!str)
		return 0;

	va_list		args;
	va_start (args, str);

	for (size_t i=0; i<strlen(str);i++) {

		switch (str[i]) {

			case '%':

				switch (str[i+1]) {

					/*** characters ***/
					case 'c': {
						char c = va_arg (args, char);
						DebugPutc (c);
						i++;		// go to next character
						break;
					}

					/*** address of ***/
					case 'a': {
						int c = (int&) va_arg (args, char);
						char str[32]={0};
						itoa_s (c, 16, str);
						DebugPuts (str);
						i++;		// go to next character
						break;
					}
							   
					/*** string **/
					case 's': {
						int c = (int&) va_arg (args, char);
						char str[128];
						strcpy (str,(const char*)c);
						DebugPuts (str);
						i++;		// go to next character
						break;

					}

					/*** integers ***/
					case 'd':
					case 'i': {
						int c = va_arg (args, int);
						char str[32]={0};
						itoa_s (c, 10, str);
						DebugPuts (str);
						i++;		// go to next character
						break;
					}

					/*** display in hex ***/
					case 'X':
					case 'x': {
						int c = va_arg (args, int);
						char str[32]={0};
						itoa_s (c,16,str);
						DebugPuts (str);
						i++;		// go to next character
						break;
					}

					default:
						va_end (args);
						return 1;
				}

				break;

			default:
				DebugPutc (str[i]);
				break;
		}

	}

	va_end (args);
}