/*
====================================================
	entry.cpp
		-This is the kernel entry point. This is called
		from the boot loader
====================================================
*/

extern void _cdecl main ();
extern void _cdecl InitializeConstructors();
extern void _cdecl Exit ();

void _cdecl kernel_entry () {

#ifdef ARCH_X86
	_asm {
		cli						// clear interrupts--Do not enable them yet
		mov ax, 10h				// offset 0x10 in gdt for data selector, remember?
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov ss, ax				// Set up base stack
		mov esp, 0x90000
		mov ebp, esp			// store current stack pointer
		push ebp
	}
#endif

	//! Execute global constructors
	InitializeConstructors();

	//!	Call kernel entry point
	main ();

	//! Cleanup all dynamic dtors
	Exit ();

#ifdef ARCH_X86
	_asm cli
#endif
	for (;;);
}
