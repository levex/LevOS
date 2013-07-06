#include "idt.h"
#include "pit.h"
#include "pic.h"
#include "HComm.h"
#include "ProcessManager.h"
#include "DebugDisplay.h"

//-----------------------------------------------
//	Controller Registers
//-----------------------------------------------

#define		I86_PIT_REG_COUNTER0		0x40
#define		I86_PIT_REG_COUNTER1		0x41
#define		I86_PIT_REG_COUNTER2		0x42
#define		I86_PIT_REG_COMMAND			0x43


// Global Tick count
static volatile uint32_t			_pit_ticks=0;

// Test if pit is initialized
static bool							_pit_bIsInit=false;
static int _eip = 0;
static int _cs = 0;
static int _eax = 0;

static PROCESS* processList[16];
static PROCESS* currentProcess = 0;
static int currentPID = 0;
static int numberOfProcesses = 0;
static bool _ism = false;
static int dummy = 0;

// pit timer interrupt handler
void _cdecl i86_pit_irq ();

void initProcessManager()
{
	for(int i = 0; i < 16; i++)
	{
		processList[i] = 0;
	}
	currentPID = 0;
	numberOfProcesses = 0;
	_ism = false;
}
void addProcess(PROCESS* p)
{
	//DebugPutc('A');
	if(!p->valid) return;
	//DebugPutc('B');
	for(int i = 0;i<16; i++)
	{
		//DebugPutc('C');
		if(processList[i] == 0 || !processList[i]->valid)
		{
			p->valid = true;
			p->pid = i;
			processList[i] = p;
			numberOfProcesses++;
			DebugPrintf("\nInitialized PROCESS PID=%d EIP=0x%x num=%d ESP=0x%x", i, processList[i]->eip, numberOfProcesses, processList[i]->regs.esp);
			//DebugPutc('E');
			return;
		}
	}
	DebugPrintf("\nFalied to initialize PROCESS");
	return;
}
void setCurrentProc(PROCESS* p)
{
	if(p == 0) return;
	currentPID = p->pid;
	currentProcess = processList[currentPID];
}
void startMultitask()
{
	_ism = true;
}


//	pit timer interrupt handler
/* STACK AFTER IRQ */
/*
	EFLAGS
	CS
	EIP
	RANDOM C
	RANDOM C
	RANDOM C
*/
void _cdecl i86_pit_irq () {
	_asm add esp, 12 // remove C overhead
	if(_ism)
	{
		//_asm xchg bx, bx
		_asm mov _eax, eax // save eax
		_asm pop eax // move EIP in to eax
		_asm xchg bx, bx
		_asm push eax // move it back
		_asm mov _eip, eax // save EIP
		_asm mov eax, _eax // restore EAX
		//_asm add esp, 12 // remove IRQ return
	}
	 if(!_ism) _asm pushad // save registers
	// increment tick count
	//_pit_ticks++;
	//switchTasks(_eip);
	// switch tasks here instead
	if(_ism) {
multitask:
		_asm add esp, 12 // remove IRQ crap from process stack
		/*_asm push eax
		_asm push ebx
		_asm push ecx
		_asm push edx
		_asm push esi
		_asm push edi
		_asm push ebp*/ // push his regs
		//save current
		processList[currentPID]->eip = _eip;
		processList[currentPID]->ran = true;
		_asm mov dummy, esp // save the ESP
		processList[currentPID]->regs.esp = dummy; // .
		// select new
		currentPID++;
		if(currentPID > numberOfProcesses - 1) currentPID = 0;
		currentProcess = processList[currentPID];
		// jump to new
		//_asm xchg bx, bx
		//_asm popad
		// restore new
		_eip = processList[currentPID]->eip;
		dummy = processList[currentPID]->regs.esp;
		if(processList[currentPID]->ran) {
			_asm mov esp, dummy // get ESP from new
			_asm pop ebp
			_asm pop edi
			_asm pop esi
			_asm pop edx
			_asm pop ecx
			_asm pop ebx
			_asm pop eax // restore his regs
		}
		_asm sti // enable interrupts so EFLAGS will have IF set
		_asm pushfd // push EFLAGS
		_asm push 0x8  // push CS (0x8)
		_asm push _eip  // push the new's EIP
		_asm { // send EOI to primary PIC
			push eax
			mov al,20h
			out 20h, al
			pop eax
		}
		_asm iretd // return to new process
	}
	_pit_ticks++;
	// tell hal we are done
	interruptdone(0);

	_asm popad // restore registers
	_asm iretd // jump back
}

// Sets new pit tick count and returns prev. value
uint32_t i86_pit_set_tick_count (uint32_t i) {

	uint32_t ret = _pit_ticks;
	_pit_ticks = i;
	return ret;
}


// returns current tick count
uint32_t i86_pit_get_tick_count () {

	return _pit_ticks;
}


// send command to pit
void i86_pit_send_command (uint8_t cmd) {

	outport (I86_PIT_REG_COMMAND, cmd);
}


// send data to a counter
void i86_pit_send_data (uint16_t data, uint8_t counter) {

	uint8_t	port= (counter==I86_PIT_OCW_COUNTER_0) ? I86_PIT_REG_COUNTER0 :
		((counter==I86_PIT_OCW_COUNTER_1) ? I86_PIT_REG_COUNTER1 : I86_PIT_REG_COUNTER2);

	outport (port, (uint8_t)data);
}


// read data from counter
uint8_t i86_pit_read_data (uint16_t counter) {

	uint8_t	port= (counter==I86_PIT_OCW_COUNTER_0) ? I86_PIT_REG_COUNTER0 :
		((counter==I86_PIT_OCW_COUNTER_1) ? I86_PIT_REG_COUNTER1 : I86_PIT_REG_COUNTER2);

	return inport (port);
}


// starts a counter
void i86_pit_start_counter (uint32_t freq, uint8_t counter, uint8_t mode) {

	if (freq==0)
		return;

	uint16_t divisor = uint16_t(1193181 / (uint16_t)freq);

	// send operational command
	uint8_t ocw=0;
	ocw = (ocw & ~I86_PIT_OCW_MASK_MODE) | mode;
	ocw = (ocw & ~I86_PIT_OCW_MASK_RL) | I86_PIT_OCW_RL_DATA;
	ocw = (ocw & ~I86_PIT_OCW_MASK_COUNTER) | counter;
	i86_pit_send_command (ocw);

	// set frequency rate
	i86_pit_send_data (divisor & 0xff, 0);
	i86_pit_send_data ((divisor >> 8) & 0xff, 0);

	// reset tick count
	_pit_ticks=0;
}


// initialize minidriver
bool _cdecl i86_pit_initialize () {

	// Install our interrupt handler (irq 0 uses interrupt 32)
	setint(32, i86_pit_irq);

	// we are initialized
	_pit_bIsInit = true;

	return true;
}


// test if pit interface is initialized
bool _cdecl i86_pit_is_initialized () {

	return _pit_bIsInit;
}
