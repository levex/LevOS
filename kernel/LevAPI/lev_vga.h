#ifndef __LEV_VGA_H_
#define __LEV_VGA_H_

extern void _cdecl VGA_init();
extern void _cdecl VGA_deinit();
extern void _cdecl VGA_clear();
extern void _cdecl VGA_putpixel(int x, int y, char color);
extern void _cdecl VGA_putimage(int x, int y, char* filename);
extern void _cdecl VGA_putstring(int x, int y, char* str);
extern void _cdecl VGA_putchar(int x, int y, char c);
extern void _cdecl VGA_putline(int x0, int y0, int x1, int y1);
extern void _cdecl VGA_putrect(int x0, int y0, int x1, int y1);
extern void _cdecl VGA_setcolor(char c);
extern char _cdecl VGA_getcolor();
#endif