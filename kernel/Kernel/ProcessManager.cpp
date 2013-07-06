#include "ProcessManager.h"
#include "vMemory.h"
#include "DebugDisplay.h"
#include "HComm.h"
#define MAX_NUMBER_OF_PROCESSES 8

static PROCESS* _currentP;
static PROCESS* processList[MAX_NUMBER_OF_PROCESSES];
static int numberOfProcesses = 0;
static int currentProcessId = 0;
static int next = 0;
static int d = 0;

static bool _ism = false;

static char* kEBP = 0;
static char* kESP = 0;

static unsigned char* lastStackTop = (unsigned char*)0xBFC00000;

void saveKernelStack()
{
	_asm mov kEBP, ebp
	_asm mov kESP, esp
}

void restoreKernelStack()
{
	_asm mov ebp, kEBP
	_asm mov esp, kESP
}

unsigned char* allocStack(PROCESS* p)
{
	lastStackTop += 4096;
	DebugPrintf("\n   Stack allocated at: 0x%x growing downwards!", lastStackTop);
	p->stack_top = lastStackTop;
	p->regs.esp = (unsigned int)p->stack_top;
	/*p->regs.esp-- = 0;
	p->regs.esp-- = 0;
	p->regs.esp-- = 0;
	p->regs.esp-- = 0;
	p->regs.esp-- = 0;
	p->regs.esp-- = 0;
	p->regs.esp-- = 0;*/
	return lastStackTop;
}

/*void initProcessManager()
{
	for(int i = 0; i < MAX_NUMBER_OF_PROCESSES; i++)
	{
		processList[i] = 0;
	}
	_currentP = 0;
}

PROCESS* getCurrentProc()
{
	return _currentP;
}
void setCurrentProc(PROCESS* p)
{
	_currentP = p;
}

void addProcess(PROCESS* p)
{
	if(p->pid >= MAX_NUMBER_OF_PROCESSES) return;
	//DebugPrintf("adding process");
	processList[p->pid] = p;
	numberOfProcesses++;
}

void startMultitask()
{
	_ism = true;
}

void switchTasks(int eip)
{
	return;
	if(!_ism)return;
	if(numberOfProcesses<=1)return;
	if(_currentP == 0) return;
	/* step one: grab new process 
	_currentP->regs->eip = eip;
	next = _currentP->pid + 1;
	if(next > numberOfProcesses - 1) next = 0;
	_currentP = processList[next];
	d = _currentP->regs->eip;
																	//DebugPrintf("\nnextpid=0x%xH", next);
																	_asm xchg bx, bx
	_asm { // send EOI to primary PIC
		mov dx, 0x20
		mov al, 0x20
		out dx, al
	}
	//_asm jmp d
	//_asm popad
	_asm pop ebx // fix C
	_asm pop ebp // fix C
	_asm pushfd
	_asm push 0x8
	_asm push d
	_asm iretd
}*/