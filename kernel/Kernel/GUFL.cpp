#include "GUFL.h"
#include "PELoader.h"
#define GUFL_MAX_NUMBER_OF_LOADERS 16

static LOADER loaderList[GUFL_MAX_NUMBER_OF_LOADERS] = {};

bool GUFL_init()
{
	for(int i = 0; i < GUFL_MAX_NUMBER_OF_LOADERS; i++)
	{
		loaderList[i].valid = false;
		loaderList[i].load = 0;
		loaderList[i].verify = 0;
	}
	return true;
}

unsigned int GUFL_registerLoader(LOADER* l)
{
	if(!l->valid) return 0;
	for(int i = 0; i < GUFL_MAX_NUMBER_OF_LOADERS; i++)
	{
		if(!loaderList[i].valid)
		{
			loaderList[i].valid = true;
			loaderList[i].load = l->load;
			loaderList[i].verify = l->verify;
			return i;
		}
	}
	return 0;
}
LOADER* GUFL_getLoader(int i)
{
	return &loaderList[i];
}
