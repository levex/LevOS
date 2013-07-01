#include "V8086.h"
#include "pMemory.h"


FARPTR i386LinearToFp(void *ptr)
{
    unsigned seg, off;
    off = (int) ptr & 0xf;
    seg = ((int) ptr - ((int) ptr & 0xf)) / 16;
    return MK_FP(seg, off);
}

void v86_init(uregs* regs)
{
	// step 1: allocate a stack below 1MB
	static char* v86_stack = (char*)0xFFFF;
	// step 2: set up the regs
	memset(regs, 0, sizeof(uregs));
	regs->user_esp = 0xFFFF; // stack begins at 0xFFFF
	regs->user_ss = 0; // set stack segment
	regs->fs = regs->ds = regs->gs = regs->es = 0x8; // set selectors
	regs->eflags = 0x00020002L; // VM = 1, IOPL = 0
}