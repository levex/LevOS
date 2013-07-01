#ifndef __VMEMORY__H__
#define __VMEMORY__H__

extern bool _cdecl vm_setup(void* pagedirectory); // setting up...
extern void _cdecl vm_map_virt_to_phys(int virtTableId, int physLoc); // maps a page
extern bool _cdecl vm_enable_paging(); // enables paging
extern int _cdecl vm_transform(int addr); // transforms virtual address to physical address

#endif