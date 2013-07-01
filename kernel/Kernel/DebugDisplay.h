#ifndef _DEBUGDISPLAY_H
#define _DEBUGDISPLAY_H

extern void DebugClrScr (const unsigned short c);
extern void DebugPuts (char* str);
extern void DebugPutc (unsigned char c);
extern int DebugPrintf (const char* str, ...);
extern unsigned DebugSetColor (const unsigned c);
extern void DebugGotoXY (unsigned x, unsigned y);
extern void DebugScrollUp();
extern int DebugGetY();
extern int DebugGetX();
extern void DebugGotoRXY (unsigned x, unsigned y);
#endif
