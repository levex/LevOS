#include "pMemory.h"

static char* HEAP = 0x000000;
static unsigned int _last = 0;

void memcpy(char* from, char* to, int count)
{
    while (count--) {
        *to++ = *from++;
    }
}

void memcpyTF(char* to, char* from, int count)
{
    while (count--) {
        *to++ = *from++;
    }
}

// sets count bytes of dest to val
void *memset(void *dest, char val, size_t count)
{
    unsigned char *temp = (unsigned char *)dest;
	for( ; count != 0; count--, temp[count] = val);
	return dest;
}

// sets count bytes of dest to val
unsigned short *memsetw(unsigned short *dest, unsigned short val, size_t count)
{
    unsigned short *temp = (unsigned short *)dest;
    for( ; count != 0; count--)
		*temp++ = val;
    return dest;
}

bool pm_setup(char* heap)
{
	HEAP = heap;
	//_last = (unsigned int)&HEAP;
	return (heap == HEAP)?true:false;
}

void* malloc(int bytes)
{
	void* ret;
	ret = (void*)HEAP;
	HEAP += bytes;
	return ret;
}
void* malloc_p(int bytes)
{
	void* ret;
	ret = (void*)(((int)HEAP + 0x1000)&0xFFFFF000);
	HEAP = (char*)((int)ret + bytes);
	return ret;
}
void* malloc_ps(char* start, int bytes)
{
	return start;
}