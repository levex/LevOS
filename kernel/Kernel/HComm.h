#ifndef __HCOMM_H_
#define __HCOMM_H_
#include "IDT.h"

#define interrupt __declspec (naked)


extern void outport(unsigned short portid, unsigned char value);
extern unsigned char inport(unsigned short port);
extern unsigned int _cdecl inportW(unsigned short portid);
extern void _cdecl outportW(unsigned short portid, unsigned int value);

extern void setint(int i, I86_IRQ_HANDLER h);
extern inline void _cdecl	interruptdone (unsigned int intno);

extern void sleep(int i);

extern int getFileSize(char* file);
extern char loadFileToLoc(char* file, void* loc);

#endif