#ifndef __LEV_VGA_H_
#define __LEV_VGA_H_

DLLEXPORT void _cdecl VGA_init();
DLLEXPORT void _cdecl VGA_deinit();
DLLEXPORT void _cdecl VGA_clear();
DLLEXPORT void _cdecl VGA_putpixel(int x, int y, char color);
DLLEXPORT void _cdecl VGA_putimage(int x, int y, char* filename);
DLLEXPORT void _cdecl VGA_putstring(int x, int y, char* str);
DLLEXPORT void _cdecl VGA_putchar(int x, int y, char c, char col);
DLLEXPORT void _cdecl VGA_putline(int x0, int y0, int x1, int y1);
DLLEXPORT void _cdecl VGA_putrect(int x0, int y0, int x1, int y1);
DLLEXPORT void _cdecl VGA_setcolor(char c);

DLLEXPORT char _cdecl VGA_getcolor();
DLLEXPORT void _cdecl VGA_clearrect(int startX, int endX, int startY, int endY);

#endif