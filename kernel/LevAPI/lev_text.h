#ifndef __LEV_TEXT_H_
#define __LEV_TEXT_H_

extern void print(char* str);
extern void _cdecl printchar(char c);
extern void _cdecl printNumber(int i);
extern void _cdecl printHexa(int i);

extern void _cdecl clearScreen();

extern void _cdecl moveCursorRelative(char rx, char ry);

#endif