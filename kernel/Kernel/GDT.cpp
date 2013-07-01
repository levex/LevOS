#include "gdt.h"
#include "pMemory.h"

#ifdef _MSC_VER
#pragma pack (push, 1)
#endif

struct gdtr {

	// size of gdt
	uint16_t		m_limit;

	// base address of gdt
	uint32_t		m_base;
};

#ifdef _MSC_VER
#pragma pack (pop, 1)
#endif

// global descriptor table is an array of descriptors
static struct gdt_descriptor*	_gdt = (gdt_descriptor*)0xFFFFFFFFFFFF;

// gdtr data
static struct gdtr				_gdtr;

// install gdtr
static void gdt_install ();

bool i86_gdt_setup (int loc)
{
	_gdt = (gdt_descriptor*)loc;
	i86_gdt_initialize();
	return ((int)_gdt==loc);
}

// install gdtr
static void gdt_install () {
	_asm lgdt [_gdtr]
}

// Setup a descriptor in the Global Descriptor Table
void gdt_set_descriptor(uint32_t i, uint64_t base, uint64_t limit, unsigned char access, unsigned char grand)
{
	if (i > MAX_DESCRIPTORS)
		return;

	// null out the descriptor
	memset ((void*)&_gdt[i], 0, sizeof (gdt_descriptor));

	// set limit and base addresses
	_gdt[i].baseLo	= uint16_t(base & 0xffff);
	_gdt[i].baseMid	= unsigned char((base >> 16) & 0xff);
	_gdt[i].baseHi	= unsigned char((base >> 24) & 0xff);
	_gdt[i].limit	= uint16_t(limit & 0xffff);

	// set flags and grandularity bytes
	_gdt[i].flags = access;
	_gdt[i].grand = unsigned char((limit >> 16) & 0x0f);
	_gdt[i].grand |= grand & 0xf0;
}


// returns descriptor in gdt
gdt_descriptor* i86_gdt_get_descriptor (int i) {

	if (i > MAX_DESCRIPTORS)
		return 0;

	return &_gdt[i];
}


// initialize gdt
int i86_gdt_initialize () {

	// set up gdtr
	_gdtr.m_limit = (sizeof (struct gdt_descriptor) * MAX_DESCRIPTORS)-1;
	_gdtr.m_base = (uint32_t)&_gdt[0];

	// set null descriptor
	gdt_set_descriptor(0, 0, 0, 0, 0);

	// set default code descriptor
	gdt_set_descriptor (1,0,0xffffffff,
		I86_GDT_DESC_READWRITE|I86_GDT_DESC_EXEC_CODE|I86_GDT_DESC_CODEDATA|I86_GDT_DESC_MEMORY,
		I86_GDT_GRAND_4K | I86_GDT_GRAND_32BIT | I86_GDT_GRAND_LIMITHI_MASK);

	// set default data descriptor
	gdt_set_descriptor (2,0,0xffffffff,
		I86_GDT_DESC_READWRITE|I86_GDT_DESC_CODEDATA|I86_GDT_DESC_MEMORY,
		I86_GDT_GRAND_4K | I86_GDT_GRAND_32BIT | I86_GDT_GRAND_LIMITHI_MASK);
	// set real mode code desc
	gdt_set_descriptor (3,0,0xfffff,
		I86_GDT_DESC_READWRITE|I86_GDT_DESC_EXEC_CODE|I86_GDT_DESC_CODEDATA|I86_GDT_DESC_MEMORY,
		0);
	// set real mode data desc
	gdt_set_descriptor (4,0,0xfffff,
		I86_GDT_DESC_READWRITE|I86_GDT_DESC_CODEDATA|I86_GDT_DESC_MEMORY,
		0);

	// install gdtr
	gdt_install ();

	return 0;
}

