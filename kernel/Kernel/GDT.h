#ifndef _GDT_H_INCLUDED
# define _GDT_H_INCLUDED

#include <stdint.h>

// maximum amount of descriptors allowed
#define MAX_DESCRIPTORS					5

/***	 gdt descriptor access bit flags.	***/

// set access bit
#define I86_GDT_DESC_ACCESS			0x0001			//00000001

// descriptor is readable and writable. default: read only
#define I86_GDT_DESC_READWRITE			0x0002			//00000010

// set expansion direction bit
#define I86_GDT_DESC_EXPANSION			0x0004			//00000100

// executable code segment. Default: data segment
#define I86_GDT_DESC_EXEC_CODE			0x0008			//00001000

// set code or data descriptor. defult: system defined descriptor
#define I86_GDT_DESC_CODEDATA			0x0010			//00010000

// set dpl bits
#define I86_GDT_DESC_DPL			0x0060			//01100000

// set "in memory" bit
#define I86_GDT_DESC_MEMORY			0x0080			//10000000

/**	gdt descriptor grandularity bit flags	***/

// masks out limitHi (High 4 bits of limit)
#define I86_GDT_GRAND_LIMITHI_MASK		0x0f			//00001111

// set os defined bit
#define I86_GDT_GRAND_OS			0x10			//00010000

// set if 32bit. default: 16 bit
#define I86_GDT_GRAND_32BIT			0x40			//01000000

// 4k grandularity. default: none
#define I86_GDT_GRAND_4K			0x80			//10000000

#ifdef _MSC_VER
#pragma pack (push, 1)
#endif

struct gdt_descriptor {

	// bits 0-15 of segment limit
	uint16_t		limit;

	// bits 0-23 of base address
	uint16_t		baseLo;
	unsigned char			baseMid;

	// descriptor access flags
	unsigned char			flags;

	unsigned char			grand;

	// bits 24-32 of base address
	unsigned char			baseHi;
};

#ifdef _MSC_VER
#pragma pack (pop)
#endif

// Setup a descriptor in the Global Descriptor Table
extern void gdt_set_descriptor(uint32_t i, uint64_t base, uint64_t limit, unsigned char access, unsigned char grand);

// returns descritor
extern gdt_descriptor* i86_gdt_get_descriptor (int i);

// initializes gdt
extern	int i86_gdt_initialize ();

extern bool i86_gdt_setup (int loc);
#endif
