#ifndef __LEV_VGA_H_
#define __LEV_VGA_H_
#define DLLIMPORT extern "C" __declspec(dllimport)
DLLIMPORT void _cdecl VGA_init();
DLLIMPORT void _cdecl VGA_deinit();
DLLIMPORT void _cdecl VGA_clear();
DLLIMPORT void _cdecl VGA_putpixel(int x, int y, char color);
DLLIMPORT void _cdecl VGA_putimage(int x, int y, char* filename);
DLLIMPORT void _cdecl VGA_putstring(int x, int y, char* str);
DLLIMPORT void _cdecl VGA_putchar(int x, int y, char c);
DLLIMPORT void _cdecl VGA_putline(int x0, int y0, int x1, int y1);
DLLIMPORT void _cdecl VGA_putrect(int x0, int y0, int x1, int y1);
DLLIMPORT void _cdecl VGA_setcolor(char c);

DLLIMPORT char _cdecl VGA_getcolor();
DLLIMPORT void _cdecl VGA_clearrect(int startX, int endX, int startY, int endY);

#endif