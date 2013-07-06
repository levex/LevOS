#ifndef __PROCESSMANAGER_H_
#define __PROCESSMANAGER_H_

#include "PE.h"

typedef struct {
	unsigned int eax;
	unsigned int ebx;
	unsigned int ecx;
	unsigned int edx;
	unsigned int esi;
	unsigned int edi;
	unsigned int esp;
	unsigned int ebp;
} REGISTER_DUMP;

typedef struct __PROCESS {
	bool valid;
	bool ran;
	unsigned char* stack_top;
	unsigned char pid;
	unsigned int eip;
	REGISTER_DUMP regs;
} PROCESS;

extern unsigned char* allocStack(PROCESS* p);

/*extern PROCESS* getCurrentProc();
extern void setCurrentProc(PROCESS* p);
extern void addProcess(PROCESS* p);

extern void startMultitask();

extern void switchTasks(int eip);

extern void initProcessManager();

extern void saveKernelStack();
extern void restoreKernelStack();*/

#endif