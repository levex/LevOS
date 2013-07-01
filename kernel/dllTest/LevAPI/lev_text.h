#ifndef __LEV_TEXT_H_
#define __LEV_TEXT_H_

DLLIMPORT void print(char* str);
DLLIMPORT void _cdecl printchar(char c);
DLLIMPORT void _cdecl printNumber(int i);
DLLIMPORT void _cdecl printHexa(int i);

DLLIMPORT void _cdecl clearScreen();

DLLIMPORT void _cdecl moveCursorRelative(char rx, char ry);

#endif