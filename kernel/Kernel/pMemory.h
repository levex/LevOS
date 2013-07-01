#ifndef __PMEMORY__H__
#define __PMEMORY__H__

extern void _cdecl memcpy(char* from, char* to, int count); // fast memcpy
extern void memcpyTF(char* to, char* from, int count); // other memcpy
extern unsigned short* _cdecl memsetw(unsigned short *dest, unsigned short val, size_t count);
extern void* _cdecl memset(void *dest, char val, size_t count);
extern void* _cdecl malloc(int bytes); // malloc
extern void* _cdecl malloc_p(int bytes); // allocates int bytes minimum but aligns to the next possible 4K boundary. (last free 3 binary digits shall be zero)
extern void* _cdecl malloc_ps(char* start, int bytes); // allocates int bytes at that start page aligned
extern bool _cdecl pm_setup(char* heap); // sets up the physical memory manager

#endif