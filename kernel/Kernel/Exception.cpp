#include "exception.h"
#include "HComm.h"
#include "string.h"
#include "DebugDisplay.h"
#include "VGAdriver.h"

void _cdecl kernel_panic (const char* fmt, ...)
{
	_asm cli
	char* r = (char*)fmt;
	/*if(isVGA())
	{
		for(int i = 0; i < strlen(fmt); i++)
		{
			VGA_put_char(0+i*8,0, *r++);
		}
		return;
	}
	DebugPrintf(fmt);*/
	for(int i = 0; i < strlen(fmt); i++)
	{
		outport(0xE9, *r++);
	}
	for (;;);
}


#define intstart() \
	_asm	cli \
	_asm	sub		ebp, 4


#pragma warning (disable:4100)

// divide by 0 fault
void _cdecl divide_by_zero_fault (uint32_t eflags,uint32_t cs,uint32_t eip, uint32_t other) {

	_asm {
		cli
		add esp, 12
		pushad
	}

	kernel_panic ("Divide by 0 at physical address [0x%x:0x%x] EFLAGS [0x%x] other: 0x%x",cs,eip, eflags, other);
	for (;;);
}

// single step
void interrupt _cdecl single_step_trap (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Single step");
	for (;;);
}

// non maskable interrupt trap
void interrupt _cdecl nmi_trap (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("NMI trap");
	for (;;);
}

// breakpoint hit
void interrupt _cdecl breakpoint_trap (unsigned int cs,unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Breakpoint trap");
	for (;;);
}

// overflow
void interrupt _cdecl overflow_trap (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Overflow trap");
	for (;;);
}

// bounds check
void interrupt _cdecl bounds_check_fault (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Bounds check fault");
	for (;;);
}

// invalid opcode / instruction
void interrupt _cdecl invalid_opcode_fault (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	DebugPrintf ("\n*** STOP: Invalid opcode at 0x%x:0x%x [EFLAGS=0x%X]", cs, eip, eflags);
	for (;;);
}

// device not available
void interrupt _cdecl no_device_fault (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Device not found");
	for (;;);
}

// double fault
void interrupt _cdecl double_fault_abort (unsigned int cs, unsigned int err, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Double fault");
	for (;;);
}

// invalid Task State Segment (TSS)
void interrupt _cdecl invalid_tss_fault (unsigned int cs,unsigned int err,  unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Invalid TSS");
	for (;;);
}

// segment not present
void interrupt _cdecl no_segment_fault (unsigned int cs,unsigned int err,  unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Invalid segment");
	for (;;);
}

// stack fault
void interrupt _cdecl stack_fault ( unsigned int cs,unsigned int err, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Stack fault");
	for (;;);
}

// general protection fault
void interrupt _cdecl general_protection_fault (unsigned int cs,unsigned int err, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("General Protection Fault");
	for (;;);
}


// page fault
void _cdecl page_fault (uint32_t err,uint32_t eflags,uint32_t cs,uint32_t eip) {

	_asm	cli
	_asm	sub		ebp, 4
	//kernel_panic("PAGEFAULT");

	int faultAddr=0;

	_asm {
		mov eax, cr2
		mov [faultAddr], eax
	}

	DebugPrintf("Page Fault at 0x%x:0x%x referenced memory at 0x%x",
		cs, eip, faultAddr);
	kernel_panic("Page fault!");
	for(;;);

	_asm popad
	_asm sti
	_asm iretd
}

// Floating Point Unit (FPU) error
void interrupt _cdecl fpu_fault (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("FPU Fault");
	for (;;);
}

// alignment check
void interrupt _cdecl alignment_check_fault (unsigned int cs,unsigned int err, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Alignment Check");
	for (;;);
}

// machine check
void interrupt _cdecl machine_check_abort (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("Machine Check");
	for (;;);
}

// Floating Point Unit (FPU) Single Instruction Multiple Data (SIMD) error
void interrupt _cdecl simd_fpu_fault (unsigned int cs, unsigned int eip, unsigned int eflags) {

	intstart ();
	kernel_panic ("FPU SIMD fault");
	for (;;);
}
