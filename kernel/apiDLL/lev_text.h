#ifndef __LEV_TEXT_H_
#define __LEV_TEXT_H_

DLLEXPORT void print(char* str);
DLLEXPORT void _cdecl printchar(char c);
DLLEXPORT void _cdecl printNumber(int i);
DLLEXPORT void _cdecl printHexa(int i);

DLLEXPORT void _cdecl clearScreen();

DLLEXPORT void _cdecl moveCursorRelative(char rx, char ry);

#endif