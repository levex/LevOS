#ifndef __REALMODEWRAPPER_H_
#define __REALMODEWRAPPER_H_

typedef struct {
	char ah;
	char al;
} regs_t;

extern void _cdecl doRealModeInterrupt(char i, char _ah, char _al);

#endif