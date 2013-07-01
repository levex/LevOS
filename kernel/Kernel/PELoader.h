#ifndef __PELOADER_H_
#define __PELOADER_H_

#include "PE.h"

extern bool PE_mapApp(char* filename, int base);
extern bool PE_dumpApp(char* filename, int base);
extern bool PE_verify(int base);

#endif