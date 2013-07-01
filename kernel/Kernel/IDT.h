#ifndef _IDT_H
#define _IDT_H

#include <stdint.h>

#define I86_MAX_INTERRUPTS		256

#define I86_IDT_DESC_BIT16		0x06	//00000110
#define I86_IDT_DESC_BIT32		0x0E	//00001110
#define I86_IDT_DESC_RING1		0x40	//01000000
#define I86_IDT_DESC_RING2		0x20	//00100000
#define I86_IDT_DESC_RING3		0x60	//01100000
#define I86_IDT_DESC_PRESENT		0x80	//10000000

// interrupt handler w/o error code
typedef void (_cdecl *I86_IRQ_HANDLER)(void);

#ifdef _MSC_VER
#pragma pack (push, 1)
#endif

// interrupt descriptor
struct idt_descriptor {

	// bits 0-16 of interrupt routine (ir) address
	uint16_t		baseLo;

	// code selector in gdt
	uint16_t		sel;

	// reserved, shold be 0
	unsigned char			reserved;

	// bit flags. Set with flags above
	unsigned char			flags;

	// bits 16-32 of ir address
	uint16_t		baseHi;
};

#ifdef _MSC_VER
#pragma pack (pop)
#endif

// returns interrupt descriptor
extern idt_descriptor* i86_get_ir (uint32_t i);

// installs interrupt handler. When INT is fired, it will call this callback
extern int i86_install_ir (uint32_t i, uint16_t flags, uint16_t sel, I86_IRQ_HANDLER);

// initialize basic idt
extern int i86_idt_initialize (uint16_t codeSel);
// setup i86_idt
extern bool i86_setup(int loc);
// fire an interrupt
extern void geninterrupt (int n);
#endif
