#include "ProcessManager.h"
#include "vMemory.h"
#include "DebugDisplay.h"
#include "HComm.h"
#define MAX_NUMBER_OF_PROCESSES 8

static PROCESS _currentP;
static PROCESS processList[MAX_NUMBER_OF_PROCESSES];
static int numberOfProcesses = 0;
static int currentProcessId = 0;

static bool _ism = false;

static char* kEBP = 0;
static char* kESP = 0;

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

PROCESS getCurrentProc()
{
	return _currentP;
}
void setCurrentProc(PROCESS p)
{
	_currentP = p;
}

void addProcess(PROCESS p)
{
	if(p.pid >= MAX_NUMBER_OF_PROCESSES) return;
	//DebugPrintf("adding process");
	processList[p.pid] = p;
	numberOfProcesses++;
}

void startMultitask()
{
	_ism = true;
}

void switchTasks(int eip)
{
	//_asm cli
	//if(!_ism)return;
	//DebugPrintf("EIP=0x%x\n", eip);
	//return;
	return;
	if(numberOfProcesses<=1)return;
	_currentP = processList[0];
	_asm xchg bx, bx
	// first step, save registers!
	_currentP.regs->eip = eip;
	int d = 0;
	_asm mov d, eax
	_currentP.regs->eax = d;
	_asm mov d, ebx
	_currentP.regs->ebx = d;
	_asm mov d, ecx
	_currentP.regs->ecx = d;
	_asm mov d, edx
	_currentP.regs->edx = d;
	_asm mov d, esi
	_currentP.regs->esi = d;
	_asm mov d, edi
	_currentP.regs->edi = d;
	//second step, save stack 
	_asm mov d, ebp
	_currentP.regs->esp = d;
	_currentP.stackBase = (unsigned char*)d;
	_asm mov d, esp
	_currentP.stackPointer = (unsigned char*)d;
	_currentP.regs->esp = d;
	// now that we have saved the process, lets setup the enviroment for the next process
	processList[currentProcessId] = _currentP;
	currentProcessId = (currentProcessId + 1)%numberOfProcesses;
	_currentP = processList[currentProcessId];
	// restore their registers
	d = _currentP.regs->eax;
	_asm mov eax, d
	d = _currentP.regs->ebx;
	_asm mov ebx, d
	d = _currentP.regs->ecx;
	_asm mov ecx, d
	d = _currentP.regs->edx;
	_asm mov edx, d
	d = _currentP.regs->esi;
	_asm mov esi, d
	d = _currentP.regs->edi;
	_asm mov edi, d
	//d = _currentP.regs->ebp;
	// restore their stack!
	//_asm mov ebp, d
	//d = _currentP.regs->esp;
	//_asm mov esp, d
	d = _currentP.regs->eip;
	_asm mov eax, d
	//_asm sti
	interruptdone(0);
	_asm pushfd
	_asm push cs
	_asm push eax
	_asm iret
}