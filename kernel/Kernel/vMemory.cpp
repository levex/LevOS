#include "vMemory.h"
#include "pMemory.h"

unsigned int* pd;
unsigned int* last_page;

bool vm_setup(void* pagedirectory)// setting up...
{
	pd = (unsigned int*)pagedirectory;
	int i = 0;
	for(i = 0; i < 1024; i++)
	{
		//attribute: supervisor level, read/write, not present.
		pd[i] = 0 | 2; 
	}
	return (pd == pagedirectory)?true:false;
}
void vm_map_virt_to_phys(int virtTableId, int physLoc)// maps a 4MB
{
	int i;
	for(i = 0; i < 1024; i++)
	{
		last_page[i] = physLoc | 3; // attributes: supervisor level, read/write, present.
		physLoc = physLoc + 4096; //advance the address to the next page boundary
	}
	pd[virtTableId] = (unsigned int)last_page|3;
	pd[virtTableId] |= 3;
	last_page = (unsigned int*)(((unsigned int)last_page)+(4*1024));
}

int _cdecl vm_transform(int addr)
{
	return addr - 0xC0000000 + 0x100000;
}

bool vm_enable_paging()
{
	_asm {
		mov eax, [pd]
		mov cr3, eax

		mov eax, cr0
		or eax, 0x80000000
		mov cr0, eax
	}
	return true;
}

