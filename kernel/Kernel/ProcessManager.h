#ifndef __PROCESSMANAGER_H_
#define __PROCESSMANAGER_H_

#include "PE.h"

typedef struct __registers {
   int esp;
   int ebp;
   int eip;
   int edi;
   int esi;
   int eax;
   int ebx;
   int ecx;
   int edx;
   int flags;
} trapframe;

typedef struct __PROCESS {
	unsigned char pid;
	PeOptionalHeader* optionalHeader;
	PeHeader* PEHeader;
	unsigned char* stackBase;
	unsigned char* stackPointer;
	unsigned char* myPhysicalBase;
	unsigned char myVirtualTableId;
	trapframe* regs;
} PROCESS;

extern PROCESS getCurrentProc();
extern void setCurrentProc(PROCESS p);
extern void addProcess(PROCESS p);

extern void startMultitask();

extern void switchTasks(int eip);

extern void saveKernelStack();
extern void restoreKernelStack();

#endif